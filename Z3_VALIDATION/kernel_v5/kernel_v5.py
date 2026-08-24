"""Z3 kernel v5: parent-Love sufficiency and negative controls.

The model is deliberately modest. It tests whether frozen candidate predicates
discriminate declared failure modes and whether the repaired Cornell algebra has
the expected structure. It does not identify a solver predicate with agape.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from z3 import (
    And,
    Bool,
    BoolSort,
    Function,
    If,
    Not,
    Or,
    Real,
    RealSort,
    Solver,
    sat,
    unsat,
)


HERE = Path(__file__).resolve().parent


def check(obligation_id, name, assumptions, query, expected, note):
    solver = Solver()
    solver.add(*assumptions)
    solver.add(query)
    actual = solver.check()
    return {
        "id": obligation_id,
        "name": name,
        "expected": str(expected),
        "actual": str(actual),
        "passed": actual == expected,
        "model": str(solver.model()) if actual == sat else None,
        "note": note,
    }


def bare_binding_insufficiency():
    # The classifier receives only six physical observables. Consent is
    # intentionally absent from its function signature.
    physical_love = Function(
        "l_physical_classifier",
        RealSort(), RealSort(), RealSort(), RealSort(), RealSort(), RealSort(),
        BoolSort(),
    )
    left = [Real(f"l_left_{i}") for i in range(6)]
    right = [Real(f"l_right_{i}") for i in range(6)]
    consent_left, consent_right = Bool("l_consent_left"), Bool("l_consent_right")
    same_physics = [left[i] == right[i] for i in range(6)]
    different_consent = [consent_left, Not(consent_right)]
    distinguish = physical_love(*left) != physical_love(*right)
    return check(
        "LZ-01",
        "bare_physics_cannot_detect_hidden_consent",
        same_physics + different_consent,
        distinguish,
        unsat,
        "Equal physical inputs force equal classifier output when consent is not an input.",
    )


def relational_obligations():
    tests = []
    coupling = Real("l_coupling")
    consent_a, consent_b = Bool("l_consent_a"), Bool("l_consent_b")
    identity = Bool("l_identity_preserved")
    generative = Bool("l_generative")
    delta_a, delta_b = Real("l_delta_a"), Real("l_delta_b")

    active = coupling > 0
    voluntary = And(active, consent_a, consent_b)
    coercive = And(active, Or(Not(consent_a), Not(consent_b)))
    flourishing = And(delta_a >= 0, delta_b >= 0)
    full_candidate = And(voluntary, identity, flourishing, generative)

    tests.append(check(
        "LZ-02", "voluntary_and_coercive_are_disjoint", [],
        And(voluntary, coercive), unsat,
        "Frozen consent definitions forbid overlap of voluntary and coercive coupling.",
    ))
    tests.append(check(
        "LZ-03", "active_coupling_is_exhaustively_classified", [active],
        And(Not(voluntary), Not(coercive)), unsat,
        "Boolean consent makes active coupling either voluntary or coercive.",
    ))

    effective = coupling * If(consent_a, 1, 0) * If(consent_b, 1, 0)
    tests.append(check(
        "LZ-04", "consent_gate_blocks_effective_coupling", [coupling >= 0],
        And(Or(Not(consent_a), Not(consent_b)), effective != 0), unsat,
        "The declared multiplicative gate makes absent consent annihilate effective coupling.",
    ))

    tests.append(check(
        "LZ-05", "binding_alone_admits_coercion",
        [active, coercive], active, sat,
        "A weakened predicate equal to active binding accepts a coercive model.",
    ))
    tests.append(check(
        "LZ-06", "omitting_identity_admits_assimilation",
        [voluntary, flourishing, generative, Not(identity)],
        And(voluntary, flourishing, generative), sat,
        "All retained conditions can hold while identity preservation is false.",
    ))
    tests.append(check(
        "LZ-07", "omitting_flourishing_admits_exploitation",
        [voluntary, identity, generative, delta_a < 0],
        And(voluntary, identity, generative), sat,
        "All retained conditions can hold while one participant is harmed.",
    ))
    tests.append(check(
        "LZ-08", "generativity_is_independent",
        [voluntary, identity, flourishing, Not(generative)],
        And(voluntary, identity, flourishing), sat,
        "Generativity is not entailed by consent, identity, and flourishing alone.",
    ))

    captivity = And(active, coercive)
    codependency = And(voluntary, Not(identity))
    domination = And(voluntary, identity, Or(delta_a < 0, delta_b < 0))
    transactional = And(voluntary, identity, flourishing, Not(generative))
    for oid, name, mode in (
        ("LZ-09a", "captivity_fails_full_candidate", captivity),
        ("LZ-09b", "codependency_fails_full_candidate", codependency),
        ("LZ-09c", "domination_fails_full_candidate", domination),
        ("LZ-09d", "nongenerative_exchange_fails_full_candidate", transactional),
    ):
        tests.append(check(
            oid, name, [mode], full_candidate, unsat,
            "Declared negative-control mode cannot satisfy every full-candidate condition.",
        ))
    return tests


def fruit_label_and_slot_obligations():
    tests = []
    fruits = [Real(f"l_fruit_{i}") for i in range(9)]
    bounded = [And(value >= 0, value <= 1) for value in fruits]
    # Swap the proposed Peace and Faithfulness slots. With range constraints
    # alone the swapped vector remains admissible, exposing underdetermination.
    peace_index, faithfulness_index = 2, 6
    swapped = list(fruits)
    swapped[peace_index], swapped[faithfulness_index] = (
        fruits[faithfulness_index], fruits[peace_index]
    )
    swapped_bounded = [And(value >= 0, value <= 1) for value in swapped]
    tests.append(check(
        "LZ-10", "range_constraints_do_not_fix_fruit_labels",
        bounded + [fruits[peace_index] != fruits[faithfulness_index]],
        And(*swapped_bounded), sat,
        "A nonidentity Peace/Faithfulness swap survives when only output ranges are frozen.",
    ))

    curvature_1, curvature_2 = Real("l_curvature_1"), Real("l_curvature_2")
    energy_before, energy_after = Real("l_energy_before"), Real("l_energy_after")
    tests.append(check(
        "LZ-11", "local_stability_and_global_invariance_are_independent_slots",
        [curvature_1 > 0, curvature_2 > 0,
         energy_before == energy_after, curvature_1 != curvature_2],
        energy_before == energy_after, sat,
        "Conserved energy can remain fixed while local curvature varies across admissible systems.",
    ))
    return tests


def cornell_effective_obligations():
    tests = []

    # Concrete witness: alpha=k=mu=1 and L^2=2 gives r=1 since 1+1-2=0.
    radius = Real("l_witness_radius")
    tests.append(check(
        "LZ-12a", "effective_cornell_stationary_witness_exists", [],
        And(radius > 0, radius == 1,
            radius * radius * radius + radius - 2 == 0), sat,
        "A fully rational positive stationary-radius witness exists.",
    ))

    alpha, kappa, ell2_over_mu = (
        Real("l_alpha"), Real("l_kappa"), Real("l_ell2_over_mu")
    )
    r1, r2 = Real("l_r1"), Real("l_r2")
    positive = [alpha > 0, kappa > 0, ell2_over_mu > 0, r1 > 0, r2 > 0]
    stationary_1 = kappa * r1 * r1 * r1 + alpha * r1 == ell2_over_mu
    stationary_2 = kappa * r2 * r2 * r2 + alpha * r2 == ell2_over_mu
    tests.append(check(
        "LZ-12b", "effective_cornell_positive_stationary_radius_is_unique",
        positive + [stationary_1, stationary_2], r1 != r2, unsat,
        "Strict monotonicity of k*r^3+alpha*r forbids two positive roots.",
    ))

    radius_c = Real("l_curvature_radius")
    stationary_c = (
        kappa * radius_c * radius_c * radius_c + alpha * radius_c
        == ell2_over_mu
    )
    # Multiplying V'' by positive r^4 gives -2*alpha*r + 3*L^2/mu.
    curvature_numerator = -2 * alpha * radius_c + 3 * ell2_over_mu
    tests.append(check(
        "LZ-13", "effective_cornell_stationary_curvature_is_positive",
        [alpha > 0, kappa > 0, ell2_over_mu > 0, radius_c > 0, stationary_c],
        curvature_numerator <= 0, unsat,
        "At stationarity the numerator equals alpha*r+3*k*r^3, which is positive.",
    ))
    return tests


def hash_sources(paths):
    records = []
    for path in paths:
        resolved = path.resolve()
        records.append({
            "path": str(resolved),
            "exists": resolved.is_file(),
            "sha256": (
                hashlib.sha256(resolved.read_bytes()).hexdigest().upper()
                if resolved.is_file() else None
            ),
        })
    return records


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, action="append", default=[])
    parser.add_argument("--receipt-dir", type=Path, default=HERE / "receipts")
    args = parser.parse_args()

    tests = [bare_binding_insufficiency()]
    tests += relational_obligations()
    tests += fruit_label_and_slot_obligations()
    tests += cornell_effective_obligations()

    now = datetime.now(timezone.utc)
    result = {
        "schema": "theophysics-z3-receipt-v5",
        "generated_utc": now.isoformat(),
        "sources": hash_sources(args.source),
        "tests": tests,
        "counts": {
            "total": len(tests),
            "passed": sum(test["passed"] for test in tests),
            "failed": sum(not test["passed"] for test in tests),
            "expected_sat": sum(test["expected"] == "sat" for test in tests),
            "expected_unsat": sum(test["expected"] == "unsat" for test in tests),
        },
        "interpretation": (
            "Passing validates expected consequences and countermodels of the frozen candidate encoding; "
            "it does not prove a theological isomorphism."
        ),
    }

    args.receipt_dir.mkdir(parents=True, exist_ok=True)
    receipt = args.receipt_dir / f"Z3_KERNEL_V5_{now.strftime('%Y%m%dT%H%M%SZ')}.json"
    receipt.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    for test in tests:
        status = "PASS" if test["passed"] else "FAIL"
        print(f"{status:4}  {test['id']} {test['name']}: {test['actual']} (expected {test['expected']})")
        if test["model"]:
            print(f"      model={test['model']}")
    print(f"Receipt: {receipt}")
    print(f"Passed: {result['counts']['passed']}/{result['counts']['total']}")
    raise SystemExit(0 if result["counts"]["failed"] == 0 else 1)


if __name__ == "__main__":
    main()

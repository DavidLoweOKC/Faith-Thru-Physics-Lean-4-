"""Reproducible Z3 checks for the canonical Master Equation kernel."""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from z3 import And, Or, Real, RealVal, Solver, sat, unsat


HERE = Path(__file__).resolve().parent


def product(values):
    result = RealVal(1)
    for value in values:
        result *= value
    return result


def bounded(values):
    return [And(value >= 0, value <= 1) for value in values]


def check(name, assumptions, counterexample, expected=unsat, note=""):
    solver = Solver()
    solver.add(*assumptions)
    solver.add(counterexample)
    actual = solver.check()
    return {
        "name": name,
        "expected": str(expected),
        "actual": str(actual),
        "passed": actual == expected,
        "counterexample": str(solver.model()) if actual == sat else None,
        "note": note,
    }


def run_tests():
    tests = []
    xs = [Real(f"x_{i}") for i in range(9)]
    p = product(xs)
    domain = bounded(xs)

    tests.append(check(
        "normalized_product_is_satisfiable", domain,
        p == RealVal("0.5") ** 9, expected=sat,
        note="Witness check for a nonempty normalized domain."
    ))
    tests.append(check(
        "product_stays_in_unit_interval", domain, Or(p < 0, p > 1),
        note="No product outside [0,1] exists when all coordinates are bounded."
    ))

    for index in range(9):
        tests.append(check(
            f"zero_veto_coordinate_{index + 1}",
            domain + [xs[index] == 0], p != 0,
            note="A zero necessary coordinate forces the product to zero."
        ))

    tests.append(check(
        "product_one_forces_all_coordinates_one", domain + [p == 1],
        Or(*[x != 1 for x in xs]),
        note="Perfect product coherence cannot hide a deficient coordinate."
    ))

    ys = [Real(f"y_{i}") for i in range(9)]
    q = product(ys)
    monotone_domain = bounded(xs) + bounded(ys)
    monotone_domain += [ys[i] >= xs[i] for i in range(9)]
    tests.append(check(
        "coordinatewise_increase_cannot_lower_product",
        monotone_domain, q < p,
        note="Coordinatewise increase cannot reduce the identity-wrapper product."
    ))

    alpha, kappa, radius = Real("alpha"), Real("kappa"), Real("radius")
    tests.append(check(
        "bare_cornell_has_no_positive_radius_stationary_point",
        [alpha > 0, kappa > 0, radius > 0],
        alpha + kappa * radius * radius == 0,
        note="V'(r)=0 after clearing the positive denominator r^2."
    ))

    # Encode the full real 2x2 matrix G.  Anticommutation with
    # sigma=diag(1,-1) gives g00=g11=0; the four remaining equations are G^2=G.
    g00, g01, g10, g11 = [Real(name) for name in ("g00", "g01", "g10", "g11")]
    anticommutation = [2 * g00 == 0, -2 * g11 == 0]
    idempotence = [
        g00 * g00 + g01 * g10 == g00,
        g00 * g01 + g01 * g11 == g01,
        g10 * g00 + g11 * g10 == g10,
        g10 * g01 + g11 * g11 == g11,
    ]
    tests.append(check(
        "nonzero_anticommuting_idempotent_is_impossible_2sector",
        anticommutation + idempotence,
        Or(g00 != 0, g01 != 0, g10 != 0, g11 != 0),
        note="The grace channel and sign-changing jump cannot be one operator."
    ))

    # A separate nonzero nilpotent jump J=[[0,a],[b,0]], ab=0, does exist.
    j01, j10 = Real("j01"), Real("j10")
    tests.append(check(
        "nonzero_anticommuting_nilpotent_jump_exists_2sector",
        [j01 * j10 == 0], Or(j01 != 0, j10 != 0), expected=sat,
        note="A model exists for the separate conversion jump."
    ))
    return tests


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, help="Canonical source to hash")
    parser.add_argument("--receipt-dir", type=Path, default=HERE / "receipts")
    args = parser.parse_args()

    tests = run_tests()
    source_hash = None
    if args.source and args.source.is_file():
        source_hash = hashlib.sha256(args.source.read_bytes()).hexdigest().upper()

    now = datetime.now(timezone.utc)
    result = {
        "schema": "theophysics-z3-receipt-v1",
        "generated_utc": now.isoformat(),
        "canonical_source": str(args.source) if args.source else None,
        "canonical_source_sha256": source_hash,
        "tests": tests,
        "counts": {
            "total": len(tests),
            "passed": sum(test["passed"] for test in tests),
            "failed": sum(not test["passed"] for test in tests),
        },
    }

    args.receipt_dir.mkdir(parents=True, exist_ok=True)
    receipt = args.receipt_dir / f"Z3_KERNEL_{now.strftime('%Y%m%dT%H%M%SZ')}.json"
    receipt.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    for test in tests:
        status = "PASS" if test["passed"] else "FAIL"
        print(f"{status:4}  {test['name']}: {test['actual']}")
        if test["counterexample"]:
            print(f"      model={test['counterexample']}")
    print(f"Receipt: {receipt}")
    print(f"Passed: {result['counts']['passed']}/{result['counts']['total']}")
    raise SystemExit(0 if result["counts"]["failed"] == 0 else 1)


if __name__ == "__main__":
    main()

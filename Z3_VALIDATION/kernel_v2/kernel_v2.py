"""Z3 kernel v2: privative magnitude and sanctification obligations.

Each theorem is checked by asking Z3 for a counterexample.  An UNSAT result
means no counterexample exists under the encoded assumptions.  Explicit model
existence/failure-exposure checks instead expect SAT.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from z3 import And, If, Or, Real, Solver, sat, unsat


HERE = Path(__file__).resolve().parent


def zabs(value):
    return If(value >= 0, value, -value)


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


def privative_magnitude_obligations():
    tests = []
    sigma, deprivation, power = Real("p_sigma"), Real("p_d"), Real("p_power")
    enactment = sigma * (1 - deprivation) * power
    domain = [Or(sigma == -1, sigma == 1), power >= 0,
              deprivation >= 0, deprivation <= 1]

    tests.append(check(
        "P01", "privative_magnitude_bounded_by_given_power", domain,
        zabs(enactment) > power, unsat,
        "For E=sigma*(1-d)*P, |E| cannot exceed P on the declared domain.",
    ))
    tests.append(check(
        "P02", "total_deprivation_forces_zero", domain + [deprivation == 1],
        enactment != 0, unsat,
        "At d=1 the remaining enactment is exactly zero.",
    ))

    positive_enactment = (1 - deprivation) * power
    negative_enactment = -(1 - deprivation) * power
    tests.append(check(
        "P03", "opposite_orientations_have_equal_magnitude", domain,
        zabs(positive_enactment) != zabs(negative_enactment), unsat,
        "Changing orientation changes sign, not magnitude, at fixed d and P.",
    ))

    d1, d2 = Real("p_d1"), Real("p_d2")
    e1 = sigma * (1 - d1) * power
    e2 = sigma * (1 - d2) * power
    monotone_domain = [Or(sigma == -1, sigma == 1), power >= 0,
                       d1 >= 0, d1 <= d2, d2 <= 1]
    tests.append(check(
        "P04", "increasing_deprivation_cannot_increase_magnitude",
        monotone_domain, zabs(e2) > zabs(e1), unsat,
        "If d1<=d2, the magnitude at d2 cannot exceed the magnitude at d1.",
    ))

    sign_mismatch = Or(
        And(sigma == 1, enactment <= 0),
        And(sigma == -1, enactment >= 0),
    )
    tests.append(check(
        "P05", "nonzero_privative_enactment_retains_orientation",
        domain + [power > 0, deprivation < 1], sign_mismatch, unsat,
        "With P>0 and d<1, E is strictly positive/negative according to sigma.",
    ))
    return tests


def sanctification_obligations():
    tests = []
    decay, repair = Real("d_decay"), Real("d_repair")
    c = Real("d_c")

    def field(value):
        return -decay * value + repair * (1 - value)

    base = [decay >= 0, repair >= 0]
    tests.append(check(
        "D01", "sanctification_field_points_inward_at_zero", base,
        field(0) < 0, unsat,
        "At c=0, f(c)=repair is nonnegative.",
    ))
    tests.append(check(
        "D02", "sanctification_field_points_inward_at_one", base,
        field(1) > 0, unsat,
        "At c=1, f(c)=-decay is nonpositive.",
    ))

    equilibrium = Real("d_equilibrium")
    positive_rate = base + [decay + repair > 0,
                            (decay + repair) * equilibrium == repair]
    tests.append(check(
        "D03", "sanctification_equilibrium_is_unique", positive_rate + [field(c) == 0],
        c != equilibrium, unsat,
        "Any fixed point equals repair/(decay+repair) when total rate is positive.",
    ))
    tests.append(check(
        "D04", "sanctification_equilibrium_lies_in_unit_interval", positive_rate,
        Or(equilibrium < 0, equilibrium > 1), unsat,
        "The equilibrium lies in [0,1] for nonnegative decay and repair.",
    ))
    tests.append(check(
        "D05", "sanctification_field_points_toward_equilibrium", positive_rate,
        Or(And(c < equilibrium, field(c) <= 0),
           And(c > equilibrium, field(c) >= 0)), unsat,
        "Below equilibrium the field is positive; above it the field is negative.",
    ))

    tests.append(check(
        "D06", "positive_decay_exposes_noncompletion_at_one",
        [decay > 0, repair >= 0], field(1) != 0, sat,
        "Expected countermodel: with positive decay, c=1 is not a fixed point.",
    ))

    fixed_at_one = field(1) == 0
    biconditional_failure = Or(
        And(fixed_at_one, decay != 0),
        And(field(1) != 0, decay == 0),
    )
    tests.append(check(
        "D07", "completion_at_one_iff_decay_is_zero", base,
        biconditional_failure, unsat,
        "For this constant-rate ODE, c=1 is fixed exactly when decay=0.",
    ))
    return tests


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, help="Canonical source document to hash")
    parser.add_argument("--receipt-dir", type=Path, default=HERE / "receipts")
    args = parser.parse_args()

    tests = privative_magnitude_obligations() + sanctification_obligations()
    source_hash = None
    if args.source and args.source.is_file():
        source_hash = hashlib.sha256(args.source.read_bytes()).hexdigest().upper()

    now = datetime.now(timezone.utc)
    result = {
        "schema": "theophysics-z3-receipt-v2",
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
    receipt = args.receipt_dir / f"Z3_KERNEL_V2_{now.strftime('%Y%m%dT%H%M%SZ')}.json"
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

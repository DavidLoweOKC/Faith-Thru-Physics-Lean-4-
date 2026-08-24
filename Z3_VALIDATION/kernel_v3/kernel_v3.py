"""Z3 kernel v3: measurement normalization and completion-wrapper checks."""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from z3 import And, ForAll, Function, If, Implies, Or, Real, RealSort, Solver, sat, unsat


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


def clamp01(value):
    return If(value <= 0, 0, If(value >= 1, 1, value))


def measurement_obligations():
    tests = []
    channel, reference = Real("m_channel"), Real("m_reference")
    ratio = channel / reference
    normalized = clamp01(ratio)
    valid_reference = [reference > 0]

    tests.append(check(
        "M01", "clamped_channel_is_in_unit_interval", valid_reference,
        Or(normalized < 0, normalized > 1), unsat,
        "For a positive reference, clamp(channel/reference,0,1) lies in [0,1].",
    ))
    tests.append(check(
        "M02", "nonpositive_ratio_clamps_to_zero",
        valid_reference + [ratio <= 0], normalized != 0, unsat,
        "A nonpositive normalized channel input maps to the lower endpoint.",
    ))
    tests.append(check(
        "M03", "ratio_at_least_one_clamps_to_one",
        valid_reference + [ratio >= 1], normalized != 1, unsat,
        "A normalized channel input at or above one maps to the upper endpoint.",
    ))
    tests.append(check(
        "M04", "interior_ratio_is_unchanged",
        valid_reference + [ratio >= 0, ratio <= 1], normalized != ratio, unsat,
        "On [0,1], the clamp is the identity, including both endpoints.",
    ))

    product_value, chi = Real("m_product"), Real("m_chi")
    identity_wrapper = [product_value >= 0, product_value <= 1, chi == product_value]
    tests.append(check(
        "M05", "identity_wrapper_equals_raw_product", identity_wrapper,
        chi != product_value, unsat,
        "In the current measurement case C_W(y)=y, wrapped coherence equals the product.",
    ))

    wrapper = Function("m_wrapper", RealSort(), RealSort())
    samples = [0, 1 / 4, 1 / 2, 3 / 4, 1]
    finite_closure = [wrapper(sample) >= 0 for sample in samples]
    finite_closure += [wrapper(sample) <= 1 for sample in samples]
    richer_model = finite_closure + [wrapper(0) == 0, wrapper(1 / 2) == 1 / 4]
    tests.append(check(
        "M06", "richer_wrapper_axioms_are_consistent_on_finite_sample",
        richer_model, wrapper(1) == 3 / 4, sat,
        "A nonidentity wrapper can satisfy zero preservation and sampled range closure.",
    ))

    # Constant zero is a constructive witness that zero preservation and range
    # closure do not force any positive fixed point.  The quantified statements
    # express the full real interval, rather than only sampled values.
    y = Real("m_y")
    zero_wrapper = Function("m_zero_wrapper", RealSort(), RealSort())
    no_positive_fixed_point_model = [
        ForAll([y], zero_wrapper(y) == 0),
        zero_wrapper(0) == 0,
        ForAll([y], Implies(And(y >= 0, y <= 1),
                            And(zero_wrapper(y) >= 0, zero_wrapper(y) <= 1))),
        ForAll([y], Implies(And(y > 0, y <= 1), zero_wrapper(y) != y)),
    ]
    tests.append(check(
        "M07", "positive_fixed_point_is_not_forced_by_wrapper_axioms",
        no_positive_fixed_point_model, zero_wrapper(1) == 0, sat,
        "The constant-zero wrapper satisfies the stated axioms and has no positive fixed point.",
    ))
    return tests


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, help="Canonical source document to hash")
    parser.add_argument("--receipt-dir", type=Path, default=HERE / "receipts")
    args = parser.parse_args()

    tests = measurement_obligations()
    source_hash = None
    if args.source and args.source.is_file():
        source_hash = hashlib.sha256(args.source.read_bytes()).hexdigest().upper()

    now = datetime.now(timezone.utc)
    result = {
        "schema": "theophysics-z3-receipt-v3",
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
    receipt = args.receipt_dir / f"Z3_KERNEL_V3_{now.strftime('%Y%m%dT%H%M%SZ')}.json"
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

"""Z3 kernel v4: salvation operators and finite status-transition logic."""

from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from z3 import And, BoolSort, ForAll, Function, Int, IntSort, Or, Real, Solver, sat, unsat


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


def matrix_square(m00, m01, m10, m11):
    return (
        m00 * m00 + m01 * m10,
        m00 * m01 + m01 * m11,
        m10 * m00 + m11 * m10,
        m10 * m01 + m11 * m11,
    )


def salvation_obligations():
    tests = []

    # sigma_hat = diag(-1,+1).  S01 uses all four entry equations of
    # A*sigma_hat = sigma_hat*A rather than inserting only the simplified
    # off-diagonal consequences.
    a00, a01, a10, a11 = [Real(f"s_a{row}{col}")
                           for row, col in ((0, 0), (0, 1), (1, 0), (1, 1))]
    a_sigma = (-a00, a01, -a10, a11)
    sigma_a = (-a00, -a01, a10, a11)
    commutation = [a_sigma[i] == sigma_a[i] for i in range(4)]
    tests.append(check(
        "S01", "commuting_self_operation_has_no_negative_to_positive_component",
        commutation, a10 != 0, unsat,
        "For e_-=(1,0), the positive component of A e_- is a10; commutation forces it to zero.",
    ))

    # Remove commutation and exhibit the exact flip matrix |+><-|.
    flip_action = [a00 == 0, a10 == 1, a01 == 0, a11 == 0]
    noncommuting = Or(*[a_sigma[i] != sigma_a[i] for i in range(4)])
    tests.append(check(
        "S02", "noncommuting_negative_to_positive_flip_exists",
        flip_action, noncommuting, sat,
        "Without the commutation premise, A=|+><-| maps e_- to e_+ and fails to commute with sigma_hat.",
    ))

    # Unconstrained relation over the declared three status values.
    transition_open = Function("s_transition_open", IntSort(), IntSort(), BoolSort())
    current, following = Int("s_current"), Int("s_following")
    status_domain = [Or(current == -1, current == 0, current == 1),
                     Or(following == -1, following == 0, following == 1)]
    tests.append(check(
        "S03", "three_state_domain_alone_allows_reversion",
        status_domain + [current == 1, following == -1],
        transition_open(current, following), sat,
        "The status set {-1,0,+1} alone does not prohibit a +1 to -1 transition.",
    ))

    # Explicit absorbing graph: -1 may remain or enter 0; 0 may remain or
    # enter +1; +1 may only remain +1.
    transition_absorbing = Function("s_transition_absorbing", IntSort(), IntSort(), BoolSort())
    q, q_next = Int("s_q"), Int("s_q_next")
    graph = ForAll([q, q_next],
        transition_absorbing(q, q_next) == Or(
            And(q == -1, Or(q_next == -1, q_next == 0)),
            And(q == 0, Or(q_next == 0, q_next == 1)),
            And(q == 1, q_next == 1),
        ))
    tests.append(check(
        "S04", "absorbing_positive_status_forbids_reversion",
        [graph], transition_absorbing(1, -1), unsat,
        "The explicit transition graph makes +1 absorbing, so +1 to -1 is impossible.",
    ))

    # Full symbolic 2x2 matrices for distinct operators G and L.
    g00, g01, g10, g11 = [Real(f"s_g{row}{col}")
                           for row, col in ((0, 0), (0, 1), (1, 0), (1, 1))]
    l00, l01, l10, l11 = [Real(f"s_l{row}{col}")
                           for row, col in ((0, 0), (0, 1), (1, 0), (1, 1))]
    g2 = matrix_square(g00, g01, g10, g11)
    l2 = matrix_square(l00, l01, l10, l11)
    g_idempotent = [g2[0] == g00, g2[1] == g01,
                    g2[2] == g10, g2[3] == g11]
    g_absorbs_positive = [g01 == 0, g11 == 1]  # G*(0,1)=(0,1)
    l_nilpotent = [entry == 0 for entry in l2]
    l_flips_negative = [l00 == 0, l10 == 1]  # L*(1,0)=(0,1)
    distinct = Or(g00 != l00, g01 != l01, g10 != l10, g11 != l11)
    tests.append(check(
        "S05", "idempotent_grace_and_nilpotent_conversion_coexist",
        g_idempotent + g_absorbs_positive + l_nilpotent + l_flips_negative,
        distinct, sat,
        "A model exists with separate G^2=G and L^2=0 operators, with G fixing e_+ and L mapping e_- to e_+.",
    ))
    return tests


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, help="Canonical source document to hash")
    parser.add_argument("--receipt-dir", type=Path, default=HERE / "receipts")
    args = parser.parse_args()

    tests = salvation_obligations()
    source_hash = None
    if args.source and args.source.is_file():
        source_hash = hashlib.sha256(args.source.read_bytes()).hexdigest().upper()

    now = datetime.now(timezone.utc)
    result = {
        "schema": "theophysics-z3-receipt-v4",
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
    receipt = args.receipt_dir / f"Z3_KERNEL_V4_{now.strftime('%Y%m%dT%H%M%SZ')}.json"
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

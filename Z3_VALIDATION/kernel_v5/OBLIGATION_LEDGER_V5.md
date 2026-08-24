# Z3 Kernel v5 Obligation Ledger

## Frozen source

The obligations originate in:

`FRUITS_PARENT_LOVE_NOETHER_SOURCE_PRETEST_LEDGER_2026-08-24.md`

Kernel v5 subdivides several ledger rows into explicit negative-control cases,
so 13 pre-registered rows become 17 solver queries.

## Query rails

| ID | Obligation | Expected |
|---|---|---|
| LZ-01 | A classifier using bare physical variables cannot distinguish equal physical states by hidden consent | UNSAT |
| LZ-02 | Voluntary and coercive active coupling cannot overlap | UNSAT |
| LZ-03 | Every active coupling is classified voluntary or coercive | UNSAT |
| LZ-04 | Consent gating forces effective coupling to zero when either consent is absent | UNSAT |
| LZ-05 | Binding alone permits coercive coupling to pass a weakened Love predicate | SAT |
| LZ-06 | Omitting identity preservation permits assimilation to pass | SAT |
| LZ-07 | Omitting mutual flourishing permits exploitation to pass | SAT |
| LZ-08 | Generativity does not follow from the other frozen predicates | SAT |
| LZ-09a | Captivity fails the full candidate predicate | UNSAT |
| LZ-09b | Codependency/identity loss fails the full candidate predicate | UNSAT |
| LZ-09c | Domination/exploitation fails the full candidate predicate | UNSAT |
| LZ-09d | Nongenerative transactional exchange fails the full candidate predicate | UNSAT |
| LZ-10 | Range constraints alone permit a nonidentity Fruit-label swap | SAT |
| LZ-11 | Local curvature can vary while conserved energy remains unchanged | SAT |
| LZ-12a | A concrete admissible effective Cornell stationary point exists | SAT |
| LZ-12b | Two distinct positive stationary radii cannot exist for one admissible parameter set | UNSAT |
| LZ-13 | Curvature cannot be nonpositive at an admissible stationary radius | UNSAT |

## Interpretation boundary

- `SAT` negative controls expose insufficiency or independence; they are expected
  passes, not confirmations of theological meaning.
- `UNSAT` theorem queries establish only consequences of the encoded premises.
- LZ-10 deliberately records that the nine Fruit functions are not yet frozen
  tightly enough to establish label uniqueness.
- Noether's theorem itself is not encoded here. This kernel tests the reduced
  algebraic consequences after the conserved angular-momentum quantity is
  supplied under the stated symmetry hypothesis.

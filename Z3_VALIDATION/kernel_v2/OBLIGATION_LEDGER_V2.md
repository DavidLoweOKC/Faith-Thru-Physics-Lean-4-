# Z3 Kernel v2 Obligation Ledger

Kernel v2 is a separate bounded package. It does not modify or supersede the
16 checks in kernel v1.

For theorem obligations, the query asserts the premises and the negation of
the conclusion, so `UNSAT` is the expected passing result. D06 is an explicit
model-existence/failure-exposure check, so `SAT` is the expected passing result.

## Privative magnitude

Canonical equations: `E = sigma * (1-d) * P`, `sigma in {-1,+1}`,
`P >= 0`, `0 <= d <= 1`.

| ID | Obligation | Expected |
|---|---|---|
| P01 | `abs(E) <= P` | UNSAT |
| P02 | `d = 1 -> E = 0` | UNSAT |
| P03 | opposite orientations at equal `d,P` have equal magnitude | UNSAT |
| P04 | increasing deprivation cannot increase magnitude | UNSAT |
| P05 | for `P > 0, d < 1`, the sign of `E` equals `sigma` | UNSAT |

Sources: `SPIRITUAL_TERMS_MATHEMATICAL_REGISTRY_CANONICAL.md` lines 61-62;
`RESERVE_EQUATIONS_AND_UNUSED_COMPONENTS_CANONICAL.md` lines 130-132.

## Sanctification dynamics

Canonical reduced ODE:

`dc/dt = -decay*c + repair*(1-c)`, where
`repair = beta*O*Gamma_ext >= 0` and `decay >= 0`.

| ID | Obligation | Expected |
|---|---|---|
| D01 | vector field at `c=0` is nonnegative | UNSAT |
| D02 | vector field at `c=1` is nonpositive | UNSAT |
| D03 | equilibrium is uniquely `repair/(decay+repair)` when total rate is positive | UNSAT |
| D04 | that equilibrium lies in `[0,1]` | UNSAT |
| D05 | the vector field points toward the equilibrium | UNSAT |
| D06 | positive decay supplies a model in which `c=1` is not fixed | SAT |
| D07 | `c=1` is fixed iff decay is zero | UNSAT |

Sources: `SPIRITUAL_TERMS_MATHEMATICAL_REGISTRY_CANONICAL.md` lines 70-71;
`RESERVE_EQUATIONS_AND_UNUSED_COMPONENTS_CANONICAL.md` lines 138-140.

## Boundary

These checks prove algebraic facts about the encoded reduced models. They do
not establish the theological identifications. D06-D07 locate a mathematical
repair obligation: constant positive decay makes the equilibrium strictly
below one, so completion at `c=1` requires zero asymptotic decay or a changed
dynamics/source law.

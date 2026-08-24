# Z3 Kernel v4 Obligation Ledger

Kernel v4 checks the repaired salvation operator architecture and the finite
three-status transition model. It is isolated from kernels v1-v3.

The status variable in this kernel is the discrete orientation/completion
state, written here as `q` and restricted to `{-1,0,+1}`. It is not the
continuous sanctification variable `c(t) in [0,1]`, and it is not the
completion wrapper `C_W`. Keeping these three types separate is canonical.

| ID | Obligation | Expected |
|---|---|---|
| S01 | a `2x2` operation commuting with `diag(-1,+1)` has no negative-to-positive component | UNSAT |
| S02 | without commutation, the exact negative-to-positive flip exists | SAT |
| S03 | the domain `{-1,0,+1}` alone permits `+1 -> -1` | SAT |
| S04 | an explicit graph with absorbing `+1` forbids `+1 -> -1` | UNSAT |
| S05 | distinct idempotent grace and nilpotent conversion operators coexist | SAT |

Sources:

- `MASTER_EQUATION_COMPLETE_DERIVATION_CANONICAL.md` lines 395-417.
- `SPIRITUAL_TERMS_MATHEMATICAL_REGISTRY_CANONICAL.md` lines 65-71.
- `RESERVE_EQUATIONS_AND_UNUSED_COMPONENTS_CANONICAL.md` lines 133-140.

## Encoded boundary

S01 uses all four equations of `A*sigma_hat=sigma_hat*A` for a full real
`2x2` matrix. S05 likewise uses all four equations of `G^2=G` and `L^2=0`.
S04 defines the entire finite transition graph, making the no-reversion result
a consequence of a visible premise rather than of the three status labels.

These are algebraic and finite-transition results. They do not identify an
operator or status with a theological event, nor do they derive the absorbing
transition graph from physics.

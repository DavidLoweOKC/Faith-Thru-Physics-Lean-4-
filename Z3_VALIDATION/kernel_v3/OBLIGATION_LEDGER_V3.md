# Z3 Kernel v3 Obligation Ledger

Kernel v3 checks the common measurement register and completion-wrapper
architecture. It is independent of kernels v1 and v2.

For theorem checks, the query asks for a counterexample, so `UNSAT` is the
expected passing result. M06-M07 are model-existence checks and expect `SAT`.

| ID | Obligation | Expected |
|---|---|---|
| M01 | `clamp(Lambda/Lambda_ref,0,1)` lies in `[0,1]` for `Lambda_ref>0` | UNSAT |
| M02 | a nonpositive ratio clamps to zero | UNSAT |
| M03 | a ratio at least one clamps to one | UNSAT |
| M04 | a ratio within `[0,1]` is unchanged | UNSAT |
| M05 | identity wrapping gives `chi=product` | UNSAT |
| M06 | a nonidentity wrapper can satisfy zero preservation and sampled range closure | SAT |
| M07 | zero preservation and range closure do not force a positive fixed point | SAT |

Sources:

- `MASTER_EQUATION_COMPLETE_DERIVATION_CANONICAL.md` lines 160-181 and 187-239.
- `SPIRITUAL_TERMS_MATHEMATICAL_REGISTRY_CANONICAL.md` lines 35-36.
- `RESERVE_EQUATIONS_AND_UNUSED_COMPONENTS_CANONICAL.md` lines 38 and 45.

## Boundary

The channel logarithm is deliberately outside this kernel. Z3 proves the
piecewise normalization algebra after a channel value is supplied; it does not
establish transcendental logarithm identities or empirical channel semantics.
M06 is explicitly a finite rational-sample consistency check. M07 uses a full
interval witness (the constant-zero wrapper) to show that the current wrapper
axioms alone do not imply positive completion or a positive fixed point.

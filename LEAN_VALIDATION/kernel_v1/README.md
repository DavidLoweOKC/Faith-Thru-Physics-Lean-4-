# Lean Kernel V1 validation

`KernelV1.lean` is the exact Lean counterpart of the first 16-test Z3
kernel. One universal zero-veto theorem covers all nine coordinate-specific
Z3 checks.

## Proved surface

- a witness for the nonempty normalized nine-coordinate domain;
- the nine-factor product remains in `[0,1]`;
- any selected zero coordinate forces a zero product;
- product one forces all nine coordinates to one;
- coordinatewise increase cannot lower the product;
- the cleared Cornell stationary polynomial cannot vanish for positive
  parameters;
- a full real two-by-two matrix that anticommutes with the sign operator and
  is idempotent must be zero;
- an explicit nonzero, sign-anticommuting, nilpotent jump exists.

## Direct-check status

The file passed a targeted Lean 4.31.0 check using the already populated
Mathlib dependency cache in:

`D:\GitHub\Lean4-Projects\theophysics-lean`

The target repository's own Mathlib source checkout is present, but its
compiled dependency cache is currently absent. Consequently, the identical
targeted command from the target repository stops at import resolution with
`unknown module prefix 'Mathlib'`. This is an environment/cache blocker, not
a theorem error. No full build or dependency download was run in this task.

See `TARGETED_CHECK_RECEIPT.md` for the file hash, proof-escape scan, and axiom
report.

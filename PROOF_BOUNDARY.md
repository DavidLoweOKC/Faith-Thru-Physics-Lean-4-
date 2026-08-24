# Proof Boundary

## What the verifier establishes

For `PrivativeMagnitude.lean`, Lean checks that the six named theorems follow
from the definitions and explicit premises encoded in the file. The verifier
also rejects `sorry`, `admit`, `unsafe`, and custom `axiom` declarations in
that kernel.

The model assumes:

- supplied power is positive;
- deprivation lies between zero and one;
- orientation has two constructors whose real signs are `+1` and `-1`;
- enacted effect is orientation times remaining supplied capacity.

Within that model, Lean proves bounded magnitude, annihilation at total
deprivation, equal magnitude under sign reversal, monotonic loss under greater
deprivation, and the borrowed-magnitude identity for opposition.

## What the verifier does not establish

The build does not prove that:

- supplied power is metaphysically identical to created good;
- negative orientation is metaphysically identical to evil or the Devil;
- the physical universe instantiates this model;
- Christianity, the Trinity, grace, the Cross, or Resurrection is true;
- the prose manuscript follows from this kernel without additional premises.

Those are theological identifications, bridge claims, empirical questions, or
open formalization obligations. They must be evaluated separately.

## Foundational dependencies

`#print axioms` currently reports Lean/Mathlib's standard logical foundations:

- `propext`
- `Classical.choice`
- `Quot.sound`

There are no framework-specific Lean axioms in `PrivativeMagnitude.lean`.

# Lean validation obligation ledger

This ledger transfers the completed bounded Z3 work into deductive proof
obligations. Z3 consistency results are not silently promoted to Lean
theorems. Each Lean kernel must state its domains and hypotheses explicitly.

## Gate decision

The bounded Z3 lane is complete for its intended role: algebraic consistency,
finite transition graphs, countermodel searches, and negative controls.

The following are not deferred Z3 failures. They require Lean's libraries for
analysis, algebra, linear maps, or variational calculus:

- logarithmic channel definitions and calibration;
- continuous differential dynamics and invariant regions;
- Hamiltonian/effective-potential analysis;
- Lagrangian construction and Euler-Lagrange recovery;
- symmetry and Noether-style conservation implications;
- explicit structural maps for any proposed isomorphism;
- uniqueness or non-uniqueness of Fruit labels.

## Kernel queue

| Lean kernel | Imported Z3 surface | Status |
|---|---|---|
| V1 | nine-coordinate product, bare Cornell obstruction, operator separation | proved and targeted-check passed |
| V2 | privative magnitude and reduced sanctification ODE | queued |
| V3 | channel normalization and completion wrapper | queued |
| V4 | sign preservation and three-state transition architecture | queued |
| V5 | parent-Love predicates, effective Cornell equilibrium, Fruit controls | queued |
| V6 | continuous channel, source term, and invariant-region analysis | open analytic obligation |
| V7 | Lagrangian, Euler-Lagrange, and conservation dependencies | open analytic obligation |
| V8 | candidate isomorphism maps, preservation, reflection, and rival maps | open structural obligation |

## Proof-boundary rule

For every theorem, the package will record:

1. mathematical definitions;
2. physical hypotheses;
3. theological or semantic bridge premises;
4. proved consequences;
5. remaining open identifications.

Passing Lean proves only the consequence from the displayed premises. It does
not by itself identify a mathematical object with a spiritual reality.

# Quantitative Structure Experiment

Lean module: `QuantitativeStructure.lean`

This experiment formalizes the claim:

> Representation does not create quantitative structure.

The main theorem is:

```lean
theorem no_bijection_three_two : Bijection Three Two -> False
```

In this dependency-free version, `Bijection Three Two` is a `Type`, not a `Prop`,
so the theorem is stated as "assuming such a bijection yields contradiction."

The theorem does not use natural numbers, a cardinality function, arithmetic,
measurement units, or decimal notation. It defines a one-to-one correspondence
explicitly as `Bijection`, then proves that assuming a reversible correspondence
between an abstract three-distinction structure and an abstract two-distinction
structure leads to contradiction.

## Boundary

This does not prove Platonism, God, the Big Bang, or that abstract numbers
temporally existed before the universe. It proves the narrower formal claim that
changing symbols or labels cannot manufacture a bijection where the underlying
structures lack one.

The philosophical conclusion supported by the formal result is:

> Numerical notation is invented, but quantitative distinction is discovered.

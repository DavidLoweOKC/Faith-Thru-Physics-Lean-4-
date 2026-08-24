# Integrated Master Derivation local receipt

- Date: 2026-08-24
- Toolchain: `leanprover/lean4:v4.31.0`
- Root: `MasterDerivation.lean`
- Root SHA-256: `E59B0CD65898B0B3EADCCB97CC1EBF41EF1685D9F81E55CEB33C102911276F07`
- Full command: `lake build MasterDerivation`
- Full result: **PASS**, 1,228 build jobs
- Direct command: `lake env lean MasterDerivation.lean`
- Direct result: **PASS**
- Integrated certificate axiom report: `propext`, `Classical.choice`, `Quot.sound`
- Active `sorry`: none in integrated root
- Active `admit`: none in integrated root
- Active `unsafe`: none in integrated root
- Custom `axiom`: none in integrated root
- Vacuous `: True :=` certificate fields: none

## Integration discovery

The imported legacy compatibility module `Theophysics_Core.lean` contains 89
descriptively named theorems whose proposition is only `True` and whose proof is
`by trivial`. They compile but do not establish the meaning suggested by their
names. They are excluded from `CurrentCertificate` and recorded in
`INTEGRATION_DEBT.md` for typed migration.

The adversarial module intentionally contains `#check_failure` commands. Lean
prints hypothetical `sorry` text while reporting the expected failed terms;
those diagnostics are not source-level `sorry` declarations and the module
build succeeds as designed.

This receipt is local. The result is promoted to publicly reproducible only
after the strengthened GitHub Actions run succeeds on the committed files.

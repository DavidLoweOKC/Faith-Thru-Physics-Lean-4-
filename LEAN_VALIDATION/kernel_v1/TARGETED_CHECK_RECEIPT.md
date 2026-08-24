# Kernel V1 targeted-check receipt

- Date: 2026-08-24
- File: `KernelV1.lean`
- SHA-256: `F527D45143CD1D69B5EB6C1ECAB1D4637A78B48883A5C1C394B8300D82228140`
- Lean toolchain: `leanprover/lean4:v4.31.0`
- Proof-escape scan: **PASS**
- Active `sorry`: none
- Active `admit`: none
- Active `unsafe`: none
- Custom `axiom`: none

## Successful targeted check

Working dependency environment:

`D:\GitHub\Lean4-Projects\theophysics-lean`

Command:

```text
lake env lean C:\Theophysics-Validation\github\Faith-Thru-Physics-Lean-4-\KernelV1.lean
```

Result: exit code `0`.

Every printed public theorem depends only on the standard foundations reported
by Lean/Mathlib:

- `propext`
- `Classical.choice`
- `Quot.sound`

No theorem reports `sorryAx`.

Two unused-simp-argument linter warnings were emitted. They do not affect proof
checking.

## Target repository environment check

The same direct command from
`C:\Theophysics-Validation\github\Faith-Thru-Physics-Lean-4-` currently stops
before elaborating the file because the repository has no compiled Mathlib
cache:

```text
KernelV1.lean:1:0: error: unknown module prefix 'Mathlib'
```

The source dependency checkout exists under `.lake\packages\mathlib`; the
corresponding `.olean` dependency files do not. No broad build or cache fetch
was authorized or performed during this targeted implementation task.

# Faith-Thru-Physics-Lean-4-

[![Lean CI](https://github.com/DavidLoweOKC/Faith-Thru-Physics-Lean-4-/actions/workflows/lean.yml/badge.svg)](https://github.com/DavidLoweOKC/Faith-Thru-Physics-Lean-4-/actions/workflows/lean.yml)

This repo is now the staged Lean 4 home for the current Faith Thru Physics proof set.

## Verify it yourself

### No local installation

Every push is checked on a clean public GitHub machine. Open the **Actions**
tab, select the newest **Lean CI** run, and inspect or download its public
verification receipt. The workflow builds the complete project, directly
checks `PrivativeMagnitude.lean` and `KernelV1.lean`, rejects proof escapes in
both kernels, and records their hashes and axiom reports.

GitHub permits only repository collaborators to press **Run workflow** in this
repository. An outside reader can use **Fork**, enable Actions in the fork, and
run the identical workflow on an independent GitHub machine without installing
Lean locally.

### Public download

Anyone can open the repository without signing in and choose **Code -> Download
ZIP**, or clone it with:

```text
git clone https://github.com/DavidLoweOKC/Faith-Thru-Physics-Lean-4-.git
```

### Windows: double-click verifier

Download or clone the repository, then double-click:

```text
VERIFY.bat
```

If Lean is missing, the script transparently downloads the official `elan`
installer, installs the pinned toolchain from `lean-toolchain`, downloads the
Mathlib cache, builds the project, audits the kernel, and writes
`verification-receipt.txt`.

The initial Mathlib download requires an internet connection and several
gigabytes of free disk space.

## Current verified kernels

`PrivativeMagnitude.lean` formalizes the real-number model
`E = sigma * (1 - d) * P`. Its six theorems concern magnitude, deprivation,
orientation, and borrowed capacity. See [PROOF_BOUNDARY.md](PROOF_BOUNDARY.md)
for the exact premises and non-results.

`KernelV1.lean` formalizes the first master-equation derivation surface: the
nine-coordinate product architecture, zero-veto and rigidity, the bare Cornell
stationary-point obstruction, and separation of idempotent and nilpotent
operator roles. See
[`LEAN_VALIDATION/OBLIGATION_LEDGER.md`](LEAN_VALIDATION/OBLIGATION_LEDGER.md)
for the full validation queue and proof boundaries.

**A passing build proves consequences of the encoded model. It does not by
itself prove the theological or physical interpretation.**

## Current staged structure

- `BUILD_CONFIG/`
  - `lakefile.lean`
- `COHERENCE_SPINE/`
  - `Theophysics_Coherence.lean`
- `ADVERSARIAL/`
  - `Theophysics_Adversarial.lean`
- `CHI_EVALUATOR/`
  - `Theophysics_ChiEvaluator.lean`
- `MASTER_EQUATION/`
  - `Final_Lean4_From_Excel.lean`
  - `Theophysics_Core.lean`
- `FALL_MECHANICS/`
  - `Theophysics_Fall.lean`
- `FRACTURE_HYPOTHESIS/`
  - `Theophysics_Fracture.lean`
- `GRACE_PROPERTIES/`
  - `COPY_PASTE_LEAN4.lean`
- `EVIDENCE/`
  - aggregated copies of the current Lean evidence files
- `docs/`
  - corpus/addendum/dashboard markdown
  - classifier JSON
  - workbook export

## Source used for this transfer

Primary source copied from:

- `H:\Desktop 2\LEAN 4`

## Notes

- This is a clean first-stage transfer meant to get the active Lean material into GitHub before the next run.
- I intentionally did **not** stage the obvious noise piles as part of the main path yet:
  - `ACADEMIC_EXERCISE/`
  - `MATHLIB_DEPENDENCY/`
  - `MATHLIB_IMPORT/`
  - `NEEDS_REVIEW/`
  - `Lean 4/`
- The large corpus markdown in `docs/01_Complete-Lean4-Corpus.md` appears to contain mixed material and should be treated as reference unless we explicitly canonicalize it.

## Build status

The repo has now been promoted into a real Lean package shape:

- root-level `lakefile.lean`
- root-level `lean-toolchain`
- root-level canonical `.lean` modules copied from `EVIDENCE/`

Current reproducibility command:

```bash
lake build
```

Current result:

- Build completed successfully
- `#check_failure` lines in `Theophysics_Adversarial.lean` emit expected `info:` output
- remaining messages are linter warnings, not proof failures

## Immediate next cleanup

- decide whether `EVIDENCE/` remains as archive or is reduced once the root canonical files are confirmed
- compare the current seven-file packet against `D:\GitHub\theophysics-lean`
- decide whether to re-add later modules such as:
  - `Theophysics_LawMechanisms`
  - `Theophysics_Universality`
  - `Theophysics_MaxwellTrinity`
  - `Theophysics_DelayedChoice`
  - `Theophysics_GodTest`

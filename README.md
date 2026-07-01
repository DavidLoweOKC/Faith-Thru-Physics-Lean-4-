# Faith-Thru-Physics-Lean-4-

This repo is now the staged Lean 4 home for the current Faith Thru Physics proof set.

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

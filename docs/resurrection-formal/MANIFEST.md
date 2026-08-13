# Packet Manifest

## Canonical Write-Ups

- `FORMAL_VERIFICATION_WRITEUP_2026-05-10.md`
- `FormalVerificationTestLog.md`
- `PaperClaims.md`
- `FormalizationPlan.md`
- `README.md`

## Lean Project Files

- `lakefile.lean`
- `lean-toolchain`
- `lake-manifest.json`
- `ResurrectionFormal.lean`
- `IsomorphismTest.lean`
- `ResurrectionFormal/Core.lean`
- `ResurrectionFormal/StageMachine.lean`
- `ResurrectionFormal/Mapping.lean`
- `ResurrectionFormal/IsomorphismTest.lean`
- `ResurrectionFormal/BridgeMatrix.lean`

## Source Context

- `00_READ_ME_FIRST.md`
- `01_FORMAL_LAYER_Definition10.md`
- `02_PHYSICAL_THEOLOGICAL_LAYER_TenFactorTable.md`
- `00_FORMAL_THEORY_COMPLETE.md`

## Verification Commands

Run from the repository root:

```text
lake build
lake env lean IsomorphismTest.lean
```

Optional proof-escape scan:

```text
rg -n "\bsorry\b|\badmit\b|\baxiom\b|\bunsafe\b" ResurrectionFormal ResurrectionFormal.lean IsomorphismTest.lean
```

## Current Verdict

The current project verifies internal coherence of the encoded formal skeleton,
the enriched Law 4 abstraction, and the ten-factor bridge matrix. It does not
yet verify full domain-faithfulness of the physical/theological interpretations.


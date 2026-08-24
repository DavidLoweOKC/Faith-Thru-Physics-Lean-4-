# Integrated derivation debt ledger

## Current ruling

`MasterDerivation.lean` imports the entire current root module set so namespace,
type, and dependency conflicts are tested together. Its `CurrentCertificate`
contains only propositions with typed mathematical content.

The legacy compatibility module `Theophysics_Core.lean` currently contains 89
theorems whose complete proposition is `True` and whose proof is `by trivial`.
They compile, but their descriptive theorem names are not established by the
proposition `True`. They are therefore:

- imported for compatibility;
- excluded from the integrated certificate;
- not counted as formal verification;
- queued for replacement by typed definitions and non-vacuous propositions.

## Main debt groups

- incarnation, resurrection, memory, and heaven markers;
- salvation/conversion markers;
- claimed Law 4 and Trinity isomorphism markers;
- Noether and bound-state markers;
- several law-limit and collapse markers;
- several cross/justice/mercy markers;
- hit-rate and narrative-order markers.

This discovery is an integration result, not a reason to erase the files. Each
marker must be migrated individually and may be promoted only after its new
statement exposes the actual types, hypotheses, and claimed consequence.

## Promotion gate

A migrated theorem enters `CurrentCertificate` only when it has:

1. a non-vacuous proposition;
2. visible mathematical and bridge assumptions;
3. no `sorry`, `admit`, `unsafe`, custom `axiom`, or `sorryAx`;
4. a direct Lean check;
5. a clean-machine GitHub receipt;
6. a source and status entry in the Obsidian derivation ledger.

# Twelve-Chapter Lean Targets

Date: 2026-08-13

Lean module: `ChapterTargets.lean`

## Boundary

This file verifies formal/logical shapes only. It does not prove the theological,
physical, or moral interpretation of any chapter. Domain identifications remain
separate model assumptions until separately justified.

## Compiled Targets

| Chapter | Lean Status | Current Target |
|---|---|---|
| 1 | Compilable theorem | Information witness from distinction + relation |
| 2 | Compilable theorem | Terminal ground follows from explicit termination assumption |
| 3 | Boundary/status only | Theological confession and physics conjecture are not Lean theorems |
| 4 | Compilable theorem | Abstract self-correction impossibility shape |
| 5 | Compilable theorem | Product veto, swap invariance, path-order negative control |
| 6 | Compilable theorem | Boundary exclusion once state boundary is defined |
| 7 | Compilable theorem | Conservation follows from a stated symmetry-to-conservation law |
| 8 | Compilable theorem | Logical form of grounding argument |
| 9 | Compilable theorem | Irreversibility from explicitly stated parity violation law |
| 10 | Compilable theorem | No indefinite restoration without external source |
| 11 | Compilable theorem | Domain instance satisfies declared coherence grammar |
| 12 | Compilable theorem | L3 requires A4; removing A4 blocks L3 |

## Verified Commands

```powershell
lake build ChapterTargets
lake build
lake env lean C:\Users\David\Documents\Codex\2026-08-13\ca\work\ChapterTargetsAxiomCheck.lean
```

## Axiom Footprint

```text
ChapterTargets.Ch1.information_from_distinction_relation: no axioms
ChapterTargets.Ch2.terminal_ground_exists: no axioms
ChapterTargets.Ch4.self_correction_impossible: no axioms
ChapterTargets.Ch5.chi_zero_if_a_zero: [propext]
ChapterTargets.Ch5.chi_swap_ab_invariant: [propext]
ChapterTargets.Ch5.path_order_negative_control: no axioms
ChapterTargets.Ch7.conservation_from_symmetry: no axioms
ChapterTargets.Ch8.ground_required_from_spine: no axioms
ChapterTargets.Ch9.irreversibility_from_parity_violation: no axioms
ChapterTargets.Ch10.no_indefinite_restoration_without_external_source: no axioms
ChapterTargets.Ch11.domain_instance_satisfies_grammar: no axioms
ChapterTargets.Ch12.L3_requires_A4: no axioms
ChapterTargets.Ch12.removing_A4_blocks_L3: no axioms
ChapterTargets.Ch12.L4_requires_L1: no axioms
```

## Promotion Rule

These are Candidate formal targets. Before any chapter claim becomes Admitted,
replace abstract law fields with stronger definitions and add negative controls.

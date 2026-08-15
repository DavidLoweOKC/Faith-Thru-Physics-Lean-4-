# Root-Trinity Isomorphism Experiment

Lean module: `RootTrinityIso.lean`

This experiment formalizes a narrow structural claim:

> The root triad of Being, Distinction, and Relation is isomorphic to the formal
> Trinitarian-role triad of Father, Logos, and Spirit under explicit finite
> role and operation definitions.

## What Lean Checks

- `RootRole`: `rootBeing`, `rootDistinction`, `rootRelation`
- `ProcessRole`: `processGeneration`, `processStructure`, `processActualization`
- `TrinityRole`: `trinityFather`, `trinityLogos`, `trinitySpirit`
- `rootCompose rootBeing rootDistinction = rootRelation`
- `processCompose processGeneration processStructure = processActualization`
- `trinityAct trinityFather trinityLogos = trinitySpirit`
- structure-preserving bijections from root to process, process to Trinity, and root to Trinity
- transitive preservation of the operation
- uniqueness of the role-constrained root-to-Trinity map

## Main Theorems

```lean
theorem roots_iso_trinity : Nonempty RootTrinityIso

theorem root_process_trans_trinity_preserves :
    forall x y,
      (Bijection.trans rootProcessIso.map processTrinityIso.map).toFun
          (rootCompose x y) =
        trinityAct
          ((Bijection.trans rootProcessIso.map processTrinityIso.map).toFun x)
          ((Bijection.trans rootProcessIso.map processTrinityIso.map).toFun y)

theorem unique_role_constrained_root_trinity_map
    (f g : RootTrinityIso) :
    f.map.toFun = g.map.toFun
```

## Boundary

This does not prove the Christian Trinity exists, and it does not prove identity
of metaphysical referents. It proves that under the stated formal role and
operation constraints, the structure-preserving correspondence exists and its
role-constrained map is unique.

## Verification Receipt

Date: 2026-08-13

Commands:

```powershell
lake build RootTrinityIso
lake build
lake env lean C:\Users\David\Documents\Codex\2026-08-13\ca\work\RootTrinityAxiomCheck.lean
```

Results:

- `lake build RootTrinityIso` passed.
- `lake build` passed for the full package.
- Full build emitted existing warning/info output from other modules, especially expected adversarial negative checks, but no build failure.

Axiom footprint:

```text
RootTrinityIso.roots_iso_trinity: [propext]
RootTrinityIso.root_process_trans_trinity_preserves: [propext]
RootTrinityIso.unique_role_constrained_root_trinity_map: [propext, Quot.sound]
RootTrinityIso.root_trinity_operation_preservation_forced: [propext]
```

Interpretation:

This is a formal model receipt, not a theological proof receipt. It verifies
that the declared finite role mapping and operation-preservation constraints
compile in Lean 4.31.0 and do not rely on additional project-specific axioms.

import Std
import Theophysics_Fracture

/-!
# Theophysics_Fall

Std-only structural primitives for the Fall paper.

This file intentionally formalizes the conservative claim:

* a fall event is not mere separation;
* coupling without entanglement is not enough;
* entropy/decay alone is not moral fracture;
* a grace floor is not closed-system self-repair;
* the staged fall pattern requires separation, activated coupling,
  entanglement, coherence loss, and an arrow of time.

Empirical lifespan-curve isomorphism is not asserted here. That belongs after
model comparison confirms the exponential-floor model against alternatives.
-/

namespace Theophysics.Fall

open Theophysics.Fracture

inductive FallStage where
  | globalTimeless
  | subsystemSeparated
  | couplingActivated
  | entanglementSpread
  | coherenceLost
  | arrowOfTime
  | graceFloor
deriving DecidableEq, Repr

structure FallModel where
  globalTimelessState : Bool
  subsystemSeparated : Bool
  couplingActivated : Bool
  entanglementSpread : Bool
  coherenceLost : Bool
  timeArrowPresent : Bool
  externalGraceFloor : Bool
deriving DecidableEq, Repr

def fallActivated (m : FallModel) : Bool :=
  m.subsystemSeparated &&
  m.couplingActivated &&
  m.entanglementSpread &&
  m.coherenceLost &&
  m.timeArrowPresent

def sustainedAfterFall (m : FallModel) : Bool :=
  fallActivated m && m.externalGraceFloor

def preFallCoherence : FallModel where
  globalTimelessState := true
  subsystemSeparated := false
  couplingActivated := false
  entanglementSpread := false
  coherenceLost := false
  timeArrowPresent := false
  externalGraceFloor := false

def separatedOnly : FallModel where
  globalTimelessState := true
  subsystemSeparated := true
  couplingActivated := false
  entanglementSpread := false
  coherenceLost := false
  timeArrowPresent := false
  externalGraceFloor := false

def coupledOnly : FallModel where
  globalTimelessState := true
  subsystemSeparated := true
  couplingActivated := true
  entanglementSpread := false
  coherenceLost := false
  timeArrowPresent := false
  externalGraceFloor := false

def fullFallWithoutGraceFloor : FallModel where
  globalTimelessState := true
  subsystemSeparated := true
  couplingActivated := true
  entanglementSpread := true
  coherenceLost := true
  timeArrowPresent := true
  externalGraceFloor := false

def fullFallWithGraceFloor : FallModel where
  globalTimelessState := true
  subsystemSeparated := true
  couplingActivated := true
  entanglementSpread := true
  coherenceLost := true
  timeArrowPresent := true
  externalGraceFloor := true

def fallAsFracture (m : FallModel) : FractureModel where
  globalCoherence := m.globalTimelessState
  localIndeterminacy := m.entanglementSpread
  contradictionPresent := m.coherenceLost
  scar := if m.timeArrowPresent then grQmStyleScar else randomGap
  restorationInput := m.externalGraceFloor

theorem pre_fall_is_not_fall :
    fallActivated preFallCoherence = false := by
  rfl

theorem separation_alone_is_not_fall :
    fallActivated separatedOnly = false := by
  rfl

theorem coupling_without_entanglement_is_not_fall :
    fallActivated coupledOnly = false := by
  rfl

theorem full_fall_without_grace_is_activated :
    fallActivated fullFallWithoutGraceFloor = true := by
  rfl

theorem full_fall_with_grace_is_sustained :
    sustainedAfterFall fullFallWithGraceFloor = true := by
  rfl

theorem full_fall_without_grace_floor_not_sustained :
    sustainedAfterFall fullFallWithoutGraceFloor = false := by
  rfl

theorem grace_floor_requires_fall_activation
    (m : FallModel) (h : sustainedAfterFall m = true) :
    fallActivated m = true := by
  cases hf : fallActivated m <;> cases hg : m.externalGraceFloor <;>
    simp [sustainedAfterFall, hf, hg] at h ⊢

theorem sustained_after_fall_requires_grace_floor
    (m : FallModel) (h : sustainedAfterFall m = true) :
    m.externalGraceFloor = true := by
  cases hf : fallActivated m <;> cases hg : m.externalGraceFloor <;>
    simp [sustainedAfterFall, hf, hg] at h ⊢

theorem fall_with_grace_maps_to_repairable_fracture :
    repairable (fallAsFracture fullFallWithGraceFloor) = true := by
  rfl

theorem fall_without_grace_maps_to_unrepairable_fracture :
    repairable (fallAsFracture fullFallWithoutGraceFloor) = false := by
  rfl

theorem fall_spine_marker :
    fallActivated preFallCoherence = false ∧
    fallActivated separatedOnly = false ∧
    fallActivated coupledOnly = false ∧
    fallActivated fullFallWithoutGraceFloor = true ∧
    sustainedAfterFall fullFallWithoutGraceFloor = false ∧
    sustainedAfterFall fullFallWithGraceFloor = true ∧
    repairable (fallAsFracture fullFallWithGraceFloor) = true := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Theophysics.Fall

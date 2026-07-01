import Std
import Theophysics_Coherence

/-!
# Theophysics_Fracture

Std-only structural primitives for the Fracture Hypothesis.

This file formalizes the "science of the gaps" discipline:

* a random explanatory gap is not a structured scar;
* local indeterminacy alone is not fracture;
* global coherence alone is not fracture;
* fracture requires a structured coexistence of global coherence, local
  indeterminacy, and contradiction;
* repair is fracture plus restoration input.
-/

namespace Theophysics.Fracture

open Theophysics.Coherence

inductive EvolutionMode where
  | closedReversible
  | openDecohering
deriving DecidableEq, Repr

structure ScarSignature where
  atCouplingBoundary : Bool
  regimeMismatch : Bool
  localSuccessGlobalFailure : Bool
  irreversibleAsymmetry : Bool
  structuredNotRandom : Bool
deriving DecidableEq, Repr

def structuredScar (s : ScarSignature) : Bool :=
  s.atCouplingBoundary &&
  s.regimeMismatch &&
  s.localSuccessGlobalFailure &&
  s.irreversibleAsymmetry &&
  s.structuredNotRandom

def randomGap : ScarSignature where
  atCouplingBoundary := false
  regimeMismatch := false
  localSuccessGlobalFailure := false
  irreversibleAsymmetry := false
  structuredNotRandom := false

def grQmStyleScar : ScarSignature where
  atCouplingBoundary := true
  regimeMismatch := true
  localSuccessGlobalFailure := true
  irreversibleAsymmetry := true
  structuredNotRandom := true

structure FractureModel where
  globalCoherence : Bool
  localIndeterminacy : Bool
  contradictionPresent : Bool
  scar : ScarSignature
  restorationInput : Bool
deriving DecidableEq, Repr

def fractured (m : FractureModel) : Bool :=
  m.globalCoherence &&
  m.localIndeterminacy &&
  m.contradictionPresent &&
  structuredScar m.scar

def repairable (m : FractureModel) : Bool :=
  fractured m && m.restorationInput

def unfracturedCoherence : FractureModel where
  globalCoherence := true
  localIndeterminacy := false
  contradictionPresent := false
  scar := randomGap
  restorationInput := false

def indeterminateOnly : FractureModel where
  globalCoherence := false
  localIndeterminacy := true
  contradictionPresent := false
  scar := randomGap
  restorationInput := false

def structuredFracture : FractureModel where
  globalCoherence := true
  localIndeterminacy := true
  contradictionPresent := true
  scar := grQmStyleScar
  restorationInput := false

def repairableFracture : FractureModel where
  globalCoherence := true
  localIndeterminacy := true
  contradictionPresent := true
  scar := grQmStyleScar
  restorationInput := true

theorem random_gap_is_not_structured_scar :
    structuredScar randomGap = false := by
  rfl

theorem gr_qm_style_scar_is_structured :
    structuredScar grQmStyleScar = true := by
  rfl

theorem global_coherence_alone_is_not_fracture :
    fractured unfracturedCoherence = false := by
  rfl

theorem local_indeterminacy_alone_is_not_fracture :
    fractured indeterminateOnly = false := by
  rfl

theorem structured_fracture_is_fractured :
    fractured structuredFracture = true := by
  rfl

theorem fracture_without_restoration_is_not_repairable :
    repairable structuredFracture = false := by
  rfl

theorem fracture_with_restoration_is_repairable :
    repairable repairableFracture = true := by
  rfl

theorem repair_requires_fracture
    (m : FractureModel) (h : repairable m = true) :
    fractured m = true := by
  cases hf : fractured m <;> cases hi : m.restorationInput <;>
    simp [repairable, hf, hi] at h ⊢

theorem repair_requires_restoration_input
    (m : FractureModel) (h : repairable m = true) :
    m.restorationInput = true := by
  cases hf : fractured m <;> cases hi : m.restorationInput <;>
    simp [repairable, hf, hi] at h ⊢

theorem science_of_gaps_marker :
    structuredScar randomGap = false ∧
    structuredScar grQmStyleScar = true ∧
    fractured indeterminateOnly = false ∧
    fractured structuredFracture = true ∧
    repairable structuredFracture = false ∧
    repairable repairableFracture = true := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

end Theophysics.Fracture

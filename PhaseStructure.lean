import Mathlib.Data.Real.Basic

/-!
# Phase Structure: local oscillation and its limits

This file contains only a small mathematical kernel. It deliberately does
not identify its predicates with theological or psychological terms.

The positive result is local: for positive reduced mass, a real *nonzero*
normal-mode frequency forces positive curvature in the supplied quadratic
model. The negative control records that such local data alone do not imply
a chosen bound-state/escape-threshold condition.
-/

namespace Theophysics.PhaseStructure

/-- Local data for a quadratic small-oscillation model. -/
structure OscillationData where
  potentialValue : ℝ
  firstDerivative : ℝ
  curvature : ℝ
  reducedMass : ℝ
  omega : ℝ
  stationary : firstDerivative = 0
  reducedMassPositive : 0 < reducedMass
  dispersion : omega ^ 2 = curvature / reducedMass

/-- A nonzero normal mode, intentionally stated without semantic labels. -/
def NonzeroNormalMode (s : OscillationData) : Prop :=
  s.omega ≠ 0

/-- Compatibility name retained for the theorem published in the first kernel. -/
abbrev RealNonzeroOscillation := NonzeroNormalMode

/-- Stationarity plus positive curvature: stability only in the local quadratic model. -/
def LocalQuadraticStability (s : OscillationData) : Prop :=
  s.firstDerivative = 0 ∧ 0 < s.curvature

/-- A local energy condition standing in for a separately supplied escape threshold. -/
def BelowEscapeThreshold (s : OscillationData) (escapeThreshold : ℝ) : Prop :=
  s.potentialValue < escapeThreshold

/-- Two states have the same local quadratic dynamics, regardless of energy offset. -/
def SameLocalDynamics (s₁ s₂ : OscillationData) : Prop :=
  s₁.firstDerivative = s₂.firstDerivative ∧
    s₁.curvature = s₂.curvature ∧
    s₁.reducedMass = s₂.reducedMass ∧
    s₁.omega = s₂.omega

/--
In the quadratic model, positive reduced mass and a real nonzero frequency
force positive curvature. This is the formal content behind the proposed
`real oscillation → stable curvature` step.
-/
theorem positive_curvature_of_real_nonzero_oscillation
    (s : OscillationData) (hMode : RealNonzeroOscillation s) :
    0 < s.curvature := by
  have hOmegaSq : 0 < s.omega ^ 2 := sq_pos_of_ne_zero hMode
  have hRatio : 0 < s.curvature / s.reducedMass := by
    rw [← s.dispersion]
    exact hOmegaSq
  rcases div_pos_iff.mp hRatio with hPositive | hNegative
  · exact hPositive.1
  · exact False.elim ((not_lt_of_ge (le_of_lt s.reducedMassPositive)) hNegative.2)

/-- Preferred-name form of the positive-curvature theorem. -/
theorem positive_curvature_of_nonzero_normal_mode
    (s : OscillationData) (hMode : NonzeroNormalMode s) :
    0 < s.curvature :=
  positive_curvature_of_real_nonzero_oscillation s hMode

/-- At an assumed stationary point, a nonzero mode earns positive curvature and local quadratic stability. -/
theorem local_quadratic_stability_of_nonzero_normal_mode
    (s : OscillationData) (hMode : NonzeroNormalMode s) :
    LocalQuadraticStability s := by
  exact ⟨s.stationary, positive_curvature_of_nonzero_normal_mode s hMode⟩

/-- Nonpositive curvature rules out a real nonzero mode when mass is positive. -/
theorem no_real_nonzero_oscillation_of_nonpositive_curvature
    (s : OscillationData) (hCurvature : s.curvature ≤ 0) :
    ¬ RealNonzeroOscillation s := by
  intro hMode
  have hPositive := positive_curvature_of_real_nonzero_oscillation s hMode
  exact (not_lt_of_ge hCurvature) hPositive

/-- Within this supplied dispersion model, positive curvature is equivalent to a nonzero mode. -/
theorem real_nonzero_oscillation_iff_positive_curvature (s : OscillationData) :
    RealNonzeroOscillation s ↔ 0 < s.curvature := by
  constructor
  · exact positive_curvature_of_real_nonzero_oscillation s
  · intro hCurvature hOmegaZero
    have hRatio : 0 < s.curvature / s.reducedMass :=
      div_pos hCurvature s.reducedMassPositive
    rw [← s.dispersion, hOmegaZero] at hRatio
    simp at hRatio

/-- Zero frequency is exactly the boundary case of zero curvature. -/
theorem zero_frequency_iff_zero_curvature (s : OscillationData) :
    s.omega = 0 ↔ s.curvature = 0 := by
  have hMassNe : s.reducedMass ≠ 0 := ne_of_gt s.reducedMassPositive
  constructor
  · intro hOmega
    have hDivision : s.curvature / s.reducedMass = 0 := by
      rw [← s.dispersion, hOmega]
      simp
    exact (div_eq_zero_iff).mp hDivision |>.resolve_right hMassNe
  · intro hCurvature
    have hSquare : s.omega ^ 2 = 0 := by
      rw [s.dispersion, hCurvature]
      simp
    exact (sq_eq_zero_iff).mp hSquare

/-!
Negative control: local oscillation data do not, by themselves, determine a
global binding/escape condition. Extra global hypotheses about the potential
are required for any bound-state theorem.
-/
theorem real_nonzero_oscillation_does_not_universally_imply_below_escape_threshold :
    ¬ ∀ (s : OscillationData) (escapeThreshold : ℝ),
        RealNonzeroOscillation s → BelowEscapeThreshold s escapeThreshold := by
  intro alleged
  let s : OscillationData := {
    potentialValue := 1
    firstDerivative := 0
    curvature := 1
    reducedMass := 1
    omega := 1
    stationary := rfl
    reducedMassPositive := by exact zero_lt_one
    dispersion := by simp
  }
  have hMode : RealNonzeroOscillation s := by
    dsimp [RealNonzeroOscillation, s]
    exact one_ne_zero
  have hBelow := alleged s 0 hMode
  change (1 : ℝ) < 0 at hBelow
  exact (not_lt_of_ge (le_of_lt zero_lt_one)) hBelow

/--
Stronger negative control: two states can have identical local curvature,
mass, and frequency while lying on opposite sides of the same escape threshold.
Local oscillation therefore does not decide binding even when the threshold is
held fixed.
-/
theorem identical_local_dynamics_can_disagree_about_binding :
    ∃ sBound sUnbound : OscillationData,
      SameLocalDynamics sBound sUnbound ∧
      RealNonzeroOscillation sBound ∧
      RealNonzeroOscillation sUnbound ∧
      BelowEscapeThreshold sBound 0 ∧
      ¬ BelowEscapeThreshold sUnbound 0 := by
  let sBound : OscillationData := {
    potentialValue := -1
    firstDerivative := 0
    curvature := 1
    reducedMass := 1
    omega := 1
    stationary := rfl
    reducedMassPositive := by exact zero_lt_one
    dispersion := by simp
  }
  let sUnbound : OscillationData := {
    potentialValue := 1
    firstDerivative := 0
    curvature := 1
    reducedMass := 1
    omega := 1
    stationary := rfl
    reducedMassPositive := by exact zero_lt_one
    dispersion := by simp
  }
  refine ⟨sBound, sUnbound, ?_, ?_, ?_, ?_, ?_⟩
  · exact ⟨rfl, rfl, rfl, rfl⟩
  · dsimp [RealNonzeroOscillation, sBound]
    exact one_ne_zero
  · dsimp [RealNonzeroOscillation, sUnbound]
    exact one_ne_zero
  · dsimp [BelowEscapeThreshold, sBound]
    exact neg_one_lt_zero
  · dsimp [BelowEscapeThreshold, sUnbound]
    exact not_lt_of_ge (le_of_lt zero_lt_one)

#print axioms positive_curvature_of_real_nonzero_oscillation
#print axioms positive_curvature_of_nonzero_normal_mode
#print axioms local_quadratic_stability_of_nonzero_normal_mode
#print axioms no_real_nonzero_oscillation_of_nonpositive_curvature
#print axioms real_nonzero_oscillation_iff_positive_curvature
#print axioms zero_frequency_iff_zero_curvature
#print axioms real_nonzero_oscillation_does_not_universally_imply_below_escape_threshold
#print axioms identical_local_dynamics_can_disagree_about_binding

end Theophysics.PhaseStructure

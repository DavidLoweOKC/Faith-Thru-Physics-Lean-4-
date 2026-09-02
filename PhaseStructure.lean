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
  curvature : ℝ
  reducedMass : ℝ
  omega : ℝ
  reducedMassPositive : 0 < reducedMass
  dispersion : omega ^ 2 = curvature / reducedMass

/-- A nonzero normal mode, intentionally stated without semantic labels. -/
def RealNonzeroOscillation (s : OscillationData) : Prop :=
  s.omega ≠ 0

/-- A local energy condition standing in for a separately supplied escape threshold. -/
def BelowEscapeThreshold (s : OscillationData) (escapeThreshold : ℝ) : Prop :=
  s.potentialValue < escapeThreshold

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

/-- Nonpositive curvature rules out a real nonzero mode when mass is positive. -/
theorem no_real_nonzero_oscillation_of_nonpositive_curvature
    (s : OscillationData) (hCurvature : s.curvature ≤ 0) :
    ¬ RealNonzeroOscillation s := by
  intro hMode
  have hPositive := positive_curvature_of_real_nonzero_oscillation s hMode
  exact (not_lt_of_ge hCurvature) hPositive

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
    curvature := 1
    reducedMass := 1
    omega := 1
    reducedMassPositive := by exact zero_lt_one
    dispersion := by simp
  }
  have hMode : RealNonzeroOscillation s := by
    dsimp [RealNonzeroOscillation, s]
    exact one_ne_zero
  have hBelow := alleged s 0 hMode
  change (1 : ℝ) < 0 at hBelow
  exact (not_lt_of_ge (le_of_lt zero_lt_one)) hBelow

#print axioms positive_curvature_of_real_nonzero_oscillation
#print axioms no_real_nonzero_oscillation_of_nonpositive_curvature
#print axioms real_nonzero_oscillation_does_not_universally_imply_below_escape_threshold

end Theophysics.PhaseStructure

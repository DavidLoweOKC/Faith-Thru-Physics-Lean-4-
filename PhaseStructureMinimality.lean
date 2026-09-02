import Mathlib.Data.Real.Basic

/-!
# Phase Structure Assumption-Minimality Gauntlet

This file removes the local-potential record and works only with three real
scalars: curvature `κ`, mass `μ`, and frequency `ω`.

The tests proceed from weaker to stronger information.  Failed targets receive
explicit counterexamples; the final positive theorem uses no stationarity,
potential value, binding predicate, or semantic/theological label.
-/

namespace Theophysics.PhaseStructureMinimality

/-- The supplied quadratic dispersion relation. -/
def Dispersion (κ μ ω : ℝ) : Prop :=
  ω ^ 2 = κ / μ

/-- Dispersion alone yields only a nonnegative ratio. -/
theorem dispersion_implies_nonnegative_ratio
    (κ μ ω : ℝ) (hDispersion : Dispersion κ μ ω) :
    0 ≤ κ / μ := by
  rw [← hDispersion]
  exact sq_nonneg ω

/-- Negative control: dispersion alone does not force strict positive curvature. -/
theorem dispersion_alone_does_not_imply_positive_curvature :
    ¬ ∀ κ μ ω : ℝ, Dispersion κ μ ω → 0 < κ := by
  intro alleged
  have hPositive := alleged 0 1 0 (by simp [Dispersion])
  exact (lt_irrefl 0) hPositive

/-- Adding a nonzero mode strengthens the ratio from nonnegative to positive. -/
theorem nonzero_mode_implies_positive_ratio
    (κ μ ω : ℝ) (hMode : ω ≠ 0) (hDispersion : Dispersion κ μ ω) :
    0 < κ / μ := by
  rw [← hDispersion]
  exact sq_pos_of_ne_zero hMode

/--
With a nonzero mode, curvature and mass must occupy the same strict-sign
branch, but the equations alone do not select the positive branch.
-/
theorem nonzero_mode_forces_same_sign_branch
    (κ μ ω : ℝ) (hMode : ω ≠ 0) (hDispersion : Dispersion κ μ ω) :
    (0 < κ ∧ 0 < μ) ∨ (κ < 0 ∧ μ < 0) := by
  exact div_pos_iff.mp (nonzero_mode_implies_positive_ratio κ μ ω hMode hDispersion)

/-- A nonzero mode plus dispersion automatically excludes zero mass. -/
theorem nonzero_mode_forces_nonzero_mass
    (κ μ ω : ℝ) (hMode : ω ≠ 0) (hDispersion : Dispersion κ μ ω) :
    μ ≠ 0 := by
  intro hMassZero
  have hSquareZero : ω ^ 2 = 0 := by
    rw [hDispersion, hMassZero]
    simp
  exact hMode ((sq_eq_zero_iff).mp hSquareZero)

/--
Negative control: nonzero mass is insufficient because the negative-mass,
negative-curvature branch still satisfies the same dispersion equation.
-/
theorem nonzero_mass_does_not_select_positive_curvature :
    ¬ ∀ κ μ ω : ℝ,
        μ ≠ 0 → ω ≠ 0 → Dispersion κ μ ω → 0 < κ := by
  intro alleged
  have hPositive := alleged (-1) (-1) 1 (by simp) (by simp)
    (by simp [Dispersion])
  exact (not_lt_of_ge (by
    exact neg_nonpos.mpr (le_of_lt zero_lt_one))) hPositive

/--
The weakest natural mass-sign assumption tested here is nonnegative mass.
Zero mass need not be excluded separately: nonzero mode plus dispersion already
rules it out.  This is the minimum surviving positive-branch theorem in this
gauntlet.
-/
theorem positive_curvature_of_nonzero_mode_and_nonnegative_mass
    (κ μ ω : ℝ)
    (hMassNonnegative : 0 ≤ μ)
    (hMode : ω ≠ 0)
    (hDispersion : Dispersion κ μ ω) :
    0 < κ := by
  rcases nonzero_mode_forces_same_sign_branch κ μ ω hMode hDispersion with
    hPositive | hNegative
  · exact hPositive.1
  · exact False.elim ((not_lt_of_ge hMassNonnegative) hNegative.2)

/-- Removing the nonzero-mode condition permits the flat zero-frequency case. -/
theorem nonzero_mode_is_load_bearing :
    ¬ ∀ κ μ ω : ℝ,
        0 ≤ μ → Dispersion κ μ ω → 0 < κ := by
  intro alleged
  have hPositive := alleged 0 1 0 (by exact le_of_lt zero_lt_one)
    (by simp [Dispersion])
  exact (lt_irrefl 0) hPositive

/-- Removing dispersion leaves curvature independent of mass and frequency. -/
theorem dispersion_is_load_bearing :
    ¬ ∀ κ μ ω : ℝ,
        0 ≤ μ → ω ≠ 0 → 0 < κ := by
  intro alleged
  have hPositive := alleged (-1) 1 1 (by exact le_of_lt zero_lt_one) (by simp)
  exact (not_lt_of_ge (by
    exact neg_nonpos.mpr (le_of_lt zero_lt_one))) hPositive

/-- Removing the nonnegative-mass branch condition admits the negative branch. -/
theorem nonnegative_mass_is_load_bearing :
    ¬ ∀ κ μ ω : ℝ,
        ω ≠ 0 → Dispersion κ μ ω → 0 < κ := by
  intro alleged
  have hPositive := alleged (-1) (-1) 1 (by simp) (by simp [Dispersion])
  exact (not_lt_of_ge (by
    exact neg_nonpos.mpr (le_of_lt zero_lt_one))) hPositive

#print axioms dispersion_implies_nonnegative_ratio
#print axioms dispersion_alone_does_not_imply_positive_curvature
#print axioms nonzero_mode_implies_positive_ratio
#print axioms nonzero_mode_forces_same_sign_branch
#print axioms nonzero_mode_forces_nonzero_mass
#print axioms nonzero_mass_does_not_select_positive_curvature
#print axioms positive_curvature_of_nonzero_mode_and_nonnegative_mass
#print axioms nonzero_mode_is_load_bearing
#print axioms dispersion_is_load_bearing
#print axioms nonnegative_mass_is_load_bearing

end Theophysics.PhaseStructureMinimality

import Mathlib.Data.Real.Basic

/-!
# Privative Magnitude Kernel

This file formalizes only the real-number structure

  E = σ * (1 - d) * P

where `P > 0`, `0 ≤ d ≤ 1`, and `σ ∈ {-1, +1}`.

Mathematical reading:
* `P` is the supplied positive capacity.
* `d` is its deprivation level.
* `σ` changes direction, not magnitude.

Framework bridge (not proved by Lean): interpreting supplied capacity as a
created good and negative orientation as evil enactment yields the
"borrowed-power" model.  The theorems below prove the algebra of that model;
they do not prove the theological identification.
-/

namespace PrivativeMagnitude

/-- The two allowed orientations. -/
inductive Orientation where
  | toward
  | against
  deriving DecidableEq

namespace Orientation

/-- The real scalar associated with an orientation. -/
def sign : Orientation → ℝ
  | toward => 1
  | against => -1

@[simp] theorem abs_sign (σ : Orientation) : |σ.sign| = 1 := by
  cases σ <;> simp [sign]

end Orientation

/-- Positive supplied capacity together with a bounded deprivation level. -/
structure State where
  power : ℝ
  power_pos : 0 < power
  deprivation : ℝ
  deprivation_nonneg : 0 ≤ deprivation
  deprivation_le_one : deprivation ≤ 1

/-- Capacity remaining after deprivation. -/
def remaining (s : State) : ℝ := (1 - s.deprivation) * s.power

/-- Enacted effect: orientation times remaining supplied capacity. -/
def effect (σ : Orientation) (s : State) : ℝ := σ.sign * remaining s

theorem remaining_nonneg (s : State) : 0 ≤ remaining s := by
  unfold remaining
  exact mul_nonneg (sub_nonneg.mpr s.deprivation_le_one) (le_of_lt s.power_pos)

theorem remaining_le_power (s : State) : remaining s ≤ s.power := by
  unfold remaining
  calc
    (1 - s.deprivation) * s.power ≤ 1 * s.power :=
      mul_le_mul_of_nonneg_right
        (sub_le_self 1 s.deprivation_nonneg)
        (le_of_lt s.power_pos)
    _ = s.power := one_mul _

/-- Exact magnitude formula: orientation contributes no magnitude. -/
theorem abs_effect_eq_remaining (σ : Orientation) (s : State) :
    |effect σ s| = remaining s := by
  rw [effect, abs_mul, Orientation.abs_sign, one_mul]
  exact abs_of_nonneg (remaining_nonneg s)

/-- The enacted magnitude never exceeds the supplied positive capacity. -/
theorem bounded_power (σ : Orientation) (s : State) :
    |effect σ s| ≤ s.power := by
  rw [abs_effect_eq_remaining]
  exact remaining_le_power s

/-- Total deprivation makes every oriented enactment zero. -/
theorem total_deprivation_annihilates (σ : Orientation) (s : State)
    (hTotal : s.deprivation = 1) : effect σ s = 0 := by
  simp [effect, remaining, hTotal]

/-- At fixed power and deprivation, opposite orientations have equal magnitude. -/
theorem sign_changes_direction_not_magnitude (s : State) :
    |effect Orientation.toward s| = |effect Orientation.against s| := by
  rw [abs_effect_eq_remaining, abs_effect_eq_remaining]

/-- Increasing deprivation weakly decreases enacted magnitude. -/
theorem deprivation_reduces_capacity
    (σ : Orientation) (s₁ s₂ : State)
    (samePower : s₁.power = s₂.power)
    (moreDeprived : s₁.deprivation ≤ s₂.deprivation) :
    |effect σ s₂| ≤ |effect σ s₁| := by
  calc
    |effect σ s₂| = remaining s₂ := abs_effect_eq_remaining σ s₂
    _ ≤ remaining s₁ := by
      unfold remaining
      rw [← samePower]
      exact mul_le_mul_of_nonneg_right
        (sub_le_sub_left moreDeprived 1)
        (le_of_lt s₁.power_pos)
    _ = |effect σ s₁| := (abs_effect_eq_remaining σ s₁).symm

/-- Negative enactment is exactly the negation of remaining positive capacity;
no independent negative magnitude appears in the expression. -/
theorem opposition_is_borrowed (s : State) :
    effect Orientation.against s = -remaining s := by
  simp [effect, Orientation.sign]

#print axioms abs_effect_eq_remaining
#print axioms bounded_power
#print axioms total_deprivation_annihilates
#print axioms sign_changes_direction_not_magnitude
#print axioms deprivation_reduces_capacity
#print axioms opposition_is_borrowed

end PrivativeMagnitude

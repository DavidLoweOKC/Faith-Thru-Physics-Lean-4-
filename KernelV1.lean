import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Kernel V1

Exact Lean counterpart of the first Z3 validation kernel:

* nine real normalized coordinates and their multiplicative score;
* unit-interval bounds, zero-veto, rigidity at one, and monotonicity;
* the cleared-denominator Cornell stationary-point obstruction;
* separation of an idempotent channel from a sign-changing nilpotent jump.

The file intentionally does not import the older ten-`Nat` `FactorState` model.
-/

open scoped BigOperators Matrix

namespace Theophysics.KernelV1

abbrev Coordinates := Fin 9 → ℝ

def InUnitCube (x : Coordinates) : Prop :=
  ∀ i, 0 ≤ x i ∧ x i ≤ 1

def kernelProduct (x : Coordinates) : ℝ :=
  ∏ i, x i

private theorem prod_nonneg_of_unit
    {ι : Type*} [Fintype ι] (f : ι → ℝ)
    (hf : ∀ i, 0 ≤ f i ∧ f i ≤ 1) :
    0 ≤ ∏ i, f i := by
  exact Finset.prod_nonneg fun i _ => (hf i).1

private theorem prod_le_one_of_unit
    {ι : Type*} [Fintype ι] (f : ι → ℝ)
    (hf : ∀ i, 0 ≤ f i ∧ f i ≤ 1) :
    (∏ i, f i) ≤ 1 := by
  exact Finset.prod_le_one (fun i _ => (hf i).1) (fun i _ => (hf i).2)

private theorem prod_eq_one_forces_factors_one
    {ι : Type*} [Fintype ι] (f : ι → ℝ)
    (hf : ∀ i, 0 ≤ f i ∧ f i ≤ 1)
    (hprod : ∏ i, f i = 1) :
    ∀ i, f i = 1 := by
  intro i
  by_contra hne
  have hlt : f i < 1 := lt_of_le_of_ne (hf i).2 hne
  classical
  rw [← Finset.mul_prod_erase Finset.univ f (Finset.mem_univ i)] at hprod
  have hrest_nonneg : 0 ≤ ∏ j ∈ Finset.univ.erase i, f j := by
    exact Finset.prod_nonneg fun j hj => (hf j).1
  have hrest_le : (∏ j ∈ Finset.univ.erase i, f j) ≤ 1 := by
    exact Finset.prod_le_one
      (fun j hj => (hf j).1)
      (fun j hj => (hf j).2)
  have hmul : f i * (∏ j ∈ Finset.univ.erase i, f j) ≤ f i := by
    exact mul_le_of_le_one_right (hf i).1 hrest_le
  rw [hprod] at hmul
  exact (not_lt_of_ge hmul) hlt

theorem normalized_domain_nonempty :
    ∃ x : Coordinates,
      InUnitCube x ∧ kernelProduct x = (1 / 2 : ℝ) ^ 9 := by
  refine ⟨fun _ => (1 / 2 : ℝ), ?_, ?_⟩
  · intro i
    norm_num
  · simp [kernelProduct]

theorem product_stays_in_unit_interval
    (x : Coordinates) (hx : InUnitCube x) :
    0 ≤ kernelProduct x ∧ kernelProduct x ≤ 1 := by
  constructor
  · exact prod_nonneg_of_unit x hx
  · exact prod_le_one_of_unit x hx

theorem zero_veto
    (x : Coordinates) (j : Fin 9) (hj : x j = 0) :
    kernelProduct x = 0 := by
  classical
  exact Finset.prod_eq_zero (Finset.mem_univ j) hj

theorem product_one_forces_all_coordinates_one
    (x : Coordinates) (hx : InUnitCube x)
    (hprod : kernelProduct x = 1) :
    ∀ i, x i = 1 := by
  exact prod_eq_one_forces_factors_one x hx hprod

theorem coordinatewise_increase_cannot_lower_product
    (x y : Coordinates) (hx : InUnitCube x) (_hy : InUnitCube y)
    (hxy : ∀ i, x i ≤ y i) :
    kernelProduct x ≤ kernelProduct y := by
  unfold kernelProduct
  exact Finset.prod_le_prod
    (fun i _ => (hx i).1)
    (fun i _ => hxy i)

/-! ## Cornell stationary-point obstruction -/

def cornellStationaryPolynomial (α κ r : ℝ) : ℝ :=
  α + κ * r ^ 2

/--
For `V(r) = -α/r + κr`, the equation `V'(r)=0`, after multiplication by the
positive denominator `r²`, is `α + κr² = 0`. Positive `α`, `κ`, and radius
make that equation impossible. This is a statement about the bare potential,
not the spectrum of the full Hamiltonian.
-/
theorem bare_cornell_has_no_positive_radius_stationary_point
    (α κ r : ℝ) (hα : 0 < α) (hκ : 0 < κ) (_hr : 0 < r) :
    cornellStationaryPolynomial α κ r ≠ 0 := by
  unfold cornellStationaryPolynomial
  have hrsq : 0 ≤ r ^ 2 := sq_nonneg r
  have hterm : 0 ≤ κ * r ^ 2 := mul_nonneg (le_of_lt hκ) hrsq
  nlinarith

/-! ## Two-sector operator separation -/

abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℝ

def signOperator : Mat2 :=
  ![![(1 : ℝ), 0], ![0, -1]]

/-- Explicit full multiplication for two-by-two matrices. -/
def mul2 (A B : Mat2) : Mat2 := fun i j =>
  A i 0 * B 0 j + A i 1 * B 1 j

def AnticommutesWithSign (G : Mat2) : Prop :=
  ∀ i j, mul2 signOperator G i j + mul2 G signOperator i j = 0

def Idempotent (G : Mat2) : Prop :=
  mul2 G G = G

def Nilpotent (J : Mat2) : Prop :=
  mul2 J J = 0

theorem anticommuting_idempotent_is_zero
    (G : Mat2) (hanti : AnticommutesWithSign G)
    (hid : Idempotent G) :
    G = 0 := by
  have h00 := hanti (0 : Fin 2) (0 : Fin 2)
  have h11 := hanti (1 : Fin 2) (1 : Fin 2)
  have hid01 := congrFun (congrFun hid (0 : Fin 2)) (1 : Fin 2)
  have hid10 := congrFun (congrFun hid (1 : Fin 2)) (0 : Fin 2)
  simp [AnticommutesWithSign, signOperator, mul2] at h00 h11
  simp [Idempotent, mul2, h00, h11] at hid01 hid10
  have h01 : G 0 1 = 0 := hid01.symm
  have h10 : G 1 0 = 0 := hid10.symm
  ext i j
  fin_cases i <;> fin_cases j <;> simp [h00, h11, h01, h10]

theorem nonzero_anticommuting_idempotent_is_impossible :
    ¬ ∃ G : Mat2,
      G ≠ 0 ∧ AnticommutesWithSign G ∧ Idempotent G := by
  rintro ⟨G, hG, hanti, hid⟩
  exact hG (anticommuting_idempotent_is_zero G hanti hid)

def conversionJump : Mat2 :=
  ![![0, 1], ![0, 0]]

theorem conversionJump_nonzero : conversionJump ≠ 0 := by
  intro h
  have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
  norm_num [conversionJump] at h01

theorem conversionJump_anticommutes :
    AnticommutesWithSign conversionJump := by
  intro i j
  fin_cases i <;> fin_cases j <;>
    norm_num [AnticommutesWithSign, conversionJump, signOperator, mul2]

theorem conversionJump_nilpotent :
    Nilpotent conversionJump := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Nilpotent, conversionJump, mul2]

theorem nonzero_anticommuting_nilpotent_jump_exists :
    ∃ J : Mat2, J ≠ 0 ∧ AnticommutesWithSign J ∧ Nilpotent J := by
  exact ⟨conversionJump, conversionJump_nonzero,
    conversionJump_anticommutes, conversionJump_nilpotent⟩

#print axioms normalized_domain_nonempty
#print axioms product_stays_in_unit_interval
#print axioms zero_veto
#print axioms product_one_forces_all_coordinates_one
#print axioms coordinatewise_increase_cannot_lower_product
#print axioms bare_cornell_has_no_positive_radius_stationary_point
#print axioms anticommuting_idempotent_is_zero
#print axioms nonzero_anticommuting_idempotent_is_impossible
#print axioms nonzero_anticommuting_nilpotent_jump_exists

end Theophysics.KernelV1

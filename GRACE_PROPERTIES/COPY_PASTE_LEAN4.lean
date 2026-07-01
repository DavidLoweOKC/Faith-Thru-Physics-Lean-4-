/-
  COPY-PASTE LEAN 4 CHECK FILE
  ============================

  Paste this entire file into Lean 4, or save it as COPY_PASTE_LEAN4.lean and run:

    lean COPY_PASTE_LEAN4.lean

  It contains the smallest standalone checks for:
    - product collapse
    - grace idempotence and non-invertibility
    - fruits of the Spirit gate
    - zero-preserving justice/mercy operator
-/

namespace Theophysics.CopyPaste

universe u

class CoherenceAlgebra (α : Type u) where
  zero : α
  one : α
  mul : α → α → α
  zero_mul : ∀ a : α, mul zero a = zero
  mul_zero : ∀ a : α, mul a zero = zero
  one_ne_zero : one ≠ zero
  no_zero_divisors : ∀ a b : α, mul a b = zero → a = zero ∨ b = zero

namespace CoherenceAlgebra

variable {α : Type u} [A : CoherenceAlgebra α]

def listProd : List α → α
  | [] => A.one
  | x :: xs => A.mul x (listProd xs)

theorem listProd_eq_zero_of_mem_zero :
    ∀ xs : List α, A.zero ∈ xs → listProd xs = A.zero := by
  intro xs h
  induction xs with
  | nil => cases h
  | cons x xs ih =>
      dsimp [listProd]
      cases h with
      | head => exact A.zero_mul (listProd xs)
      | tail _ htail =>
          rw [ih htail]
          exact A.mul_zero x

theorem mem_zero_of_listProd_eq_zero :
    ∀ xs : List α, listProd xs = A.zero → A.zero ∈ xs := by
  intro xs h
  induction xs with
  | nil =>
      dsimp [listProd] at h
      exact False.elim (A.one_ne_zero h)
  | cons x xs ih =>
      dsimp [listProd] at h
      have hz := A.no_zero_divisors x (listProd xs) h
      cases hz with
      | inl hx =>
          rw [hx]
          exact List.Mem.head xs
      | inr hxs =>
          exact List.Mem.tail x (ih hxs)

theorem listProd_eq_zero_iff (xs : List α) :
    listProd xs = A.zero ↔ A.zero ∈ xs :=
  Iff.intro (mem_zero_of_listProd_eq_zero xs) (listProd_eq_zero_of_mem_zero xs)

end CoherenceAlgebra

inductive Regime where
  | constructive
  | destructive
  deriving DecidableEq, Repr

def grace : Regime → Regime
  | Regime.constructive => Regime.constructive
  | Regime.destructive => Regime.constructive

theorem grace_idempotent (r : Regime) :
    grace (grace r) = grace r := by
  cases r <;> rfl

theorem grace_not_left_invertible :
    ¬ ∃ f : Regime → Regime, ∀ r : Regime, f (grace r) = r := by
  intro h
  rcases h with ⟨f, hf⟩
  have hc := hf Regime.constructive
  have hd := hf Regime.destructive
  dsimp [grace] at hc hd
  rw [hc] at hd
  contradiction

inductive Fruit where
  | love | joy | peace | patience | kindness | goodness | faithfulness | gentleness | selfControl
  deriving DecidableEq, Repr

namespace Fruit

def all : List Fruit :=
  [love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, selfControl]

theorem count : all.length = 9 := by
  rfl

theorem no_duplicates : all.Nodup := by
  decide

end Fruit

structure FruitProfile where
  manifest : Fruit → Bool

namespace FruitProfile

def allManifest (p : FruitProfile) : Prop :=
  ∀ f : Fruit, p.manifest f = true

def gate (p : FruitProfile) : Bool :=
  Fruit.all.all p.manifest

theorem gate_true_of_allManifest (p : FruitProfile)
    (h : p.allManifest) :
    p.gate = true := by
  unfold gate
  simp [Fruit.all, allManifest] at h ⊢
  exact ⟨h Fruit.love, h Fruit.joy, h Fruit.peace, h Fruit.patience,
    h Fruit.kindness, h Fruit.goodness, h Fruit.faithfulness,
    h Fruit.gentleness, h Fruit.selfControl⟩

theorem gate_false_of_missing_love (p : FruitProfile)
    (h : p.manifest Fruit.love = false) :
    p.gate = false := by
  unfold gate
  simp [Fruit.all, h]

end FruitProfile

structure ZeroPreservingOperator (α : Type u) [Zero α] where
  apply : α → α
  preserves_zero : apply 0 = 0

theorem zero_preserving_operator_cannot_rescue
    {α : Type u} [Zero α] (op : ZeroPreservingOperator α) :
    op.apply 0 = 0 :=
  op.preserves_zero

end Theophysics.CopyPaste

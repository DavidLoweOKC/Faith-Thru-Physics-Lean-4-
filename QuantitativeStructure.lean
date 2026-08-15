/-
Lean 4 experiment: quantitative structure without ordinary numerals.

This module does not prove Platonism, God, the Big Bang, or that abstract
numbers exist before the universe. It proves the narrower formal claim that
representation does not create one-to-one correspondence structure.

Main theorem:

  no_bijection_three_two : Bijection Three Two -> False

The theorem statement uses no natural numbers, cardinality function, counting
algorithm, measurement unit, decimal notation, or arithmetic operation.
-/

namespace QuantitativeStructure

/- A one-to-one correspondence, defined explicitly rather than using cardinality. -/
structure Bijection (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  leftInv : forall a : A, invFun (toFun a) = a
  rightInv : forall b : B, toFun (invFun b) = b

/- Anything possessing a left inverse is injective. -/
theorem Bijection.injective {A B : Type} (e : Bijection A B)
    {a b : A} (h : e.toFun a = e.toFun b) : a = b := by
  calc
    a = e.invFun (e.toFun a) := (e.leftInv a).symm
    _ = e.invFun (e.toFun b) := by rw [h]
    _ = b := e.leftInv b

/- Inverting a bijection is only relabeling the same correspondence. -/
def Bijection.symm {A B : Type} (e : Bijection A B) : Bijection B A where
  toFun := e.invFun
  invFun := e.toFun
  leftInv := e.rightInv
  rightInv := e.leftInv

/- Bijections compose. -/
def Bijection.trans {A B C : Type}
    (e1 : Bijection A B)
    (e2 : Bijection B C) : Bijection A C where
  toFun := fun a => e2.toFun (e1.toFun a)
  invFun := fun c => e1.invFun (e2.invFun c)
  leftInv := by
    intro a
    rw [e2.leftInv, e1.leftInv]
  rightInv := by
    intro c
    rw [e1.rightInv, e2.rightInv]

/- These are abstract distinction structures. The names are not numerical premises. -/
inductive Three where
  | a
  | b
  | c

inductive Two where
  | x
  | y
deriving DecidableEq

open Three Two

/- Given any three inhabitants of Two, at least two must coincide. -/
theorem collision_in_two (u v w : Two) : Or (u = v) (Or (u = w) (v = w)) := by
  cases u <;> cases v <;> cases w <;> simp

/- There can be no bijection between the three-distinction and two-distinction structures. -/
theorem no_bijection_three_two : Bijection Three Two -> False := by
  intro e
  have h := collision_in_two (e.toFun a) (e.toFun b) (e.toFun c)
  rcases h with hab | hac | hbc
  case inl =>
    have hEq : a = b := e.injective hab
    cases hEq
  case inr.inl =>
    have hEq : a = c := e.injective hac
    cases hEq
  case inr.inr =>
    have hEq : b = c := e.injective hbc
    cases hEq

/- Relabeling preserves whether a bijection exists. -/
theorem relabel_bijection_iff
    {A B LabelA LabelB : Type}
    (nameA : Bijection A LabelA)
    (nameB : Bijection B LabelB) :
    Iff (Nonempty (Bijection A B)) (Nonempty (Bijection LabelA LabelB)) := by
  constructor
  case mp =>
    intro h
    cases h with
    | intro e =>
      exact Nonempty.intro (Bijection.trans (Bijection.trans nameA.symm e) nameB)
  case mpr =>
    intro h
    cases h with
    | intro e =>
      exact Nonempty.intro (Bijection.trans (Bijection.trans nameA e) nameB.symm)

/- Therefore labels cannot manufacture a bijection that the structures lack. -/
theorem relabels_do_not_create_bijection
    {A B LabelA LabelB : Type}
    (nameA : Bijection A LabelA)
    (nameB : Bijection B LabelB)
    (h : Not (Nonempty (Bijection A B))) :
    Not (Nonempty (Bijection LabelA LabelB)) := by
  intro labeled
  exact h ((relabel_bijection_iff nameA nameB).mpr labeled)

end QuantitativeStructure

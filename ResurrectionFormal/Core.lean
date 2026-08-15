/-!
# ResurrectionFormal.Core

A deliberately small formal core for the "dual-substrate" draft.

This file does not attempt to prove the historical or physical claims in the
paper. It formalizes a few structural claims that are precise enough for Lean:

* a coupling state can be represented by observable architecture flags;
* `C0` and `C1` are distinct;
* a one-way transition relation can be stated and proved irreversible;
* the `Q = 0` gate in a multiplicative master equation collapses the result.
-/

namespace ResurrectionFormal

inductive TemporalType where
  | unbounded
  | bounded
deriving DecidableEq, Repr

inductive SymmetryType where
  | high
  | broken
deriving DecidableEq, Repr

structure Substrate where
  temporal : TemporalType
  symmetry : SymmetryType
deriving DecidableEq, Repr

def SigmaF : Substrate :=
  { temporal := TemporalType.unbounded
    symmetry := SymmetryType.high }

def SigmaD : Substrate :=
  { temporal := TemporalType.bounded
    symmetry := SymmetryType.broken }

structure Coupling where
  distributed : Bool
  mediatorDependent : Bool
  selfSustaining : Bool
  geographicallyUniversal : Bool
deriving DecidableEq, Repr

def C0 : Coupling :=
  { distributed := false
    mediatorDependent := true
    selfSustaining := false
    geographicallyUniversal := false }

def C1 : Coupling :=
  { distributed := true
    mediatorDependent := false
    selfSustaining := true
    geographicallyUniversal := true }

theorem C0_ne_C1 : C0 ≠ C1 := by
  decide

theorem C1_ne_C0 : C1 ≠ C0 := by
  decide

inductive CouplingStep : Coupling → Coupling → Prop where
  | modification : CouplingStep C0 C1

def Irreversible (step : Coupling → Coupling → Prop) (a b : Coupling) : Prop :=
  step a b ∧ ¬ step b a

theorem coupling_modification_irreversible :
    Irreversible CouplingStep C0 C1 := by
  constructor
  · exact CouplingStep.modification
  · intro reverse
    cases reverse

def chi
    (G M E S T K R Q F C : Nat) : Nat :=
  G * M * E * S * T * K * R * Q * F * C

theorem Q_zero_collapses_chi
    (G M E S T K R F C : Nat) :
    chi G M E S T K R 0 F C = 0 := by
  simp [chi]

theorem Q_nonzero_not_sufficient_for_positive_chi
    (Q : Nat) :
    chi 0 1 1 1 1 1 1 Q 1 1 = 0 := by
  simp [chi]

end ResurrectionFormal

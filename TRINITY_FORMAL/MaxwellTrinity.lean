/-!
# ResurrectionFormal.MaxwellTrinity

Rejection-first structural tests for the Maxwell/quaternion EM and Trinity
claim.

This file deliberately does not prove the historical or empirical claim that
Maxwell's original equations really have the encoded structure. It proves the
narrow formal claim that, once the proposed triadic invariants are made
explicit, the intended quaternion/Trinity candidates satisfy them while nearby
wrong controls do not.

The adversarial controls are the important part:

* Heaviside/vector EM fails because its product invariant is decomposed.
* Modalism fails because relational distinctness is absent.
* A static single-field EM case fails because it is not a full dynamic field.
* An arbitrary three-part system fails because it lacks role structure.
* A relabeled role system fails because labels alone do not preserve profiles.

The positive isomorphism is attempted only after these rejection theorems.
-/

namespace ResurrectionFormal

namespace MaxwellTrinity

inductive TriadicRole where
  | source
  | mediator
  | actualizer
deriving DecidableEq, Repr

inductive OperationProfile where
  | sourceLike
  | mediatorLike
  | actualizerLike
  | genericPart
  | relabeledSource
  | relabeledMediator
  | relabeledActualizer
deriving DecidableEq, Repr

structure HQuat where
  s : Int
  x : Int
  y : Int
  z : Int
deriving DecidableEq, Repr

structure Vec3 where
  x : Int
  y : Int
  z : Int
deriving DecidableEq, Repr

def HQuat.vec (q : HQuat) : Vec3 :=
  { x := q.x, y := q.y, z := q.z }

def Vec3.dot (a b : Vec3) : Int :=
  a.x * b.x + a.y * b.y + a.z * b.z

def Vec3.cross (a b : Vec3) : Vec3 :=
  { x := a.y * b.z - a.z * b.y
    y := a.z * b.x - a.x * b.z
    z := a.x * b.y - a.y * b.x }

def HQuat.mul (a b : HQuat) : HQuat :=
  { s := a.s * b.s - a.x * b.x - a.y * b.y - a.z * b.z
    x := a.s * b.x + a.x * b.s + a.y * b.z - a.z * b.y
    y := a.s * b.y - a.x * b.z + a.y * b.s + a.z * b.x
    z := a.s * b.z + a.x * b.y - a.y * b.x + a.z * b.s }

structure VectorOnlyProductData where
  dot : Int
  cross : Vec3
deriving DecidableEq, Repr

def vectorOnlyProductData (a b : HQuat) : VectorOnlyProductData :=
  { dot := Vec3.dot a.vec b.vec
    cross := Vec3.cross a.vec b.vec }

structure ScalarVectorSplit where
  scalar : Int
  vx : Int
  vy : Int
  vz : Int
deriving DecidableEq, Repr

def HQuat.fullSplitProduct (a b : HQuat) : ScalarVectorSplit :=
  { scalar := a.s * b.s - a.x * b.x - a.y * b.y - a.z * b.z
    vx := a.s * b.x + a.x * b.s + a.y * b.z - a.z * b.y
    vy := a.s * b.y - a.x * b.z + a.y * b.s + a.z * b.x
    vz := a.s * b.z + a.x * b.y - a.y * b.x + a.z * b.s }

def ScalarVectorSplit.toQuat (p : ScalarVectorSplit) : HQuat :=
  { s := p.scalar, x := p.vx, y := p.vy, z := p.vz }

def scalarVectorCoupling (a b : HQuat) : Vec3 :=
  { x := a.s * b.x + b.s * a.x
    y := a.s * b.y + b.s * a.y
    z := a.s * b.z + b.s * a.z }

def CouplingInvariant {Out : Type} (product : HQuat -> HQuat -> Out) : Prop :=
  exists a₁ a₂ b : HQuat,
    vectorOnlyProductData a₁ b = vectorOnlyProductData a₂ b
      /\ product a₁ b ≠ product a₂ b

def scalarOne : HQuat := { s := 1, x := 0, y := 0, z := 0 }
def scalarTwo : HQuat := { s := 2, x := 0, y := 0, z := 0 }
def xVector : HQuat := { s := 0, x := 1, y := 0, z := 0 }

theorem full_quaternion_product_has_coupling_invariant :
    CouplingInvariant HQuat.mul := by
  exact ⟨scalarOne, scalarTwo, xVector, rfl, by decide⟩

theorem vector_only_product_lacks_coupling_invariant :
    Not (CouplingInvariant vectorOnlyProductData) := by
  intro h
  rcases h with ⟨a₁, a₂, b, hSame, hDiff⟩
  exact hDiff hSame

theorem full_scalar_vector_split_reconstructs_quaternion_product
    (a b : HQuat) :
    (HQuat.fullSplitProduct a b).toQuat = HQuat.mul a b := by
  rfl

def HQuat.sameVectorPart (a b : HQuat) : Prop :=
  a.x = b.x /\ a.y = b.y /\ a.z = b.z

theorem scalarOne_scalarTwo_same_vector_part :
    HQuat.sameVectorPart scalarOne scalarTwo := by
  constructor
  · rfl
  · constructor <;> rfl

theorem vector_only_data_does_not_determine_full_product :
    HQuat.mul scalarOne xVector ≠ HQuat.mul scalarTwo xVector := by
  decide

theorem same_vector_only_data_for_different_scalar_inputs :
    vectorOnlyProductData scalarOne xVector =
      vectorOnlyProductData scalarTwo xVector := by
  rfl

theorem scalar_vector_coupling_differs_for_same_vector_only_data :
    scalarVectorCoupling scalarOne xVector ≠
      scalarVectorCoupling scalarTwo xVector := by
  decide

theorem same_dot_cross_but_different_quaternion_product :
    vectorOnlyProductData scalarOne xVector =
        vectorOnlyProductData scalarTwo xVector
      /\ HQuat.mul scalarOne xVector ≠ HQuat.mul scalarTwo xVector := by
  constructor
  · rfl
  · decide

theorem vector_only_dot_cross_not_enough_for_quaternion_product :
    exists a₁ a₂ b : HQuat,
      vectorOnlyProductData a₁ b = vectorOnlyProductData a₂ b
        /\ HQuat.mul a₁ b ≠ HQuat.mul a₂ b := by
  exact ⟨scalarOne, scalarTwo, xVector,
    same_dot_cross_but_different_quaternion_product⟩

structure TriadicSystem where
  profile : TriadicRole -> OperationProfile
  couplingInvariant : Prop
  fullDynamicField : Bool
  relationallyDistinct : Bool
  mutuallyNecessary : Bool

def roleProfileExpected : TriadicRole -> OperationProfile
  | TriadicRole.source => OperationProfile.sourceLike
  | TriadicRole.mediator => OperationProfile.mediatorLike
  | TriadicRole.actualizer => OperationProfile.actualizerLike

def rolesHaveCanonicalProfiles (S : TriadicSystem) : Prop :=
  forall r, S.profile r = roleProfileExpected r

def ValidTriadic (S : TriadicSystem) : Prop :=
  rolesHaveCanonicalProfiles S
    /\ S.couplingInvariant
    /\ S.fullDynamicField = true
    /\ S.relationallyDistinct = true
    /\ S.mutuallyNecessary = true

/-! ## Positive candidates -/

def quaternionEM : TriadicSystem where
  profile := roleProfileExpected
  couplingInvariant := CouplingInvariant HQuat.mul
  fullDynamicField := true
  relationallyDistinct := true
  mutuallyNecessary := true

def trinityRelational : TriadicSystem where
  profile := roleProfileExpected
  couplingInvariant := CouplingInvariant HQuat.mul
  fullDynamicField := true
  relationallyDistinct := true
  mutuallyNecessary := true

theorem quaternionEM_valid : ValidTriadic quaternionEM := by
  constructor
  · intro r
    rfl
  · constructor
    · exact full_quaternion_product_has_coupling_invariant
    · constructor
      · rfl
      · constructor
        · rfl
        · rfl

theorem trinityRelational_valid : ValidTriadic trinityRelational := by
  constructor
  · intro r
    rfl
  · constructor
    · exact full_quaternion_product_has_coupling_invariant
    · constructor
      · rfl
      · constructor
        · rfl
        · rfl

/-! ## Rejection-first adversarial controls -/

def heavisideVectorEM : TriadicSystem where
  profile := roleProfileExpected
  couplingInvariant := CouplingInvariant vectorOnlyProductData
  fullDynamicField := true
  relationallyDistinct := true
  mutuallyNecessary := true

theorem heavisideVectorEM_invalid :
    Not (ValidTriadic heavisideVectorEM) := by
  intro h
  exact vector_only_product_lacks_coupling_invariant h.2.1

def modalism : TriadicSystem where
  profile := roleProfileExpected
  couplingInvariant := CouplingInvariant HQuat.mul
  fullDynamicField := true
  relationallyDistinct := false
  mutuallyNecessary := true

theorem modalism_invalid :
    Not (ValidTriadic modalism) := by
  intro h
  cases h.2.2.2.1

def staticSingleFieldEM : TriadicSystem where
  profile := roleProfileExpected
  couplingInvariant := CouplingInvariant HQuat.mul
  fullDynamicField := false
  relationallyDistinct := true
  mutuallyNecessary := true

theorem staticSingleFieldEM_invalid :
    Not (ValidTriadic staticSingleFieldEM) := by
  intro h
  cases h.2.2.1

def arbitraryThreePartSystem : TriadicSystem where
  profile := fun _ => OperationProfile.genericPart
  couplingInvariant := False
  fullDynamicField := true
  relationallyDistinct := true
  mutuallyNecessary := false

theorem arbitraryThreePartSystem_invalid :
    Not (ValidTriadic arbitraryThreePartSystem) := by
  intro h
  have hSource := h.1 TriadicRole.source
  exact OperationProfile.noConfusion hSource

def relabeledRoleSystem : TriadicSystem where
  profile := fun r =>
    match r with
    | TriadicRole.source => OperationProfile.relabeledSource
    | TriadicRole.mediator => OperationProfile.relabeledMediator
    | TriadicRole.actualizer => OperationProfile.relabeledActualizer
  couplingInvariant := CouplingInvariant HQuat.mul
  fullDynamicField := true
  relationallyDistinct := true
  mutuallyNecessary := true

theorem relabeledRoleSystem_invalid :
    Not (ValidTriadic relabeledRoleSystem) := by
  intro h
  have hSource := h.1 TriadicRole.source
  exact OperationProfile.noConfusion hSource

/-! ## Isomorphism after the rejections -/

structure TriadicIso (X Y : TriadicSystem) where
  mapRole : TriadicRole -> TriadicRole
  invRole : TriadicRole -> TriadicRole
  left_inverse : forall r, invRole (mapRole r) = r
  right_inverse : forall r, mapRole (invRole r) = r
  source_preserved : mapRole TriadicRole.source = TriadicRole.source
  mediator_preserved : mapRole TriadicRole.mediator = TriadicRole.mediator
  actualizer_preserved : mapRole TriadicRole.actualizer = TriadicRole.actualizer
  profile_preserved : forall r, Y.profile (mapRole r) = X.profile r
  coupling_preserved : Y.couplingInvariant = X.couplingInvariant
  dynamic_preserved : Y.fullDynamicField = X.fullDynamicField
  distinct_preserved : Y.relationallyDistinct = X.relationallyDistinct
  necessity_preserved : Y.mutuallyNecessary = X.mutuallyNecessary
  valid_source : ValidTriadic X
  valid_target : ValidTriadic Y

def quaternionTrinityIso : TriadicIso quaternionEM trinityRelational where
  mapRole := id
  invRole := id
  left_inverse := by
    intro r
    rfl
  right_inverse := by
    intro r
    rfl
  source_preserved := rfl
  mediator_preserved := rfl
  actualizer_preserved := rfl
  profile_preserved := by
    intro r
    rfl
  coupling_preserved := rfl
  dynamic_preserved := rfl
  distinct_preserved := rfl
  necessity_preserved := rfl
  valid_source := quaternionEM_valid
  valid_target := trinityRelational_valid

theorem no_iso_from_quaternion_to_heaviside :
    Not (Nonempty (TriadicIso quaternionEM heavisideVectorEM)) := by
  intro h
  cases h with
  | intro iso =>
      exact heavisideVectorEM_invalid iso.valid_target

theorem no_iso_from_trinity_to_modalism :
    Not (Nonempty (TriadicIso trinityRelational modalism)) := by
  intro h
  cases h with
  | intro iso =>
      exact modalism_invalid iso.valid_target

theorem no_iso_from_quaternion_to_static_single_field :
    Not (Nonempty (TriadicIso quaternionEM staticSingleFieldEM)) := by
  intro h
  cases h with
  | intro iso =>
      exact staticSingleFieldEM_invalid iso.valid_target

theorem no_iso_from_trinity_to_arbitrary_three_part :
    Not (Nonempty (TriadicIso trinityRelational arbitraryThreePartSystem)) := by
  intro h
  cases h with
  | intro iso =>
      exact arbitraryThreePartSystem_invalid iso.valid_target

theorem no_iso_from_trinity_to_relabels :
    Not (Nonempty (TriadicIso trinityRelational relabeledRoleSystem)) := by
  intro h
  cases h with
  | intro iso =>
      exact relabeledRoleSystem_invalid iso.valid_target

/-! ## Wrong-role map control

Even between the two accepted systems, a cyclic role reassignment fails the role
preservation obligations. This catches the "same words, wrong order" semantic
game.
-/

def cyclicRoleMap : TriadicRole -> TriadicRole
  | TriadicRole.source => TriadicRole.mediator
  | TriadicRole.mediator => TriadicRole.actualizer
  | TriadicRole.actualizer => TriadicRole.source

theorem cyclicRoleMap_not_source_preserving :
    Not (cyclicRoleMap TriadicRole.source = TriadicRole.source) := by
  intro h
  cases h

theorem cyclicRoleMap_not_profile_preserving :
    Not (forall r,
      trinityRelational.profile (cyclicRoleMap r) = quaternionEM.profile r) := by
  intro h
  have hSource := h TriadicRole.source
  exact OperationProfile.noConfusion hSource

/-! ## Load-bearing constraint audit

These theorems show that the rejection constraints are doing real work. If a
specific guard is removed, the corresponding false positive enters the system.
This is the formal version of "do not just get a pass; find out why it passed."
-/

def ValidWithoutCouplingInvariant (S : TriadicSystem) : Prop :=
  rolesHaveCanonicalProfiles S
    /\ S.fullDynamicField = true
    /\ S.relationallyDistinct = true
    /\ S.mutuallyNecessary = true

theorem heaviside_passes_if_coupling_guard_removed :
    ValidWithoutCouplingInvariant heavisideVectorEM := by
  constructor
  · intro r
    rfl
  · constructor
    · rfl
    · constructor
      · rfl
      · rfl

def ValidWithoutRelationalDistinctness (S : TriadicSystem) : Prop :=
  rolesHaveCanonicalProfiles S
    /\ S.couplingInvariant
    /\ S.fullDynamicField = true
    /\ S.mutuallyNecessary = true

theorem modalism_passes_if_distinctness_guard_removed :
    ValidWithoutRelationalDistinctness modalism := by
  constructor
  · intro r
    rfl
  · constructor
    · exact full_quaternion_product_has_coupling_invariant
    · constructor
      · rfl
      · rfl

def ValidWithoutDynamicFieldGuard (S : TriadicSystem) : Prop :=
  rolesHaveCanonicalProfiles S
    /\ S.couplingInvariant
    /\ S.relationallyDistinct = true
    /\ S.mutuallyNecessary = true

theorem static_single_field_passes_if_dynamic_guard_removed :
    ValidWithoutDynamicFieldGuard staticSingleFieldEM := by
  constructor
  · intro r
    rfl
  · constructor
    · exact full_quaternion_product_has_coupling_invariant
    · constructor
      · rfl
      · rfl

def ValidWithoutRoleProfiles (S : TriadicSystem) : Prop :=
  S.couplingInvariant
    /\ S.fullDynamicField = true
    /\ S.relationallyDistinct = true
    /\ S.mutuallyNecessary = true

theorem relabeled_roles_pass_if_profile_guard_removed :
    ValidWithoutRoleProfiles relabeledRoleSystem := by
  constructor
  · exact full_quaternion_product_has_coupling_invariant
  · constructor
    · rfl
    · constructor
      · rfl
      · rfl

def BareThreePartGate (_S : TriadicSystem) : Prop := True

theorem arbitrary_three_part_passes_bare_gate :
    BareThreePartGate arbitraryThreePartSystem := by
  trivial

/-! ## Boundary statement

Lean has verified the structural gate above. It has not verified that real
historical Maxwell quaternion electromagnetism has been faithfully abstracted
by `quaternionEM`, nor that the theological reading is the only possible
reading of `trinityRelational`. Those are specification-review questions.
-/

end MaxwellTrinity

end ResurrectionFormal

import Std

/-!
# Theophysics_Coherence

Small Std-only primitives for the coherence spine.

This file does not claim that thermodynamics proves theology. It formalizes the
structural pattern used by the framework:

* mere order is weaker than full coherence;
* passive decay is not active discoherence;
* restoration requires openness, input, paid cost, and preserved information.
-/

namespace Theophysics.Coherence

inductive SystemBoundary where
  | closed
  | open
deriving DecidableEq, Repr

inductive DecayKind where
  | passive
  | active
deriving DecidableEq, Repr

structure CoherenceProfile where
  distinctionsPreserved : Bool
  relationsOrdered : Bool
  operationsConsistent : Bool
  informationSurvives : Bool
  persistsThroughTime : Bool
  repairCapacity : Bool
  integratedUnderPressure : Bool
  actualizesWithoutCollapse : Bool
  truthBearing : Bool
  lifeBearing : Bool
  freedomRespecting : Bool
  restorative : Bool
deriving DecidableEq, Repr

def coherent (p : CoherenceProfile) : Bool :=
  p.distinctionsPreserved &&
  p.relationsOrdered &&
  p.operationsConsistent &&
  p.informationSurvives &&
  p.persistsThroughTime &&
  p.repairCapacity &&
  p.integratedUnderPressure &&
  p.actualizesWithoutCollapse &&
  p.truthBearing &&
  p.lifeBearing &&
  p.freedomRespecting &&
  p.restorative

def merelyOrdered (p : CoherenceProfile) : Bool :=
  p.distinctionsPreserved &&
  p.relationsOrdered &&
  p.operationsConsistent &&
  p.persistsThroughTime

def fullCoherence : CoherenceProfile where
  distinctionsPreserved := true
  relationsOrdered := true
  operationsConsistent := true
  informationSurvives := true
  persistsThroughTime := true
  repairCapacity := true
  integratedUnderPressure := true
  actualizesWithoutCollapse := true
  truthBearing := true
  lifeBearing := true
  freedomRespecting := true
  restorative := true

def coerciveOrder : CoherenceProfile where
  distinctionsPreserved := true
  relationsOrdered := true
  operationsConsistent := true
  informationSurvives := true
  persistsThroughTime := true
  repairCapacity := false
  integratedUnderPressure := true
  actualizesWithoutCollapse := true
  truthBearing := false
  lifeBearing := false
  freedomRespecting := false
  restorative := false

structure DecayProfile where
  kind : DecayKind
  targeted : Bool
  chosen : Bool
  relationallyDestructive : Bool
deriving DecidableEq, Repr

def passiveEntropySlope : DecayProfile where
  kind := DecayKind.passive
  targeted := false
  chosen := false
  relationallyDestructive := false

def activeDiscoherence : DecayProfile where
  kind := DecayKind.active
  targeted := true
  chosen := true
  relationallyDestructive := true

def isActiveDiscoherence (d : DecayProfile) : Bool :=
  (d.kind == DecayKind.active) &&
  d.targeted &&
  d.chosen &&
  d.relationallyDestructive

structure RestorationModel where
  boundary : SystemBoundary
  externalInput : Bool
  repairCostPaid : Bool
  informationPreserved : Bool
deriving DecidableEq, Repr

def canRestore (m : RestorationModel) : Bool :=
  (m.boundary == SystemBoundary.open) &&
  m.externalInput &&
  m.repairCostPaid &&
  m.informationPreserved

def closedWithoutInput : RestorationModel where
  boundary := SystemBoundary.closed
  externalInput := false
  repairCostPaid := false
  informationPreserved := true

def openWithPaidInput : RestorationModel where
  boundary := SystemBoundary.open
  externalInput := true
  repairCostPaid := true
  informationPreserved := true

theorem full_coherence_is_coherent :
    coherent fullCoherence = true := by
  rfl

theorem coercive_order_is_merely_ordered :
    merelyOrdered coerciveOrder = true := by
  rfl

theorem coercive_order_is_not_full_coherence :
    coherent coerciveOrder = false := by
  rfl

theorem mere_order_does_not_imply_full_coherence :
    ∃ p : CoherenceProfile, merelyOrdered p = true ∧ coherent p = false := by
  exact ⟨coerciveOrder, rfl, rfl⟩

theorem passive_decay_is_not_active_discoherence :
    isActiveDiscoherence passiveEntropySlope = false := by
  rfl

theorem active_discoherence_is_active :
    isActiveDiscoherence activeDiscoherence = true := by
  rfl

theorem closed_without_input_cannot_restore :
    canRestore closedWithoutInput = false := by
  rfl

theorem open_with_paid_input_can_restore :
    canRestore openWithPaidInput = true := by
  rfl

theorem restoration_requires_open_boundary
    (m : RestorationModel) (h : canRestore m = true) :
    m.boundary = SystemBoundary.open := by
  cases m with
  | mk boundary externalInput repairCostPaid informationPreserved =>
    cases boundary <;> cases externalInput <;> cases repairCostPaid <;>
      cases informationPreserved <;> simp [canRestore] at h ⊢

theorem restoration_requires_external_input
    (m : RestorationModel) (h : canRestore m = true) :
    m.externalInput = true := by
  cases m with
  | mk boundary externalInput repairCostPaid informationPreserved =>
    cases boundary <;> cases externalInput <;> cases repairCostPaid <;>
      cases informationPreserved <;> simp [canRestore] at h ⊢

theorem restoration_requires_paid_cost
    (m : RestorationModel) (h : canRestore m = true) :
    m.repairCostPaid = true := by
  cases m with
  | mk boundary externalInput repairCostPaid informationPreserved =>
    cases boundary <;> cases externalInput <;> cases repairCostPaid <;>
      cases informationPreserved <;> simp [canRestore] at h ⊢

theorem restoration_requires_information_preservation
    (m : RestorationModel) (h : canRestore m = true) :
    m.informationPreserved = true := by
  cases m with
  | mk boundary externalInput repairCostPaid informationPreserved =>
    cases boundary <;> cases externalInput <;> cases repairCostPaid <;>
      cases informationPreserved <;> simp [canRestore] at h ⊢

theorem thermodynamics_pattern_marker :
    coherent fullCoherence = true ∧
    coherent coerciveOrder = false ∧
    isActiveDiscoherence passiveEntropySlope = false ∧
    canRestore closedWithoutInput = false ∧
    canRestore openWithPaidInput = true := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

end Theophysics.Coherence

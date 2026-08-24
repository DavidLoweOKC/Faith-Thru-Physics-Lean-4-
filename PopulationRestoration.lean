import Std

/-!
# Population-wide restoration pressure test

Every internal person may be both victim and offender.  This kernel tests what
that network fact entails by itself, and what additional premise is required
before an external restorer follows.
-/

namespace Theophysics.PopulationRestoration

structure MoralPopulation (Person : Type) where
  offender : Person → Prop
  victim : Person → Prop
  restored : Person → Prop
  repairs : Person → Person → Prop

def universallyEntangled {Person : Type} (s : MoralPopulation Person) : Prop :=
  ∀ p, s.offender p ∧ s.victim p

def globallyRestored {Person : Type} (s : MoralPopulation Person) : Prop :=
  ∀ p, s.restored p

def internallyRepairable {Person : Type} (s : MoralPopulation Person) : Prop :=
  ∀ victim, ∃ agent, s.repairs agent victim

/-! Universal victim/offender status alone does not make restoration
logically impossible.  This countermodel deliberately leaves repair capacity
unconstrained. -/

def entangledYetRestored : MoralPopulation Unit where
  offender := fun _ => True
  victim := fun _ => True
  restored := fun _ => True
  repairs := fun _ _ => True

theorem universal_entanglement_alone_allows_global_restoration :
    universallyEntangled entangledYetRestored ∧
    globallyRestored entangledYetRestored ∧
    internallyRepairable entangledYetRestored := by
  constructor
  · intro p
    exact ⟨True.intro, True.intro⟩
  constructor
  · intro p
    exact True.intro
  · intro victim
    exact ⟨(), True.intro⟩

/-! Blocking only self-repair is also insufficient: two entangled persons can
repair one another unless another constraint prevents it. -/

def crossRepairPopulation : MoralPopulation Bool where
  offender := fun _ => True
  victim := fun _ => True
  restored := fun _ => True
  repairs := fun agent victim => agent ≠ victim

theorem no_self_repair_but_cross_repair_remains :
    (∀ p, crossRepairPopulation.offender p →
      ¬ crossRepairPopulation.repairs p p) ∧
    internallyRepairable crossRepairPopulation := by
  constructor
  · intro p hp hRepair
    exact hRepair rfl
  · intro victim
    cases victim with
    | false => exact ⟨true, by simp [crossRepairPopulation]⟩
    | true => exact ⟨false, by simp [crossRepairPopulation]⟩

/-! ## When an external restorer actually follows -/

structure OpenMoralSystem (Agent : Type) where
  internal : Agent → Prop
  offender : Agent → Prop
  victim : Agent → Prop
  repairs : Agent → Agent → Prop

def everyInternalPersonEntangled {Agent : Type}
    (s : OpenMoralSystem Agent) : Prop :=
  ∀ p, s.internal p → s.offender p ∧ s.victim p

/-- This is the load-bearing qualification bridge: an effective repairing
agent must not itself be an offender. -/
def repairRequiresNonoffender {Agent : Type}
    (s : OpenMoralSystem Agent) : Prop :=
  ∀ agent victim, s.repairs agent victim → ¬ s.offender agent

/-- If every internal person is an offender and repair requires a nonoffender,
then any actual repairing agent must be outside the internal population. -/
theorem qualified_restorer_must_be_external
    {Agent : Type} (s : OpenMoralSystem Agent)
    (hEntangled : everyInternalPersonEntangled s)
    (hQualified : repairRequiresNonoffender s)
    (agent victim : Agent)
    (hRepairs : s.repairs agent victim) :
    ¬ s.internal agent := by
  intro hAgentInternal
  have hAgentOffender : s.offender agent :=
    (hEntangled agent hAgentInternal).1
  exact (hQualified agent victim hRepairs) hAgentOffender

/-- Externality still does not identify the restorer as God. -/
structure RestorerDescription where
  externalToPopulation : Bool
  divine : Bool
  deathOccurred : Bool
deriving DecidableEq, Repr

def externalButNotIdentified : RestorerDescription where
  externalToPopulation := true
  divine := false
  deathOccurred := false

theorem external_restorer_does_not_yet_identify_God_or_death :
    externalButNotIdentified.externalToPopulation = true ∧
    externalButNotIdentified.divine = false ∧
    externalButNotIdentified.deathOccurred = false := by
  exact ⟨rfl, rfl, rfl⟩

/-! ## Dynamic correction: offenders may change

The preceding external-restorer theorem uses offender status at the time of
repair as though it were static.  A temporal model must distinguish initial
culpability from later qualification.
-/

structure DynamicMoralSystem (Agent : Type) where
  internal : Agent → Prop
  initiallyOffender : Agent → Prop
  laterOffender : Agent → Prop
  laterRepairs : Agent → Agent → Prop

def everyInternalInitiallyOffends {Agent : Type}
    (s : DynamicMoralSystem Agent) : Prop :=
  ∀ p, s.internal p → s.initiallyOffender p

def laterRepairRequiresCurrentNonoffender {Agent : Type}
    (s : DynamicMoralSystem Agent) : Prop :=
  ∀ agent victim, s.laterRepairs agent victim → ¬ s.laterOffender agent

/-- One internal person begins as an offender, changes, and later repairs.
This is a countermodel to any inference from initial universal offending to a
necessarily external later restorer. -/
def changedInternalSystem : DynamicMoralSystem Unit where
  internal := fun _ => True
  initiallyOffender := fun _ => True
  laterOffender := fun _ => False
  laterRepairs := fun _ _ => True

theorem genuine_change_allows_an_internal_qualified_restorer :
    everyInternalInitiallyOffends changedInternalSystem ∧
    laterRepairRequiresCurrentNonoffender changedInternalSystem ∧
    ∃ agent victim,
      changedInternalSystem.internal agent ∧
      changedInternalSystem.laterRepairs agent victim := by
  constructor
  · intro p hp
    exact True.intro
  constructor
  · intro agent victim hRepair hLaterOffender
    exact hLaterOffender
  · exact ⟨(), (), True.intro, True.intro⟩

/-- The dynamic countermodel does not explain the source or mechanism of the
change.  It records that this is now the unresolved load-bearing question. -/
structure ChangeAccount where
  changeOccurred : Bool
  selfCaused : Bool
  causedByAnotherInternal : Bool
  causedExternally : Bool
deriving DecidableEq, Repr

def changeWithUnresolvedSource : ChangeAccount where
  changeOccurred := true
  selfCaused := false
  causedByAnotherInternal := false
  causedExternally := false

theorem occurrence_of_change_does_not_identify_its_source :
    changeWithUnresolvedSource.changeOccurred = true ∧
    changeWithUnresolvedSource.selfCaused = false ∧
    changeWithUnresolvedSource.causedByAnotherInternal = false ∧
    changeWithUnresolvedSource.causedExternally = false := by
  exact ⟨rfl, rfl, rfl, rfl⟩

#print axioms universal_entanglement_alone_allows_global_restoration
#print axioms no_self_repair_but_cross_repair_remains
#print axioms qualified_restorer_must_be_external
#print axioms external_restorer_does_not_yet_identify_God_or_death
#print axioms genuine_change_allows_an_internal_qualified_restorer
#print axioms occurrence_of_change_does_not_identify_its_source

end Theophysics.PopulationRestoration

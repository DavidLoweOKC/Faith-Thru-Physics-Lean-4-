import Theophysics_Coherence

/-!
# Premise ablation for restoration and payment

This file weakens the existing restoration model one gate at a time.  Each
counterexample identifies what becomes possible after that gate is removed.
It does not identify any abstract cost with death, the Cross, or atonement.
-/

namespace Theophysics.PremiseAblation

open Theophysics.Coherence

/-- Restoration with the paid-cost gate removed. -/
def canRestoreWithoutPaidCost (m : RestorationModel) : Bool :=
  (m.boundary == SystemBoundary.open) &&
  m.externalInput &&
  m.informationPreserved

/-- Once the paid-cost gate is removed, an unpaid model passes. -/
theorem unpaid_restoration_is_admitted_after_cost_ablation :
    canRestoreWithoutPaidCost
      { boundary := SystemBoundary.open
        externalInput := true
        repairCostPaid := false
        informationPreserved := true } = true := by
  rfl

/-- Restoration with the external-input gate removed. -/
def canRestoreWithoutExternalInput (m : RestorationModel) : Bool :=
  (m.boundary == SystemBoundary.open) &&
  m.repairCostPaid &&
  m.informationPreserved

theorem input_free_restoration_is_admitted_after_input_ablation :
    canRestoreWithoutExternalInput
      { boundary := SystemBoundary.open
        externalInput := false
        repairCostPaid := true
        informationPreserved := true } = true := by
  rfl

/-- Restoration with the information-preservation gate removed. -/
def canRestoreWithoutInformationPreservation (m : RestorationModel) : Bool :=
  (m.boundary == SystemBoundary.open) &&
  m.externalInput &&
  m.repairCostPaid

theorem identity_free_restoration_is_admitted_after_information_ablation :
    canRestoreWithoutInformationPreservation
      { boundary := SystemBoundary.open
        externalInput := true
        repairCostPaid := true
        informationPreserved := false } = true := by
  rfl

/-- Restoration with the open-boundary gate removed. -/
def canRestoreWithoutOpenBoundary (m : RestorationModel) : Bool :=
  m.externalInput && m.repairCostPaid && m.informationPreserved

theorem closed_restoration_is_admitted_after_boundary_ablation :
    canRestoreWithoutOpenBoundary
      { boundary := SystemBoundary.closed
        externalInput := true
        repairCostPaid := true
        informationPreserved := true } = true := by
  rfl

/-- Payment and death are kept as distinct propositions so their logical
relationship can be tested instead of assumed. -/
structure PaymentOutcome where
  costPaid : Bool
  deathOccurred : Bool
deriving DecidableEq, Repr

/-- A paid-cost state with no death is a countermodel to the claim that
payment alone entails death. -/
def paidWithoutDeath : PaymentOutcome where
  costPaid := true
  deathOccurred := false

theorem paid_cost_does_not_force_death :
    paidWithoutDeath.costPaid = true ∧
    paidWithoutDeath.deathOccurred = false := by
  exact ⟨rfl, rfl⟩

/-- Conversely, recording a death does not by itself establish payment. -/
def deathWithoutPayment : PaymentOutcome where
  costPaid := false
  deathOccurred := true

theorem death_does_not_establish_paid_cost :
    deathWithoutPayment.deathOccurred = true ∧
    deathWithoutPayment.costPaid = false := by
  exact ⟨rfl, rfl⟩

/-! ## Ablating the no-waiver premise -/

/-- A deliberately weaker settlement rule: a liability is settled when it is
either paid or waived.  This removes the earlier requirement that justice
reject a merely waived debt. -/
structure WaiverModel where
  debtPaid : Bool
  debtWaived : Bool
deriving DecidableEq, Repr

def settledAllowingWaiver (m : WaiverModel) : Bool :=
  m.debtPaid || m.debtWaived

/-- After the no-waiver premise is removed, settlement with no payment is
admitted by the weakened rule. -/
theorem waiver_alone_can_settle_after_no_waiver_ablation :
    settledAllowingWaiver { debtPaid := false, debtWaived := true } = true := by
  rfl

/-- In that weakened model there need be neither payment nor death. -/
theorem waiver_model_requires_neither_payment_nor_death :
    ∃ settlement : WaiverModel, ∃ outcome : PaymentOutcome,
      settledAllowingWaiver settlement = true ∧
      settlement.debtPaid = false ∧
      outcome.deathOccurred = false := by
  exact ⟨{ debtPaid := false, debtWaived := true }, paidWithoutDeath,
    rfl, rfl, rfl⟩

/-! ## Epistemic preload without a no-waiver rule

The fields below express the surrounding picture without defining any hidden
relationship among them.  In particular, `truthAcknowledged`, `harmIsReal`,
`obligationIsReal`, and `restorationOccurs` do not definitionally contain a
payment rule.
-/

structure EpistemicSettlement where
  truthAcknowledged : Bool
  harmIsReal : Bool
  obligationIsReal : Bool
  restorationOccurs : Bool
  debtWaived : Bool
  debtPaid : Bool
  deathOccurred : Bool
deriving DecidableEq, Repr

def surroundingMindset (m : EpistemicSettlement) : Bool :=
  m.truthAcknowledged &&
  m.harmIsReal &&
  m.obligationIsReal &&
  m.restorationOccurs

/-- Even the full surrounding mindset admits waiver, restoration, no payment,
and no death when no rule connecting those facts has been supplied. -/
def epistemicallyLoadedWaiver : EpistemicSettlement where
  truthAcknowledged := true
  harmIsReal := true
  obligationIsReal := true
  restorationOccurs := true
  debtWaived := true
  debtPaid := false
  deathOccurred := false

theorem epistemic_mindset_alone_does_not_force_payment_or_death :
    surroundingMindset epistemicallyLoadedWaiver = true ∧
    epistemicallyLoadedWaiver.debtWaived = true ∧
    epistemicallyLoadedWaiver.debtPaid = false ∧
    epistemicallyLoadedWaiver.deathOccurred = false := by
  exact ⟨rfl, rfl, rfl, rfl⟩

/-! ## Truthful-accounting pressure test -/

structure ObligationLedger where
  obligationReal : Bool
  debtPaid : Bool
  debtWaived : Bool
  obligationOutstanding : Bool
  restorationComplete : Bool
  deathOccurred : Bool
deriving DecidableEq, Repr

/-- Broad accounting treats payment, waiver, and continued liability as three
openly declared ways of accounting for an obligation. -/
def broadlyAccounted (m : ObligationLedger) : Bool :=
  m.debtPaid || m.debtWaived || m.obligationOutstanding

def broadWaiverLedger : ObligationLedger where
  obligationReal := true
  debtPaid := false
  debtWaived := true
  obligationOutstanding := false
  restorationComplete := true
  deathOccurred := false

/-- If waiver counts as an honest accounting channel, truthful accounting and
completed restoration still do not force payment or death. -/
theorem broad_accounting_still_admits_costless_waiver :
    broadWaiverLedger.obligationReal = true ∧
    broadlyAccounted broadWaiverLedger = true ∧
    broadWaiverLedger.restorationComplete = true ∧
    broadWaiverLedger.debtPaid = false ∧
    broadWaiverLedger.deathOccurred = false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- Conservation accounting deliberately recognizes only two destinations for
a real obligation: discharged by payment or remaining outstanding. -/
def conservativelyAccounted (m : ObligationLedger) : Bool :=
  m.debtPaid || m.obligationOutstanding

/-- Under conservation accounting, if the obligation is accounted for and no
longer outstanding, payment follows.  Notice that this conclusion is carried
by the definition that omits waiver as a discharge channel. -/
theorem payment_follows_from_conservation_and_closure
    (m : ObligationLedger)
    (hAccounted : conservativelyAccounted m = true)
    (hClosed : m.obligationOutstanding = false) :
    m.debtPaid = true := by
  simp [conservativelyAccounted, hClosed] at hAccounted
  exact hAccounted

/-- Even after payment is derived, death remains independent. -/
def paidClosedWithoutDeath : ObligationLedger where
  obligationReal := true
  debtPaid := true
  debtWaived := false
  obligationOutstanding := false
  restorationComplete := true
  deathOccurred := false

theorem conservation_payment_still_does_not_force_death :
    conservativelyAccounted paidClosedWithoutDeath = true ∧
    paidClosedWithoutDeath.obligationOutstanding = false ∧
    paidClosedWithoutDeath.deathOccurred = false := by
  exact ⟨rfl, rfl, rfl⟩

/-! ## From wrongful harm to moral debt

The event itself contains no `debt` field.  Culpability, restorative duty, and
outstanding debt are introduced in separate stages so that every bridge stays
visible.
-/

structure MoralEvent where
  agentActed : Bool
  normKnown : Bool
  actionFree : Bool
  actionWrongful : Bool
  harmReal : Bool
deriving DecidableEq, Repr

def culpableWrongdoing (e : MoralEvent) : Bool :=
  e.agentActed && e.normKnown && e.actionFree && e.actionWrongful && e.harmReal

def deliberateWrongfulHarm : MoralEvent where
  agentActed := true
  normKnown := true
  actionFree := true
  actionWrongful := true
  harmReal := true

theorem deliberate_wrongful_harm_is_culpable :
    culpableWrongdoing deliberateWrongfulHarm = true := by
  rfl

/-- A normative assessment is separate from the event description. -/
structure NormativeAssessment where
  dutyToRestore : Bool
  restorationComplete : Bool
  punishmentDeserved : Bool
  costPaid : Bool
  deathRequired : Bool
deriving DecidableEq, Repr

/-- Restorative moral debt means an acknowledged duty remains unfulfilled. -/
def restorativeDebtOutstanding (a : NormativeAssessment) : Bool :=
  a.dutyToRestore && !a.restorationComplete

/-- This is the explicit normative bridge.  It is not derivable from the event
record alone; it states that culpable wrongful harm creates a duty to restore. -/
def culpabilityCreatesRestorativeDuty
    (e : MoralEvent) (a : NormativeAssessment) : Prop :=
  culpableWrongdoing e = true → a.dutyToRestore = true

theorem restorative_debt_follows_from_visible_bridge_and_nonrestoration
    (e : MoralEvent) (a : NormativeAssessment)
    (hBridge : culpabilityCreatesRestorativeDuty e a)
    (hCulpable : culpableWrongdoing e = true)
    (hNotRestored : a.restorationComplete = false) :
    restorativeDebtOutstanding a = true := by
  have hDuty : a.dutyToRestore = true := hBridge hCulpable
  simp [restorativeDebtOutstanding, hDuty, hNotRestored]

/-- Culpability alone cannot produce a duty without the normative bridge. -/
def culpableButNoAssignedDuty : NormativeAssessment where
  dutyToRestore := false
  restorationComplete := false
  punishmentDeserved := false
  costPaid := false
  deathRequired := false

theorem event_facts_alone_admit_no_assigned_duty :
    culpableWrongdoing deliberateWrongfulHarm = true ∧
    culpableButNoAssignedDuty.dutyToRestore = false := by
  exact ⟨rfl, rfl⟩

/-- Once restoration is complete, restorative debt is no longer outstanding;
this says nothing yet about how restoration was achieved. -/
theorem completed_restoration_clears_restorative_debt
    (a : NormativeAssessment) (hComplete : a.restorationComplete = true) :
    restorativeDebtOutstanding a = false := by
  simp [restorativeDebtOutstanding, hComplete]

/-- Restorative debt does not entail punitive desert, paid cost, or death. -/
def restorativeDebtWithoutPunitiveConsequences : NormativeAssessment where
  dutyToRestore := true
  restorationComplete := false
  punishmentDeserved := false
  costPaid := false
  deathRequired := false

theorem restorative_debt_alone_does_not_force_punishment_payment_or_death :
    restorativeDebtOutstanding restorativeDebtWithoutPunitiveConsequences = true ∧
    restorativeDebtWithoutPunitiveConsequences.punishmentDeserved = false ∧
    restorativeDebtWithoutPunitiveConsequences.costPaid = false ∧
    restorativeDebtWithoutPunitiveConsequences.deathRequired = false := by
  exact ⟨rfl, rfl, rfl, rfl⟩

-- This implication is intentionally rejected: the surrounding mindset alone
-- does not contain enough information to derive payment.
#check_failure (
  show ∀ m : EpistemicSettlement,
    surroundingMindset m = true → m.debtPaid = true
  from by
    intro m h
    simp [surroundingMindset] at h
)

-- Nor does the surrounding mindset alone derive death.
#check_failure (
  show ∀ m : EpistemicSettlement,
    surroundingMindset m = true → m.deathOccurred = true
  from by
    intro m h
    simp [surroundingMindset] at h
)

#print axioms unpaid_restoration_is_admitted_after_cost_ablation
#print axioms paid_cost_does_not_force_death
#print axioms death_does_not_establish_paid_cost
#print axioms waiver_alone_can_settle_after_no_waiver_ablation
#print axioms waiver_model_requires_neither_payment_nor_death
#print axioms epistemic_mindset_alone_does_not_force_payment_or_death
#print axioms broad_accounting_still_admits_costless_waiver
#print axioms payment_follows_from_conservation_and_closure
#print axioms conservation_payment_still_does_not_force_death
#print axioms restorative_debt_follows_from_visible_bridge_and_nonrestoration
#print axioms event_facts_alone_admit_no_assigned_duty
#print axioms completed_restoration_clears_restorative_debt
#print axioms restorative_debt_alone_does_not_force_punishment_payment_or_death

end Theophysics.PremiseAblation

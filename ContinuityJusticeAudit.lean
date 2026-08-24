import Std

/-!
# Justice, agency, identity, and solidarity audit

This kernel asks whether sovereign authority can satisfy the non-solidarity
safeguards of global restoration, and whether representative participation
adds a separately necessary condition.
-/

namespace Theophysics.ContinuityJusticeAudit

structure Safeguards where
  truthHonored : Bool
  victimRestored : Bool
  justicePreserved : Bool
  offenderTransformed : Bool
  consentPreserved : Bool
  personalIdentityPreserved : Bool
  relationshipReconciled : Bool
  sharedConditionSolidarity : Bool
deriving DecidableEq, Repr

/-- Fixed adequacy test without assuming that the restorer must personally
share the damaged population's condition. -/
def adequateWithoutSolidarity (s : Safeguards) : Bool :=
  s.truthHonored && s.victimRestored && s.justicePreserved &&
  s.offenderTransformed && s.consentPreserved &&
  s.personalIdentityPreserved && s.relationshipReconciled

/-- Stronger adequacy test in which shared-condition solidarity is declared
load-bearing. -/
def adequateWithSolidarity (s : Safeguards) : Bool :=
  adequateWithoutSolidarity s && s.sharedConditionSolidarity

/-- Authority-only countermodel: every non-solidarity safeguard is satisfied
without claiming that the restorer shares the population's condition. -/
def authorityOnlySafeguards : Safeguards where
  truthHonored := true
  victimRestored := true
  justicePreserved := true
  offenderTransformed := true
  consentPreserved := true
  personalIdentityPreserved := true
  relationshipReconciled := true
  sharedConditionSolidarity := false

/-- Participation model satisfies the same safeguards plus solidarity. -/
def participationSafeguards : Safeguards where
  truthHonored := true
  victimRestored := true
  justicePreserved := true
  offenderTransformed := true
  consentPreserved := true
  personalIdentityPreserved := true
  relationshipReconciled := true
  sharedConditionSolidarity := true

theorem authority_alone_can_satisfy_every_nonsolidarity_safeguard :
    adequateWithoutSolidarity authorityOnlySafeguards = true := by
  rfl

theorem participation_satisfies_the_same_nonsolidarity_safeguards :
    adequateWithoutSolidarity participationSafeguards = true := by
  rfl

theorem shared_safeguards_do_not_select_between_mechanisms :
    adequateWithoutSolidarity authorityOnlySafeguards = true ∧
    adequateWithoutSolidarity participationSafeguards = true := by
  exact ⟨rfl, rfl⟩

theorem solidarity_requirement_selects_participation :
    adequateWithSolidarity authorityOnlySafeguards = false ∧
    adequateWithSolidarity participationSafeguards = true := by
  exact ⟨rfl, rfl⟩

/-! ## Does solidarity require death? -/

structure ParticipationPath where
  populationConditionIsDeath : Bool
  restorerSharesPopulationCondition : Bool
  restorerEntersDeath : Bool
deriving DecidableEq, Repr

/-- Visible same-condition bridge. -/
def sameConditionParticipation (p : ParticipationPath) : Prop :=
  p.populationConditionIsDeath = true →
  p.restorerSharesPopulationCondition = true →
  p.restorerEntersDeath = true

theorem death_follows_from_death_condition_solidarity_bridge
    (p : ParticipationPath)
    (hDeathCondition : p.populationConditionIsDeath = true)
    (hShares : p.restorerSharesPopulationCondition = true)
    (hBridge : sameConditionParticipation p) :
    p.restorerEntersDeath = true := by
  exact hBridge hDeathCondition hShares

/-- Solidarity stated only as concern or identification does not entail bodily
entry into death without the stronger same-condition bridge. -/
def solidarityWithoutDeathEntry : ParticipationPath where
  populationConditionIsDeath := true
  restorerSharesPopulationCondition := true
  restorerEntersDeath := false

theorem solidarity_label_alone_does_not_force_death_entry :
    solidarityWithoutDeathEntry.populationConditionIsDeath = true ∧
    solidarityWithoutDeathEntry.restorerSharesPopulationCondition = true ∧
    solidarityWithoutDeathEntry.restorerEntersDeath = false := by
  exact ⟨rfl, rfl, rfl⟩

#print axioms authority_alone_can_satisfy_every_nonsolidarity_safeguard
#print axioms participation_satisfies_the_same_nonsolidarity_safeguards
#print axioms shared_safeguards_do_not_select_between_mechanisms
#print axioms solidarity_requirement_selects_participation
#print axioms death_follows_from_death_condition_solidarity_bridge
#print axioms solidarity_label_alone_does_not_force_death_entry

end Theophysics.ContinuityJusticeAudit

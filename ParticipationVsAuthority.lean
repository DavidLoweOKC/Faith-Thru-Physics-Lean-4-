import Std

/-!
# Participation versus authority over death

This kernel compares two rival mechanisms under fixed outcome criteria:

1. sovereign authority restores the dead without the restorer entering death;
2. a representative shares the population's condition, enters death, emerges,
   and carries those united to the representative through the transition.

Lean tests their logical structure.  It does not decide which mechanism is
historically or metaphysically true.
-/

namespace Theophysics.ParticipationVsAuthority

structure ObservableOutcome where
  livingRestored : Bool
  deadRestored : Bool
  identityPreserved : Bool
  deathNoLongerFinal : Bool
deriving DecidableEq, Repr

def globallySuccessful (o : ObservableOutcome) : Bool :=
  o.livingRestored && o.deadRestored &&
  o.identityPreserved && o.deathNoLongerFinal

structure Mechanism where
  hasAuthorityOverDeath : Bool
  sharesPopulationNature : Bool
  personallyEntersDeath : Bool
  personallyEmergesLiving : Bool
  populationUnitedToRestorer : Bool
deriving DecidableEq, Repr

/-- Authority-only mechanism: restoration is effected by sovereign power. -/
def authorityOnlyMechanism : Mechanism where
  hasAuthorityOverDeath := true
  sharesPopulationNature := false
  personallyEntersDeath := false
  personallyEmergesLiving := false
  populationUnitedToRestorer := false

/-- Participation mechanism: the representative shares the condition and
passes through death into life with the represented population united to it. -/
def participationMechanism : Mechanism where
  hasAuthorityOverDeath := true
  sharesPopulationNature := true
  personallyEntersDeath := true
  personallyEmergesLiving := true
  populationUnitedToRestorer := true

/-- The shared observable target is held constant. -/
def restoredWorld : ObservableOutcome where
  livingRestored := true
  deadRestored := true
  identityPreserved := true
  deathNoLongerFinal := true

theorem shared_outcome_criteria_do_not_select_a_mechanism :
    globallySuccessful restoredWorld = true ∧
    authorityOnlyMechanism.personallyEntersDeath = false ∧
    participationMechanism.personallyEntersDeath = true := by
  exact ⟨rfl, rfl, rfl⟩

/-- Minimal authority sufficiency claim.  Notice that it contains no
participation requirement. -/
def authoritySufficient (m : Mechanism) : Bool :=
  m.hasAuthorityOverDeath

theorem authority_model_can_claim_sufficiency_without_death :
    authoritySufficient authorityOnlyMechanism = true ∧
    authorityOnlyMechanism.personallyEntersDeath = false := by
  exact ⟨rfl, rfl⟩

/-- Visible representative-participation criterion. -/
def representativeContinuity (m : Mechanism) : Bool :=
  m.sharesPopulationNature &&
  m.personallyEntersDeath &&
  m.personallyEmergesLiving &&
  m.populationUnitedToRestorer

theorem participation_model_satisfies_representative_continuity :
    representativeContinuity participationMechanism = true := by
  rfl

theorem authority_only_model_fails_representative_continuity :
    representativeContinuity authorityOnlyMechanism = false := by
  rfl

theorem representative_continuity_requires_entry_into_death
    (m : Mechanism) (h : representativeContinuity m = true) :
    m.personallyEntersDeath = true := by
  cases m with
  | mk authority nature enters emerges union =>
      cases authority <;> cases nature <;> cases enters <;>
        cases emerges <;> cases union <;>
        simp [representativeContinuity] at h ⊢

theorem representative_continuity_requires_emergence
    (m : Mechanism) (h : representativeContinuity m = true) :
    m.personallyEmergesLiving = true := by
  cases m with
  | mk authority nature enters emerges union =>
      cases authority <;> cases nature <;> cases enters <;>
        cases emerges <;> cases union <;>
        simp [representativeContinuity] at h ⊢

/-- Decisive boundary: death is necessary for the participation mechanism, not
for the shared observable outcome by itself. -/
theorem death_necessity_is_mechanism_relative :
    authoritySufficient authorityOnlyMechanism = true ∧
    authorityOnlyMechanism.personallyEntersDeath = false ∧
    representativeContinuity participationMechanism = true ∧
    participationMechanism.personallyEntersDeath = true := by
  exact ⟨rfl, rfl, rfl, rfl⟩

#print axioms shared_outcome_criteria_do_not_select_a_mechanism
#print axioms authority_model_can_claim_sufficiency_without_death
#print axioms participation_model_satisfies_representative_continuity
#print axioms authority_only_model_fails_representative_continuity
#print axioms representative_continuity_requires_entry_into_death
#print axioms representative_continuity_requires_emergence
#print axioms death_necessity_is_mechanism_relative

end Theophysics.ParticipationVsAuthority

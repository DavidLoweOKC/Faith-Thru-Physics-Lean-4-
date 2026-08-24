import Std

/-!
# Death-scope audit

Global restoration includes living and dead persons.  This kernel separates
capacity to restore the dead from personal entry into death, preventing those
claims from being treated as synonyms.
-/

namespace Theophysics.DeathScopeAudit

inductive PopulationCondition where
  | living
  | dead
deriving DecidableEq, Repr

structure DeathScopeProfile where
  restores : PopulationCondition → Bool
  entersDeath : Bool
  emergesLiving : Bool

def reachesWholePopulation (c : DeathScopeProfile) : Bool :=
  c.restores PopulationCondition.living &&
  c.restores PopulationCondition.dead

/-- Pure authority over both domains is logically possible without personal
entry into death unless a participation principle is added. -/
def authorityWithoutEntry : DeathScopeProfile where
  restores := fun _ => true
  entersDeath := false
  emergesLiving := true

theorem global_reach_alone_does_not_require_entering_death :
    reachesWholePopulation authorityWithoutEntry = true ∧
    authorityWithoutEntry.entersDeath = false := by
  exact ⟨rfl, rfl⟩

/-- Reaching the dead and overcoming death are also distinct in the sparse
model; restoration authority alone does not encode a personal victory event. -/
def authorityWithoutPersonalVictory : DeathScopeProfile where
  restores := fun _ => true
  entersDeath := false
  emergesLiving := false

theorem global_reach_alone_does_not_require_personal_emergence :
    reachesWholePopulation authorityWithoutPersonalVictory = true ∧
    authorityWithoutPersonalVictory.emergesLiving = false := by
  exact ⟨rfl, rfl⟩

/-- The visible participation bridge: restoring persons in death requires the
restorer personally to enter death. -/
def deadRestorationRequiresParticipation (c : DeathScopeProfile) : Prop :=
  c.restores PopulationCondition.dead = true → c.entersDeath = true

theorem entry_into_death_follows_only_with_participation_bridge
    (c : DeathScopeProfile)
    (hWhole : reachesWholePopulation c = true)
    (hParticipation : deadRestorationRequiresParticipation c) :
    c.entersDeath = true := by
  have hDead : c.restores PopulationCondition.dead = true := by
    simp [reachesWholePopulation] at hWhole
    exact hWhole.2
  exact hParticipation hDead

/-- A second visible bridge is needed to move from entry into death to personal
emergence from it. -/
def deathEntryForGlobalRestorationRequiresEmergence
    (c : DeathScopeProfile) : Prop :=
  c.entersDeath = true → reachesWholePopulation c = true →
    c.emergesLiving = true

theorem emergence_follows_with_second_visible_bridge
    (c : DeathScopeProfile)
    (hWhole : reachesWholePopulation c = true)
    (hEntry : c.entersDeath = true)
    (hEmergence : deathEntryForGlobalRestorationRequiresEmergence c) :
    c.emergesLiving = true := by
  exact hEmergence hEntry hWhole

/-- The blinded death-and-emergence profile fits both bridges, but Lean does
not establish that a historical person instantiates it. -/
def CandidateXDeathProfile : DeathScopeProfile where
  restores := fun _ => true
  entersDeath := true
  emergesLiving := true

theorem candidateX_fits_death_scope :
    reachesWholePopulation CandidateXDeathProfile = true ∧
    CandidateXDeathProfile.entersDeath = true ∧
    CandidateXDeathProfile.emergesLiving = true := by
  exact ⟨rfl, rfl, rfl⟩

#print axioms global_reach_alone_does_not_require_entering_death
#print axioms global_reach_alone_does_not_require_personal_emergence
#print axioms entry_into_death_follows_only_with_participation_bridge
#print axioms emergence_follows_with_second_visible_bridge
#print axioms candidateX_fits_death_scope

end Theophysics.DeathScopeAudit

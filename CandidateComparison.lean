import Std

/-!
# Fixed-criteria candidate comparison

The evaluator is fixed before any candidate is tested.  Candidate profiles are
inputs, not historical proofs.  `CandidateX` is intentionally blinded.

Passing this kernel means only that the supplied profile satisfies the encoded
structural criteria.  It does not prove that any historical person possesses
the profile.
-/

namespace Theophysics.CandidateComparison

structure CandidateProfile where
  belongsToPopulation : Bool
  freeOfUnresolvedCulpability : Bool
  authorized : Bool
  representsWholePopulation : Bool
  restorativeCapacityIsGlobal : Bool
  actsVoluntarily : Bool
  entersDeath : Bool
  overcomesDeath : Bool
deriving DecidableEq, Repr

/-- Fixed global criteria that do not mention death. -/
def meetsBaseGlobalCriteria (c : CandidateProfile) : Bool :=
  c.belongsToPopulation &&
  c.freeOfUnresolvedCulpability &&
  c.authorized &&
  c.representsWholePopulation &&
  c.restorativeCapacityIsGlobal &&
  c.actsVoluntarily

/-- A separate stronger criterion for a population whose restoration is
claimed to require entering and overcoming death.  This requirement is kept
visible rather than hidden inside the base evaluator. -/
def meetsDeathConfrontingCriteria (c : CandidateProfile) : Bool :=
  meetsBaseGlobalCriteria c && c.entersDeath && c.overcomesDeath

/-! ## Local candidate classes -/

def selfRepairCandidate : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := false
  authorized := false
  representsWholePopulation := false
  restorativeCapacityIsGlobal := false
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

def mutualHelpCandidate : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := false
  authorized := false
  representsWholePopulation := false
  restorativeCapacityIsGlobal := false
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

def communityCascadeCandidate : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := false
  authorized := false
  representsWholePopulation := false
  restorativeCapacityIsGlobal := true
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

def transformedFormerOffenderCandidate : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := false
  authorized := false
  representsWholePopulation := false
  restorativeCapacityIsGlobal := false
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

def ordinaryInnocentThirdPartyCandidate : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := true
  authorized := false
  representsWholePopulation := false
  restorativeCapacityIsGlobal := false
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

theorem tested_local_candidates_fail_fixed_base_criteria :
    meetsBaseGlobalCriteria selfRepairCandidate = false ∧
    meetsBaseGlobalCriteria mutualHelpCandidate = false ∧
    meetsBaseGlobalCriteria communityCascadeCandidate = false ∧
    meetsBaseGlobalCriteria transformedFormerOffenderCandidate = false ∧
    meetsBaseGlobalCriteria ordinaryInnocentThirdPartyCandidate = false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

/-! ## Blinded candidate -/

/-- This profile records the properties to be tested.  Lean does not establish
that a historical person has them. -/
def CandidateX : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := true
  authorized := true
  representsWholePopulation := true
  restorativeCapacityIsGlobal := true
  actsVoluntarily := true
  entersDeath := true
  overcomesDeath := true

theorem candidateX_meets_unchanged_base_criteria :
    meetsBaseGlobalCriteria CandidateX = true := by
  rfl

theorem candidateX_meets_visible_death_confronting_criteria :
    meetsDeathConfrontingCriteria CandidateX = true := by
  rfl

/-! ## Anti-smuggling controls -/

/-- The base global criteria do not force death.  A hypothetical profile with
all base qualifications but no death still passes the base evaluator. -/
def baseQualifiedWithoutDeath : CandidateProfile where
  belongsToPopulation := true
  freeOfUnresolvedCulpability := true
  authorized := true
  representsWholePopulation := true
  restorativeCapacityIsGlobal := true
  actsVoluntarily := true
  entersDeath := false
  overcomesDeath := false

theorem base_global_success_does_not_entail_death :
    meetsBaseGlobalCriteria baseQualifiedWithoutDeath = true ∧
    baseQualifiedWithoutDeath.entersDeath = false ∧
    baseQualifiedWithoutDeath.overcomesDeath = false := by
  exact ⟨rfl, rfl, rfl⟩

/-- Being internal/local does not itself force failure.  If a local candidate
is supplied every base qualification, that candidate passes.  Therefore the
earlier local failures depend on their profile assignments, not locality alone. -/
theorem locality_alone_does_not_prevent_global_qualification :
    baseQualifiedWithoutDeath.belongsToPopulation = true ∧
    meetsBaseGlobalCriteria baseQualifiedWithoutDeath = true := by
  exact ⟨rfl, rfl⟩

/-- A second blinded label can carry the same structural profile.  The
evaluator classifies profiles; it does not identify a unique historical person. -/
inductive BlindedIdentity where
  | candidateX
  | candidateY
deriving DecidableEq, Repr

def profileOf : BlindedIdentity → CandidateProfile
  | BlindedIdentity.candidateX => CandidateX
  | BlindedIdentity.candidateY => CandidateX

theorem structural_fit_does_not_uniquely_identify_candidateX :
    meetsBaseGlobalCriteria (profileOf BlindedIdentity.candidateX) = true ∧
    meetsBaseGlobalCriteria (profileOf BlindedIdentity.candidateY) = true ∧
    BlindedIdentity.candidateX ≠ BlindedIdentity.candidateY := by
  exact ⟨rfl, rfl, by decide⟩

theorem death_confronting_success_requires_entering_death
    (c : CandidateProfile)
    (h : meetsDeathConfrontingCriteria c = true) :
    c.entersDeath = true := by
  cases c with
  | mk population unencumbered authority representation capacity voluntary enters overcomes =>
      cases population <;> cases unencumbered <;> cases authority <;>
        cases representation <;> cases capacity <;> cases voluntary <;>
        cases enters <;> cases overcomes <;>
        simp [meetsDeathConfrontingCriteria, meetsBaseGlobalCriteria] at h ⊢

theorem death_confronting_success_requires_overcoming_death
    (c : CandidateProfile)
    (h : meetsDeathConfrontingCriteria c = true) :
    c.overcomesDeath = true := by
  cases c with
  | mk population unencumbered authority representation capacity voluntary enters overcomes =>
      cases population <;> cases unencumbered <;> cases authority <;>
        cases representation <;> cases capacity <;> cases voluntary <;>
        cases enters <;> cases overcomes <;>
        simp [meetsDeathConfrontingCriteria, meetsBaseGlobalCriteria] at h ⊢

#print axioms tested_local_candidates_fail_fixed_base_criteria
#print axioms candidateX_meets_unchanged_base_criteria
#print axioms candidateX_meets_visible_death_confronting_criteria
#print axioms base_global_success_does_not_entail_death
#print axioms locality_alone_does_not_prevent_global_qualification
#print axioms structural_fit_does_not_uniquely_identify_candidateX
#print axioms death_confronting_success_requires_entering_death
#print axioms death_confronting_success_requires_overcoming_death

end Theophysics.CandidateComparison

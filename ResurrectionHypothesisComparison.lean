import Std

/-!
# Resurrection hypothesis comparison

Coverage values are historical judgments supplied to Lean.  Lean checks the
comparison but does not establish those judgments or assign prior probability
to miracles.
-/

namespace Theophysics.ResurrectionHypothesisComparison

structure EvidenceCoverage where
  confirmedExecutionAndDeath : Bool
  earlyRaisedJesusProclamation : Bool
  namedAppearanceTradition : Bool
  appearanceDiversity : Bool
  emptyTombTradition : Bool
  rapidMovementFormation : Bool
deriving DecidableEq, Repr

def coversFixedEvidence (h : EvidenceCoverage) : Bool :=
  h.confirmedExecutionAndDeath &&
  h.earlyRaisedJesusProclamation &&
  h.namedAppearanceTradition &&
  h.appearanceDiversity &&
  h.emptyTombTradition &&
  h.rapidMovementFormation

/-- Bodily resurrection hypothesis, conditional on allowing divine action. -/
def bodilyResurrection : EvidenceCoverage where
  confirmedExecutionAndDeath := true
  earlyRaisedJesusProclamation := true
  namedAppearanceTradition := true
  appearanceDiversity := true
  emptyTombTradition := true
  rapidMovementFormation := true

/-- Vision/bereavement experience explains proclamation and appearances but
does not by itself explain an empty tomb. -/
def visionsOnly : EvidenceCoverage where
  confirmedExecutionAndDeath := true
  earlyRaisedJesusProclamation := true
  namedAppearanceTradition := true
  appearanceDiversity := true
  emptyTombTradition := false
  rapidMovementFormation := true

/-- Body relocation explains an empty tomb but not appearance experiences or
their interpretation by itself. -/
def bodyRelocationOnly : EvidenceCoverage where
  confirmedExecutionAndDeath := true
  earlyRaisedJesusProclamation := false
  namedAppearanceTradition := false
  appearanceDiversity := false
  emptyTombTradition := true
  rapidMovementFormation := false

/-- Slow legend development is marked as failing the very-early proclamation
lane while accounting for later narrative expansion. -/
def legendOnly : EvidenceCoverage where
  confirmedExecutionAndDeath := true
  earlyRaisedJesusProclamation := false
  namedAppearanceTradition := false
  appearanceDiversity := true
  emptyTombTradition := true
  rapidMovementFormation := false

/-- Survival is incompatible with the fixed confirmed-death datum. -/
def survivalOnly : EvidenceCoverage where
  confirmedExecutionAndDeath := false
  earlyRaisedJesusProclamation := true
  namedAppearanceTradition := true
  appearanceDiversity := false
  emptyTombTradition := true
  rapidMovementFormation := true

/-- A composite natural hypothesis combines body relocation with visionary or
bereavement experiences and subsequent interpretation.  It is allowed full
coverage here so the comparison does not manufacture uniqueness by excluding
multi-factor rivals. -/
def relocationPlusVisions : EvidenceCoverage where
  confirmedExecutionAndDeath := true
  earlyRaisedJesusProclamation := true
  namedAppearanceTradition := true
  appearanceDiversity := true
  emptyTombTradition := true
  rapidMovementFormation := true

theorem simple_hypothesis_coverage :
    coversFixedEvidence bodilyResurrection = true ∧
    coversFixedEvidence visionsOnly = false ∧
    coversFixedEvidence bodyRelocationOnly = false ∧
    coversFixedEvidence legendOnly = false ∧
    coversFixedEvidence survivalOnly = false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

theorem composite_natural_hypothesis_prevents_coverage_uniqueness :
    coversFixedEvidence bodilyResurrection = true ∧
    coversFixedEvidence relocationPlusVisions = true ∧
    bodilyResurrection = relocationPlusVisions := by
  exact ⟨rfl, rfl, rfl⟩

/-- Coverage equality does not establish equal plausibility.  Complexity,
independent motivation, prior worldview commitments, and source-level details
remain outside this Boolean kernel. -/
structure ComparativeBurden where
  evidenceCoverageComplete : Bool
  requiresMultipleIndependentEvents : Bool
  requiresDivineAction : Bool
deriving DecidableEq, Repr

def resurrectionBurden : ComparativeBurden where
  evidenceCoverageComplete := true
  requiresMultipleIndependentEvents := false
  requiresDivineAction := true

def compositeNaturalBurden : ComparativeBurden where
  evidenceCoverageComplete := true
  requiresMultipleIndependentEvents := true
  requiresDivineAction := false

theorem coverage_does_not_choose_between_metaphysical_burdens :
    resurrectionBurden.evidenceCoverageComplete = true ∧
    compositeNaturalBurden.evidenceCoverageComplete = true ∧
    resurrectionBurden.requiresDivineAction = true ∧
    compositeNaturalBurden.requiresMultipleIndependentEvents = true := by
  exact ⟨rfl, rfl, rfl, rfl⟩

#print axioms simple_hypothesis_coverage
#print axioms composite_natural_hypothesis_prevents_coverage_uniqueness
#print axioms coverage_does_not_choose_between_metaphysical_burdens

end Theophysics.ResurrectionHypothesisComparison

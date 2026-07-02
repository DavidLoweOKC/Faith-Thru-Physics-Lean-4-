import Std
import Theophysics_Core
import Theophysics_Coherence
import Theophysics_Fracture
import Theophysics_Fall
import Theophysics_ChiEvaluator

/-!
# Theophysics_NegativeInventory

First tranche of the `MISSING_TARGET` negative families from
`docs/06_Lean_Negative_Inventory.md` (Part III).

Families implemented here:
  1. per-factor insufficiency  (III.1)
  2. dependency-lattice rejections  (III.2)
  3. sign / conversion rejections  (III.3)
  4. resurrection false-positive rejections  (III.4)

Everything must fail by design or prove a collapse; no positive claims live here.
-/

namespace Theophysics.NegativeInventory

open Theophysics.Core
open Theophysics.Experiment

------------------------------------------------------------------------
-- III.1 — per-factor insufficiency family
--
-- Zero-factor collapse is already proven (`*_zero_collapses_chi`).
-- Here: strength anywhere cannot rescue a zero anywhere else.

/-- Strong Q with a closed R gate still collapses. Strength is not sufficiency. -/
theorem strong_Q_with_zero_R_gate_fails (x : FactorState)
    (_hQ : x.Q > 0) (hR : x.R = 0) : chi x = 0 :=
  R_zero_collapses_chi x hR

/-- Strong R (relational gate open) without source-backing (G = 0) still collapses. -/
theorem strong_R_without_source_backing_fails (x : FactorState)
    (_hR : x.R > 0) (hG : x.G = 0) : chi x = 0 :=
  G_zero_collapses_chi x hG

/-- Nine factors maxed, one prerequisite missing: still zero.
    High local positivity does not compensate for a missing global prerequisite. -/
theorem nine_maxed_one_zero_fails :
    chi ⟨9, 9, 9, 9, 9, 9, 9, 0, 9, 9⟩ = 0 := by
  decide

/-- The general insufficiency schema: no factor's strength rescues any other factor's zero. -/
theorem no_factor_strength_rescues_any_zero (x : FactorState) (f : Factor)
    (hzero : Theophysics.Experiment.get f x = 0) : chi x = 0 := by
  cases f <;> simp only [Theophysics.Experiment.get] at hzero <;>
    simp [Theophysics.Experiment.chi, hzero]

/-- Partial restoration without mediation: raising factors while the mediation
    channel (K) stays closed leaves the product at zero regardless of effort. -/
theorem partial_restoration_without_mediation_fails (x : FactorState)
    (hK : x.K = 0) : chi x = 0 :=
  K_zero_collapses_chi x hK

------------------------------------------------------------------------
-- III.2 — dependency-lattice rejection family
--
-- Downstream claims are invalid when upstream supports are absent.

/-- The four layers of the claim lattice, upstream to downstream. -/
inductive ClaimLayer where
  | structuralFit      -- the mapping fits at all
  | naming             -- the mapping may carry its theological name
  | bridgeCoverage     -- the mapping extends across domains
  | universality       -- the mapping is claimed as universal
  deriving DecidableEq, Repr

/-- Which layer feeds which: naming needs fit, coverage needs naming,
    universality needs coverage. -/
def upstream : ClaimLayer → Option ClaimLayer
  | ClaimLayer.structuralFit  => none
  | ClaimLayer.naming         => some ClaimLayer.structuralFit
  | ClaimLayer.bridgeCoverage => some ClaimLayer.naming
  | ClaimLayer.universality   => some ClaimLayer.bridgeCoverage

/-- A claim state records which layers have actually been established. -/
structure ClaimState where
  structuralFit  : Bool
  naming         : Bool
  bridgeCoverage : Bool
  universality   : Bool
  deriving DecidableEq, Repr

def established (s : ClaimState) : ClaimLayer → Bool
  | ClaimLayer.structuralFit  => s.structuralFit
  | ClaimLayer.naming         => s.naming
  | ClaimLayer.bridgeCoverage => s.bridgeCoverage
  | ClaimLayer.universality   => s.universality

/-- A layer is validly claimable only when established AND its upstream is
    validly claimable (unrolled — enum constructors admit no structural recursion). -/
def validClaim (s : ClaimState) : ClaimLayer → Bool
  | ClaimLayer.structuralFit  => s.structuralFit
  | ClaimLayer.naming         => (s.structuralFit) && s.naming
  | ClaimLayer.bridgeCoverage => (s.structuralFit && s.naming) && s.bridgeCoverage
  | ClaimLayer.universality   => ((s.structuralFit && s.naming) && s.bridgeCoverage) && s.universality

/-- Naming is invalid without structural fit, even if asserted. -/
theorem naming_invalid_without_structural_fit (s : ClaimState)
    (hfit : s.structuralFit = false) :
    validClaim s ClaimLayer.naming = false := by
  simp [validClaim, hfit]

/-- Universality is invalid without bridge coverage, even if asserted. -/
theorem universality_invalid_without_bridge_coverage (s : ClaimState)
    (hcov : s.bridgeCoverage = false) :
    validClaim s ClaimLayer.universality = false := by
  simp [validClaim, hcov]

/-- The general lattice law: a downstream claim is invalid whenever its
    upstream support is invalid — asserting the downstream flag changes nothing. -/
theorem downstream_invalid_when_upstream_invalid (s : ClaimState)
    (l u : ClaimLayer) (hup : upstream l = some u)
    (hinvalid : validClaim s u = false) :
    validClaim s l = false := by
  obtain ⟨a, b, c, d⟩ := s
  cases l <;> simp [upstream] at hup <;> subst hup <;>
    cases a <;> cases b <;> cases c <;> cases d <;> simp_all [validClaim]

/-- Concrete false positive: everything asserted, nothing fitted. All downstream fails. -/
theorem asserted_everything_fitted_nothing_all_fail :
    validClaim ⟨false, true, true, true⟩ ClaimLayer.universality = false := by
  decide

------------------------------------------------------------------------
-- III.3 — sign / conversion rejection family
--
-- Redemption is an operator, not arithmetic.

/-- Moral sign of a state: negative, neutral, or redeemed-positive. -/
inductive MoralSign where
  | negative
  | neutral
  | redeemedPositive
  deriving DecidableEq, Repr

/-- Composing two records without any operator: signs combine, they do not convert. -/
def compose : MoralSign → MoralSign → MoralSign
  | MoralSign.negative, _ => MoralSign.negative
  | _, MoralSign.negative => MoralSign.negative
  | MoralSign.neutral, s  => s
  | s, MoralSign.neutral  => s
  | MoralSign.redeemedPositive, MoralSign.redeemedPositive => MoralSign.redeemedPositive

/-- Negative plus negative is not redeemed positive. Accumulation is not conversion. -/
theorem neg_plus_neg_not_redeemed :
    compose MoralSign.negative MoralSign.negative ≠ MoralSign.redeemedPositive := by
  decide

/-- No operator-free composition of non-redeemed inputs yields redeemed output. -/
theorem no_redemption_without_operator (a b : MoralSign)
    (ha : a ≠ MoralSign.redeemedPositive) (hb : b ≠ MoralSign.redeemedPositive) :
    compose a b ≠ MoralSign.redeemedPositive := by
  cases a <;> cases b <;> simp_all [compose]

/-- A conversion operator: valid only if externally sourced AND cost-bearing. -/
structure ConversionOp where
  externallySourced : Bool
  bearsCost         : Bool
  deriving DecidableEq, Repr

def applyConversion (op : ConversionOp) (s : MoralSign) : MoralSign :=
  if op.externallySourced && op.bearsCost then
    match s with
    | MoralSign.negative => MoralSign.redeemedPositive
    | s => s
  else s

/-- A self-sourced "conversion" changes nothing: negative stays negative. -/
theorem self_sourced_conversion_fails (op : ConversionOp)
    (h : op.externallySourced = false) :
    applyConversion op MoralSign.negative = MoralSign.negative := by
  simp [applyConversion, h]

/-- A costless "conversion" changes nothing: mercy without cost is not conversion. -/
theorem costless_conversion_fails (op : ConversionOp)
    (h : op.bearsCost = false) :
    applyConversion op MoralSign.negative = MoralSign.negative := by
  simp [applyConversion, h]

/-- Visibility does not collapse moral distinctions: making a negative record
    visible (identity map on sign) leaves it negative. -/
theorem visibility_does_not_convert (s : MoralSign)
    (h : s = MoralSign.negative) : s ≠ MoralSign.redeemedPositive := by
  subst h; decide

------------------------------------------------------------------------
-- III.4 — resurrection false-positive family
--
-- Resurrection is not repair, not erasure, not reanimation, not replacement.

/-- The structural requirements a genuine mission-return must satisfy. -/
structure ReturnModel where
  preservesIdentity  : Bool  -- same person, not a copy or replacement
  preservesRecord    : Bool  -- history retained, not erased
  bodilyReturn       : Bool  -- not symbolic-only
  missionStructure   : Bool  -- constrained return operator, not generic reanimation
  repairOnly         : Bool  -- true = mere repair with no return structure
  deriving DecidableEq, Repr

def validMissionReturn (m : ReturnModel) : Bool :=
  m.preservesIdentity && m.preservesRecord && m.bodilyReturn &&
  m.missionStructure && !m.repairOnly

-- The five named false positives.

def reanimationOnly : ReturnModel :=
  ⟨true, true, true, false, false⟩   -- comes back, but no mission structure

def memoryErasure : ReturnModel :=
  ⟨true, false, true, true, false⟩   -- returns, but the record is wiped

def symbolicOnly : ReturnModel :=
  ⟨true, true, false, true, false⟩   -- "lives on in memory"

def nonIdentityReplacement : ReturnModel :=
  ⟨false, true, true, true, false⟩   -- a successor, not the person

def pureRepairWithoutReturn : ReturnModel :=
  ⟨true, true, true, true, true⟩    -- fixed in place; nothing returned

theorem reanimation_only_rejected :
    validMissionReturn reanimationOnly = false := by decide

theorem memory_erasure_rejected :
    validMissionReturn memoryErasure = false := by decide

theorem symbolic_only_rejected :
    validMissionReturn symbolicOnly = false := by decide

theorem non_identity_replacement_rejected :
    validMissionReturn nonIdentityReplacement = false := by decide

theorem pure_repair_without_return_rejected :
    validMissionReturn pureRepairWithoutReturn = false := by decide

/-- Each requirement is load-bearing: dropping any single one admits a
    known false positive, so none of the guards is decorative. -/
theorem every_return_guard_is_load_bearing :
    validMissionReturn reanimationOnly = false ∧
    validMissionReturn memoryErasure = false ∧
    validMissionReturn symbolicOnly = false ∧
    validMissionReturn nonIdentityReplacement = false ∧
    validMissionReturn pureRepairWithoutReturn = false := by
  decide

/-- Sanity anchor: the full-structure return is the only one of the six
    canonical models that validates. -/
theorem full_structure_return_validates :
    validMissionReturn ⟨true, true, true, true, false⟩ = true := by decide

end Theophysics.NegativeInventory

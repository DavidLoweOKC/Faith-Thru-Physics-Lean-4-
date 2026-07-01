import Std

/-!
# Theophysics_ChiEvaluator

Std-only formal runtime for the χ-Evaluator.

This file does not make an AI model a truth oracle. It formalizes the
deterministic scoring skeleton underneath the evaluator:

* ten channels;
* positive and negative regimes;
* effective score = positive signal times one-minus-negative signal;
* product collapse;
* zero-channel annihilation;
* pressure-gradient labels;
* high-signal deception boundary checks.

Scores are natural numbers from 0 to 100. Effective channel scores are therefore
scaled natural values, but the product-collapse behavior is exact.
-/

namespace Theophysics.ChiEvaluator

inductive Channel where
  | G
  | M
  | E
  | S_eff
  | T
  | K
  | R
  | Q
  | F
  | C
deriving DecidableEq, Repr

inductive ClaimType where
  | analytic
  | empirical
  | moral
  | theological
  | speculative
  | narrative
  | policy
  | mixed
deriving DecidableEq, Repr

inductive GradientLabel where
  | positive
  | neutral
  | negative
  | unstable
deriving DecidableEq, Repr

inductive Verdict where
  | coherent
  | partiallyCoherent
  | fragile
  | highSignalDeception
  | collapsed
  | repairable
deriving DecidableEq, Repr

inductive PressureState where
  | static
  | compression
  | strongestObjection
  | time
  | translation
  | evidence
  | implementation
  | fruit
  | falsification
  | hostileMisuse
deriving DecidableEq, Repr

structure ChannelScore where
  vPos : Nat
  vNeg : Nat
  gradientDirection : Int
  confidence : Nat
deriving DecidableEq, Repr

def boundedScore (s : ChannelScore) : Prop :=
  s.vPos ≤ 100 ∧ s.vNeg ≤ 100 ∧ s.confidence ≤ 100

def effectiveScore (s : ChannelScore) : Nat :=
  s.vPos * (100 - s.vNeg)

def zeroPositive (gradientDirection : Int := 0) (confidence : Nat := 100) : ChannelScore where
  vPos := 0
  vNeg := 0
  gradientDirection := gradientDirection
  confidence := confidence

def fullyCorrupted (vPos : Nat := 100) (gradientDirection : Int := 0) (confidence : Nat := 100) :
    ChannelScore where
  vPos := vPos
  vNeg := 100
  gradientDirection := gradientDirection
  confidence := confidence

def perfectScore (gradientDirection : Int := 1) (confidence : Nat := 100) : ChannelScore where
  vPos := 100
  vNeg := 0
  gradientDirection := gradientDirection
  confidence := confidence

theorem effective_zero_if_no_positive_signal (s : ChannelScore) (h : s.vPos = 0) :
    effectiveScore s = 0 := by
  simp [effectiveScore, h]

theorem effective_zero_if_fully_corrupted (s : ChannelScore) (h : s.vNeg = 100) :
    effectiveScore s = 0 := by
  simp [effectiveScore, h]

theorem perfect_score_effective :
    effectiveScore (perfectScore 1 100) = 10000 := by
  rfl

structure Evaluation where
  claimType : ClaimType
  scoreG : ChannelScore
  scoreM : ChannelScore
  scoreE : ChannelScore
  scoreS_eff : ChannelScore
  scoreT : ChannelScore
  scoreK : ChannelScore
  scoreR : ChannelScore
  scoreQ : ChannelScore
  scoreF : ChannelScore
  scoreC : ChannelScore
deriving DecidableEq, Repr

def getScore (e : Evaluation) : Channel → ChannelScore
  | Channel.G => e.scoreG
  | Channel.M => e.scoreM
  | Channel.E => e.scoreE
  | Channel.S_eff => e.scoreS_eff
  | Channel.T => e.scoreT
  | Channel.K => e.scoreK
  | Channel.R => e.scoreR
  | Channel.Q => e.scoreQ
  | Channel.F => e.scoreF
  | Channel.C => e.scoreC

def staticChi (e : Evaluation) : Nat :=
  effectiveScore e.scoreG *
  effectiveScore e.scoreM *
  effectiveScore e.scoreE *
  effectiveScore e.scoreS_eff *
  effectiveScore e.scoreT *
  effectiveScore e.scoreK *
  effectiveScore e.scoreR *
  effectiveScore e.scoreQ *
  effectiveScore e.scoreF *
  effectiveScore e.scoreC

def allPerfectEvaluation : Evaluation where
  claimType := ClaimType.analytic
  scoreG := perfectScore
  scoreM := perfectScore
  scoreE := perfectScore
  scoreS_eff := perfectScore
  scoreT := perfectScore
  scoreK := perfectScore
  scoreR := perfectScore
  scoreQ := perfectScore
  scoreF := perfectScore
  scoreC := perfectScore

def coerciveClaim : Evaluation where
  claimType := ClaimType.policy
  scoreG := perfectScore
  scoreM := perfectScore
  scoreE := perfectScore
  scoreS_eff := perfectScore
  scoreT := perfectScore
  scoreK := perfectScore
  scoreR := perfectScore
  scoreQ := zeroPositive (-1) 100
  scoreF := perfectScore
  scoreC := perfectScore

def selfSealingClaim : Evaluation where
  claimType := ClaimType.mixed
  scoreG := zeroPositive (-1) 100
  scoreM := fullyCorrupted 100 (-1) 100
  scoreE := perfectScore
  scoreS_eff := perfectScore
  scoreT := perfectScore
  scoreK := perfectScore
  scoreR := perfectScore
  scoreQ := perfectScore
  scoreF := perfectScore
  scoreC := perfectScore

def highSignalLowFreedomClaim : Evaluation where
  claimType := ClaimType.policy
  scoreG := perfectScore
  scoreM := perfectScore
  scoreE := perfectScore
  scoreS_eff := perfectScore
  scoreT := perfectScore
  scoreK := perfectScore
  scoreR := perfectScore
  scoreQ := { vPos := 20, vNeg := 0, gradientDirection := -1, confidence := 100 }
  scoreF := perfectScore
  scoreC := perfectScore

def channelCollapsed (e : Evaluation) (c : Channel) : Bool :=
  effectiveScore (getScore e c) == 0

def collapsed (e : Evaluation) : Bool :=
  staticChi e == 0

def highSignalDeception (e : Evaluation) : Bool :=
  7000 < effectiveScore e.scoreE &&
  (effectiveScore e.scoreQ < 2500 ||
   effectiveScore e.scoreK < 2500 ||
   effectiveScore e.scoreT < 2500)

def inferVerdict (e : Evaluation) : Verdict :=
  if collapsed e then Verdict.collapsed
  else if highSignalDeception e then Verdict.highSignalDeception
  else Verdict.partiallyCoherent

theorem static_chi_zero_if_G_zero (e : Evaluation) (h : effectiveScore e.scoreG = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_M_zero (e : Evaluation) (h : effectiveScore e.scoreM = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_E_zero (e : Evaluation) (h : effectiveScore e.scoreE = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_S_eff_zero (e : Evaluation) (h : effectiveScore e.scoreS_eff = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_T_zero (e : Evaluation) (h : effectiveScore e.scoreT = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_K_zero (e : Evaluation) (h : effectiveScore e.scoreK = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_R_zero (e : Evaluation) (h : effectiveScore e.scoreR = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_Q_zero (e : Evaluation) (h : effectiveScore e.scoreQ = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_F_zero (e : Evaluation) (h : effectiveScore e.scoreF = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem static_chi_zero_if_C_zero (e : Evaluation) (h : effectiveScore e.scoreC = 0) :
    staticChi e = 0 := by
  simp [staticChi, h]

theorem coercive_claim_collapses :
    collapsed coerciveClaim = true := by
  rfl

theorem self_sealing_claim_collapses :
    collapsed selfSealingClaim = true := by
  rfl

theorem high_signal_low_freedom_detected :
    highSignalDeception highSignalLowFreedomClaim = true := by
  rfl

theorem high_signal_low_freedom_not_collapsed :
    collapsed highSignalLowFreedomClaim = false := by
  rfl

theorem high_signal_low_freedom_verdict :
    inferVerdict highSignalLowFreedomClaim = Verdict.highSignalDeception := by
  rfl

structure PressureResult where
  pressureState : PressureState
  chi : Nat
deriving DecidableEq, Repr

def pressureImproves (a b : PressureResult) : Bool :=
  a.chi < b.chi

def pressureDecays (a b : PressureResult) : Bool :=
  b.chi < a.chi

def inferTwoPointGradient (a b : PressureResult) : GradientLabel :=
  if pressureImproves a b then GradientLabel.positive
  else if pressureDecays a b then GradientLabel.negative
  else GradientLabel.neutral

def weakButGrowingStart : PressureResult where
  pressureState := PressureState.static
  chi := 42

def weakButGrowingEnd : PressureResult where
  pressureState := PressureState.falsification
  chi := 61

def strongButDecayingStart : PressureResult where
  pressureState := PressureState.static
  chi := 76

def strongButDecayingEnd : PressureResult where
  pressureState := PressureState.hostileMisuse
  chi := 20

theorem weak_but_growing_has_positive_gradient :
    inferTwoPointGradient weakButGrowingStart weakButGrowingEnd = GradientLabel.positive := by
  rfl

theorem strong_but_decaying_has_negative_gradient :
    inferTwoPointGradient strongButDecayingStart strongButDecayingEnd = GradientLabel.negative := by
  rfl

structure FruitOutput where
  fruitScore : Nat
  antiFruitScore : Nat
deriving DecidableEq, Repr

def fruitDominates (f : FruitOutput) : Bool :=
  f.antiFruitScore < f.fruitScore

def antiFruitDominates (f : FruitOutput) : Bool :=
  f.fruitScore < f.antiFruitScore

def peacefulOutput : FruitOutput where
  fruitScore := 90
  antiFruitScore := 5

def coerciveOutput : FruitOutput where
  fruitScore := 10
  antiFruitScore := 80

theorem peaceful_output_fruit_dominates :
    fruitDominates peacefulOutput = true := by
  rfl

theorem coercive_output_antifruit_dominates :
    antiFruitDominates coerciveOutput = true := by
  rfl

theorem chi_evaluator_marker :
    collapsed coerciveClaim = true ∧
    collapsed selfSealingClaim = true ∧
    highSignalDeception highSignalLowFreedomClaim = true ∧
    inferTwoPointGradient weakButGrowingStart weakButGrowingEnd = GradientLabel.positive ∧
    inferTwoPointGradient strongButDecayingStart strongButDecayingEnd = GradientLabel.negative ∧
    fruitDominates peacefulOutput = true ∧
    antiFruitDominates coerciveOutput = true := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Theophysics.ChiEvaluator

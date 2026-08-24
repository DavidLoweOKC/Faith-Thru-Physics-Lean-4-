import PrivativeMagnitude
import KernelV1
import Final_Lean4_From_Excel
import Theophysics_Coherence
import Theophysics_Fracture
import Theophysics_Fall
import Theophysics_ChiEvaluator
import Theophysics_Core
import Theophysics_Adversarial
import Theophysics_NegativeInventory

/-!
# Integrated Master Derivation

This is the single compilation root for the current published Lean surface.
Importing every current module catches namespace, type, and dependency conflicts.

`CurrentCertificate` deliberately certifies only non-vacuous propositions with
typed mathematical content. Older compatibility theorems whose proposition is
merely `True` remain imported, but they are not fields of this certificate and
must not be counted as spiritual or physical proofs.
-/

open PrivativeMagnitude

namespace Theophysics.MasterDerivation

/-- The non-vacuous theorem surface currently admitted to the integrated rail. -/
structure CurrentCertificate : Prop where
  normalizedDomain :
    ∃ x : KernelV1.Coordinates,
      KernelV1.InUnitCube x ∧
      KernelV1.kernelProduct x = (1 / 2 : ℝ) ^ 9
  normalizedProductBounds :
    ∀ x : KernelV1.Coordinates,
      KernelV1.InUnitCube x →
      0 ≤ KernelV1.kernelProduct x ∧ KernelV1.kernelProduct x ≤ 1
  normalizedZeroVeto :
    ∀ (x : KernelV1.Coordinates) (j : Fin 9),
      x j = 0 → KernelV1.kernelProduct x = 0
  normalizedCompletionRigidity :
    ∀ x : KernelV1.Coordinates,
      KernelV1.InUnitCube x →
      KernelV1.kernelProduct x = 1 →
      ∀ i, x i = 1
  privativeBoundedPower :
    ∀ (σ : Orientation) (s : State), |effect σ s| ≤ s.power
  privativeTotalDeprivation :
    ∀ (σ : Orientation) (s : State),
      s.deprivation = 1 → effect σ s = 0
  bareCornellObstruction :
    ∀ α κ r : ℝ,
      0 < α → 0 < κ → 0 < r →
      KernelV1.cornellStationaryPolynomial α κ r ≠ 0
  operatorRoleSeparation :
    ¬ ∃ G : KernelV1.Mat2,
      G ≠ 0 ∧ KernelV1.AnticommutesWithSign G ∧ KernelV1.Idempotent G
  coercionIsNotFullCoherence :
    Coherence.coherent Coherence.coerciveOrder = false
  restorationRequiresOpenBoundary :
    ∀ m : Coherence.RestorationModel,
      Coherence.canRestore m = true →
      m.boundary = Coherence.SystemBoundary.open
  fractureRepairRequiresInput :
    ∀ m : Fracture.FractureModel,
      Fracture.repairable m = true → m.restorationInput = true
  sustainedFallRequiresGraceFloor :
    ∀ m : Fall.FallModel,
      Fall.sustainedAfterFall m = true → m.externalGraceFloor = true
  coerciveClaimIsRejected :
    ChiEvaluator.collapsed ChiEvaluator.coerciveClaim = true
  normalizedNatZeroVeto :
    ∀ x : Experiment.FactorState,
      x.Q = 0 → Experiment.chi x = 0

/--
The current integrated certificate. Every field is discharged by a named
theorem from an imported module; none is filled by `trivial`.
-/
theorem currentCertificate : CurrentCertificate := by
  refine {
    normalizedDomain := KernelV1.normalized_domain_nonempty
    normalizedProductBounds := ?_
    normalizedZeroVeto := ?_
    normalizedCompletionRigidity := ?_
    privativeBoundedPower := ?_
    privativeTotalDeprivation := ?_
    bareCornellObstruction := ?_
    operatorRoleSeparation := KernelV1.nonzero_anticommuting_idempotent_is_impossible
    coercionIsNotFullCoherence := Coherence.coercive_order_is_not_full_coherence
    restorationRequiresOpenBoundary := Coherence.restoration_requires_open_boundary
    fractureRepairRequiresInput := Fracture.repair_requires_restoration_input
    sustainedFallRequiresGraceFloor := Fall.sustained_after_fall_requires_grace_floor
    coerciveClaimIsRejected := ChiEvaluator.coercive_claim_collapses
    normalizedNatZeroVeto := Experiment.Q_zero_collapses_chi
  }
  · intro x hx
    exact KernelV1.product_stays_in_unit_interval x hx
  · intro x j hj
    exact KernelV1.zero_veto x j hj
  · intro x hx hproduct
    exact KernelV1.product_one_forces_all_coordinates_one x hx hproduct
  · intro σ s
    exact bounded_power σ s
  · intro σ s hdeprivation
    exact total_deprivation_annihilates σ s hdeprivation
  · intro α κ r hα hκ hr
    exact KernelV1.bare_cornell_has_no_positive_radius_stationary_point α κ r hα hκ hr

#print axioms currentCertificate

end Theophysics.MasterDerivation

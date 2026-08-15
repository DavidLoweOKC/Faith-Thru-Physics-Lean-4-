/-!
# ResurrectionFormal.IsomorphismTest

A small, concrete test of the "Law 4" structural-isomorphism claim:
strong-force confinement/freedom on the physics side and love/agape
captivity/liberation on the theological side.

The point of this file is deliberately narrow. It proves that the chosen
two-state abstractions are isomorphic under the `LawIso` record below, and it
also proves that several nearby wrong mappings fail under the same definition.

The adversarial boundary is equally important: this same minimal definition can
also accept unrelated two-state systems if they share the same zero/one and
collapse pattern. That is not a Lean bug; it means this file verifies only the
chosen abstraction, not the full physical or theological interpretation.
-/

namespace ResurrectionFormal

class CoherenceAlgebra (alpha : Type) where
  zero : alpha
  one : alpha
  one_ne_zero : Not (one = zero)

structure LawModel (alpha : Type) [CoherenceAlgebra alpha] where
  State : Type
  value : State -> alpha
  collapsed : State -> Prop
  collapsed_value_zero :
    forall s, collapsed s -> value s = CoherenceAlgebra.zero

structure LawIso {alpha : Type} [CoherenceAlgebra alpha]
    (X Y : LawModel alpha) where
  toFun : X.State -> Y.State
  invFun : Y.State -> X.State
  left_inverse : forall x, invFun (toFun x) = x
  right_inverse : forall y, toFun (invFun y) = y
  preserves_value : forall x, Y.value (toFun x) = X.value x
  preserves_collapse : forall x, X.collapsed x <-> Y.collapsed (toFun x)

/-! ## Matched Law 4 models -/

inductive StrongForceState where
  | bound
  | free
deriving DecidableEq, Repr

inductive LoveState where
  | captivity
  | liberation
deriving DecidableEq, Repr

variable {alpha : Type} [A : CoherenceAlgebra alpha]

def strongForceModel : LawModel alpha where
  State := StrongForceState
  value := fun s =>
    match s with
    | StrongForceState.bound => A.zero
    | StrongForceState.free => A.one
  collapsed := fun s => s = StrongForceState.bound
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def loveModel : LawModel alpha where
  State := LoveState
  value := fun s =>
    match s with
    | LoveState.captivity => A.zero
    | LoveState.liberation => A.one
  collapsed := fun s => s = LoveState.captivity
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def strongForceToLove : StrongForceState -> LoveState
  | StrongForceState.bound => LoveState.captivity
  | StrongForceState.free => LoveState.liberation

def loveToStrongForce : LoveState -> StrongForceState
  | LoveState.captivity => StrongForceState.bound
  | LoveState.liberation => StrongForceState.free

def law4Iso : @LawIso alpha A strongForceModel loveModel where
  toFun := strongForceToLove
  invFun := loveToStrongForce
  left_inverse := by
    intro x
    cases x <;> rfl
  right_inverse := by
    intro y
    cases y <;> rfl
  preserves_value := by
    intro x
    cases x <;> rfl
  preserves_collapse := by
    intro x
    cases x <;> simp [strongForceModel, loveModel, strongForceToLove]

/-! ## False-positive boundary of the minimal abstraction

Under the current `LawIso`, an unrelated two-state system with the same
zero/one and collapse pattern is also isomorphic. This is the precise Opus/GPT
objection: the current structure can verify a binary abstraction, but it cannot
by itself know that the abstraction retains enough strong-force or love content.
-/

inductive CoinState where
  | tails
  | heads
deriving DecidableEq, Repr

def coinModel : LawModel alpha where
  State := CoinState
  value := fun s =>
    match s with
    | CoinState.tails => A.zero
    | CoinState.heads => A.one
  collapsed := fun s => s = CoinState.tails
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def strongForceToCoin : StrongForceState -> CoinState
  | StrongForceState.bound => CoinState.tails
  | StrongForceState.free => CoinState.heads

def coinToStrongForce : CoinState -> StrongForceState
  | CoinState.tails => StrongForceState.bound
  | CoinState.heads => StrongForceState.free

/--
This theorem is intentionally adversarial. It shows that the present `LawIso`
definition is too weak to distinguish a meaningful Law 4 bridge from any
unrelated binary zero/one system with the same collapse predicate.
-/
def strongForceCoinIso : @LawIso alpha A strongForceModel coinModel where
  toFun := strongForceToCoin
  invFun := coinToStrongForce
  left_inverse := by
    intro x
    cases x <;> rfl
  right_inverse := by
    intro y
    cases y <;> rfl
  preserves_value := by
    intro x
    cases x <;> rfl
  preserves_collapse := by
    intro x
    cases x <;> simp [strongForceModel, coinModel, strongForceToCoin]

/-! ## Stronger bridge: roles and transitions

The next specification adds two pieces of structure that the minimal `LawIso`
does not see:

* a regime role, so the model must preserve more than zero/one values;
* a transition relation, so the model must preserve allowed movement between
  regimes.

This blocks the natural coin false positive. It still cannot block a coin model
whose roles are deliberately relabeled to imitate Law 4. That second result is
the deeper formal-methods boundary: Lean checks the specification it is given;
it cannot certify that a human-provided label is a faithful domain reading.
-/

inductive RegimeRole where
  | constraining
  | liberating
  | randomLow
  | randomHigh
deriving DecidableEq, Repr

structure RichLawModel (alpha : Type) [CoherenceAlgebra alpha] where
  State : Type
  value : State -> alpha
  collapsed : State -> Prop
  role : State -> RegimeRole
  step : State -> State -> Prop
  collapsed_value_zero :
    forall s, collapsed s -> value s = CoherenceAlgebra.zero

structure RichLawIso {alpha : Type} [CoherenceAlgebra alpha]
    (X Y : RichLawModel alpha) where
  toFun : X.State -> Y.State
  invFun : Y.State -> X.State
  left_inverse : forall x, invFun (toFun x) = x
  right_inverse : forall y, toFun (invFun y) = y
  preserves_value : forall x, Y.value (toFun x) = X.value x
  preserves_collapse : forall x, X.collapsed x <-> Y.collapsed (toFun x)
  preserves_role : forall x, Y.role (toFun x) = X.role x
  preserves_step : forall x x', X.step x x' -> Y.step (toFun x) (toFun x')
  reflects_step : forall x x', Y.step (toFun x) (toFun x') -> X.step x x'

def richLawIsoRefl (X : RichLawModel alpha) : RichLawIso X X where
  toFun := id
  invFun := id
  left_inverse := by
    intro x
    rfl
  right_inverse := by
    intro y
    rfl
  preserves_value := by
    intro x
    rfl
  preserves_collapse := by
    intro x
    constructor <;> intro h <;> exact h
  preserves_role := by
    intro x
    rfl
  preserves_step := by
    intro x x' h
    exact h
  reflects_step := by
    intro x x' h
    exact h

inductive StrongForceStep : StrongForceState -> StrongForceState -> Prop where
  | release : StrongForceStep StrongForceState.bound StrongForceState.free

inductive LoveStep : LoveState -> LoveState -> Prop where
  | release : LoveStep LoveState.captivity LoveState.liberation

def richStrongForceModel : RichLawModel alpha where
  State := StrongForceState
  value := fun s =>
    match s with
    | StrongForceState.bound => A.zero
    | StrongForceState.free => A.one
  collapsed := fun s => s = StrongForceState.bound
  role := fun s =>
    match s with
    | StrongForceState.bound => RegimeRole.constraining
    | StrongForceState.free => RegimeRole.liberating
  step := StrongForceStep
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def richLoveModel : RichLawModel alpha where
  State := LoveState
  value := fun s =>
    match s with
    | LoveState.captivity => A.zero
    | LoveState.liberation => A.one
  collapsed := fun s => s = LoveState.captivity
  role := fun s =>
    match s with
    | LoveState.captivity => RegimeRole.constraining
    | LoveState.liberation => RegimeRole.liberating
  step := LoveStep
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def richLaw4Iso : @RichLawIso alpha A richStrongForceModel richLoveModel where
  toFun := strongForceToLove
  invFun := loveToStrongForce
  left_inverse := by
    intro x
    cases x <;> rfl
  right_inverse := by
    intro y
    cases y <;> rfl
  preserves_value := by
    intro x
    cases x <;> rfl
  preserves_collapse := by
    intro x
    cases x <;> simp [richStrongForceModel, richLoveModel, strongForceToLove]
  preserves_role := by
    intro x
    cases x <;> rfl
  preserves_step := by
    intro x x' h
    cases h
    exact LoveStep.release
  reflects_step := by
    intro x x' h
    cases x <;> cases x' <;> cases h
    exact StrongForceStep.release

inductive CoinFlipStep : CoinState -> CoinState -> Prop where
  | flipUp : CoinFlipStep CoinState.tails CoinState.heads

def richNaturalCoinModel : RichLawModel alpha where
  State := CoinState
  value := fun s =>
    match s with
    | CoinState.tails => A.zero
    | CoinState.heads => A.one
  collapsed := fun s => s = CoinState.tails
  role := fun s =>
    match s with
    | CoinState.tails => RegimeRole.randomLow
    | CoinState.heads => RegimeRole.randomHigh
  step := CoinFlipStep
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

theorem no_rich_iso_to_natural_coin :
    Not (Nonempty (@RichLawIso alpha A richStrongForceModel richNaturalCoinModel)) := by
  intro h
  cases h with
  | intro iso =>
  have hValue := iso.preserves_value StrongForceState.bound
  have hRole := iso.preserves_role StrongForceState.bound
  cases hTo : iso.toFun StrongForceState.bound
  · simp [richStrongForceModel, richNaturalCoinModel, hTo] at hRole
  · simp [richStrongForceModel, richNaturalCoinModel, hTo] at hValue
    exact A.one_ne_zero hValue

def richRelabeledCoinModel : RichLawModel alpha where
  State := CoinState
  value := fun s =>
    match s with
    | CoinState.tails => A.zero
    | CoinState.heads => A.one
  collapsed := fun s => s = CoinState.tails
  role := fun s =>
    match s with
    | CoinState.tails => RegimeRole.constraining
    | CoinState.heads => RegimeRole.liberating
  step := CoinFlipStep
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def richRelabeledCoinIso :
    @RichLawIso alpha A richStrongForceModel richRelabeledCoinModel where
  toFun := strongForceToCoin
  invFun := coinToStrongForce
  left_inverse := by
    intro x
    cases x <;> rfl
  right_inverse := by
    intro y
    cases y <;> rfl
  preserves_value := by
    intro x
    cases x <;> rfl
  preserves_collapse := by
    intro x
    cases x <;> simp [richStrongForceModel, richRelabeledCoinModel, strongForceToCoin]
  preserves_role := by
    intro x
    cases x <;> rfl
  preserves_step := by
    intro x x' h
    cases h
    exact CoinFlipStep.flipUp
  reflects_step := by
    intro x x' h
    cases x <;> cases x' <;> cases h
    exact StrongForceStep.release

/-! ## Adversarial tests -/

inductive FaithState where
  | superposition
  | committed
  | decoherent
deriving DecidableEq, Repr

def faithModel : LawModel alpha where
  State := FaithState
  value := fun s =>
    match s with
    | FaithState.superposition => A.one
    | FaithState.committed => A.one
    | FaithState.decoherent => A.zero
  collapsed := fun s => s = FaithState.decoherent
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def strongForceToFaithCandidate : StrongForceState -> FaithState
  | StrongForceState.bound => FaithState.decoherent
  | StrongForceState.free => FaithState.committed

def faithToStrongCandidate : FaithState -> StrongForceState
  | FaithState.superposition => StrongForceState.free
  | FaithState.committed => StrongForceState.free
  | FaithState.decoherent => StrongForceState.bound

theorem faith_candidate_not_right_inverse :
    Not (forall y,
      strongForceToFaithCandidate (faithToStrongCandidate y) = y) := by
  intro h
  have hx := h FaithState.superposition
  simp [strongForceToFaithCandidate, faithToStrongCandidate] at hx

inductive EMState where
  | attract
  | repel
  | neutral
deriving DecidableEq, Repr

def emModel : LawModel alpha where
  State := EMState
  value := fun s =>
    match s with
    | EMState.attract => A.one
    | EMState.repel => A.one
    | EMState.neutral => A.zero
  collapsed := fun s => s = EMState.neutral
  collapsed_value_zero := by
    intro s hs
    cases hs
    rfl

def strongForceToEMCandidate : StrongForceState -> EMState
  | StrongForceState.bound => EMState.neutral
  | StrongForceState.free => EMState.attract

def emToStrongCandidate : EMState -> StrongForceState
  | EMState.attract => StrongForceState.free
  | EMState.repel => StrongForceState.free
  | EMState.neutral => StrongForceState.bound

theorem em_candidate_not_right_inverse :
    Not (forall y,
      strongForceToEMCandidate (emToStrongCandidate y) = y) := by
  intro h
  have hx := h EMState.repel
  simp [strongForceToEMCandidate, emToStrongCandidate] at hx

def invertedMapping : StrongForceState -> LoveState
  | StrongForceState.bound => LoveState.liberation
  | StrongForceState.free => LoveState.captivity

def invertedMappingInv : LoveState -> StrongForceState
  | LoveState.captivity => StrongForceState.free
  | LoveState.liberation => StrongForceState.bound

theorem inverted_mapping_does_not_preserve_value :
    Not (forall x : StrongForceState,
      (@loveModel alpha A).value (invertedMapping x) =
        (@strongForceModel alpha A).value x) := by
  intro h
  have hx := h StrongForceState.bound
  simp [strongForceModel, loveModel, invertedMapping] at hx
  exact A.one_ne_zero hx

theorem no_law4_iso_uses_inverted_mapping :
    Not (exists iso : @LawIso alpha A strongForceModel loveModel,
      iso.toFun = invertedMapping) := by
  intro h
  cases h with
  | intro iso hTo =>
  have hx := iso.preserves_value StrongForceState.bound
  rw [hTo] at hx
  simp [strongForceModel, loveModel, invertedMapping] at hx
  exact A.one_ne_zero hx

inductive MisalignedState where
  | stateA
  | stateB
deriving DecidableEq, Repr

def misalignedValue : MisalignedState -> alpha
  | MisalignedState.stateA => A.zero
  | MisalignedState.stateB => A.one

def misalignedCollapsed : MisalignedState -> Prop :=
  fun s => s = MisalignedState.stateB

theorem misaligned_collapse_rule_invalid :
    Not (forall s,
      misalignedCollapsed s ->
        @misalignedValue alpha A s = A.zero) := by
  intro h
  have hx := h MisalignedState.stateB rfl
  simp [misalignedValue] at hx
  exact A.one_ne_zero hx

end ResurrectionFormal

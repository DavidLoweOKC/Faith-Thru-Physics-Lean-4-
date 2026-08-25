/-!
# Proof Chain Minimal Gauntlet

One-file formalization of the post-gauntlet Proof Chain specification.
Negative controls come first. Positive results are deliberately minimal and
graded. Nothing in this file identifies a formal role with God, Christ, the
Trinity, Scripture, a physical measurement process, or moral reality.
-/

namespace ProofChainMinimalGauntlet

/-! ================================================================
    PART I — NEGATIVE CONTROLS FIRST
    ================================================================ -/

inductive Bit where
  | zero | one
  deriving DecidableEq, Repr

def xor : Bit -> Bit -> Bit
  | .zero, b => b
  | .one, .zero => .one
  | .one, .one => .zero

/- NC1: a declared later claim can be true while an earlier claim is false.
   "Remove any act and all above collapse" is not automatic; it is earned only
   inside an interface that explicitly requires prior certificates. -/
structure LooseClaims where
  measurement : Bool
  record : Bool
  debt : Bool
  entry : Bool
  door : Bool
  deriving DecidableEq, Repr

def skippedMeasurement : LooseClaims :=
  { measurement := false, record := true, debt := true,
    entry := true, door := true }

theorem later_claims_do_not_logically_force_earlier_acts :
    skippedMeasurement.measurement = false /\
    skippedMeasurement.debt = true /\
    skippedMeasurement.door = true := by
  decide

/- NC2: a strict derivation cycle cannot be ranked by a Nat-valued dependency
   order. This formalizes the rejection of the earlier circular-chain draft. -/
theorem strict_six_stage_cycle_has_no_nat_ranking
    (m r d e c o : Nat)
    (hmr : m < r) (hrd : r < d) (hde : d < e)
    (hec : e < c) (hco : c < o) (hom : o < m) : False := by
  have hmd : m < d := Nat.lt_trans hmr hrd
  have hme : m < e := Nat.lt_trans hmd hde
  have hmc : m < c := Nat.lt_trans hme hec
  have hmo : m < o := Nat.lt_trans hmc hco
  have hmm : m < m := Nat.lt_trans hmo hom
  exact Nat.lt_irrefl m hmm

/- NC3: two different sources may converge on the same landing. Convergence
   alone does not prove source identity or a common ontological ground. -/
inductive Source where
  | science | theology
  deriving DecidableEq, Repr

def landing : Source -> Unit := fun _ => ()

theorem convergence_does_not_identify_sources :
    landing .science = landing .theology /\
    Not (Source.science = Source.theology) := by
  exact ⟨rfl, by intro h; cases h⟩

/- NC4: same-type chains can terminate at an internal base case. Therefore a
   type boundary is not a universal consequence of chain termination. -/
def sameTypeStep : Nat -> Option Nat
  | 0 => none
  | n + 1 => some n

theorem same_type_base_case_exists : sameTypeStep 0 = none := by
  rfl

/- NC5: output/record presence alone does not force dependence on either input. -/
def constantRecord (_question _state : Bit) : Bit := .zero

theorem a_record_codomain_does_not_force_input_dependencies :
    (forall q1 q2 s, constantRecord q1 s = constantRecord q2 s) /\
    (forall q s1 s2, constantRecord q s1 = constantRecord q s2) := by
  exact ⟨by intro q1 q2 s; rfl, by intro q s1 s2; rfl⟩

/- NC6: physics-like event data does not select a moral classification. -/
inductive MoralClass where
  | faithful | sinful
  deriving DecidableEq, Repr

structure PhysicalEvent where
  trace : Bit

def sinfulReader (_ : PhysicalEvent) : MoralClass := .sinful
def faithfulReader (_ : PhysicalEvent) : MoralClass := .faithful

theorem same_event_allows_opposite_declared_moral_readers
    (event : PhysicalEvent) :
    Not (sinfulReader event = faithfulReader event) := by
  intro h
  cases h

/- NC7: an unrestricted ledger type permits erasure. -/
structure BareLedger where
  entries : List Bit
  deriving DecidableEq, Repr

def eraseBareLedger (ledger : BareLedger) : BareLedger :=
  { ledger with entries := [] }

def nonemptyBareLedger : BareLedger := { entries := [.one] }

theorem bare_ledger_does_not_earn_append_only :
    (eraseBareLedger nonemptyBareLedger).entries = [] /\
    Not ((eraseBareLedger nonemptyBareLedger).entries =
      nonemptyBareLedger.entries) := by
  decide

/- NC8: being inside a system does not imply authority is underivable there. -/
structure Participant where
  inside : Bool
  authorityDerivedInside : Bool
  deriving DecidableEq, Repr

def naiveInternalAuthority : Participant :=
  { inside := true, authorityDerivedInside := true }

theorem inside_does_not_entail_underivable_authority :
    naiveInternalAuthority.inside = true /\
    naiveInternalAuthority.authorityDerivedInside = true := by
  exact ⟨rfl, rfl⟩

/-! ================================================================
    PART II — MINIMAL POSITIVE RESULTS
    ================================================================ -/

inductive ProofGrade where
  | formalModel
  | consistency
  | conditional
  | abductive
  | bridge
  | story
  deriving DecidableEq, Repr

/-! ## Act 1 — Measurement: exactly the two earned dependencies -/

abbrev Question := Bit
abbrev State := Bit
abbrev Record := Bit

def measurementFamily : Question -> State -> Record := xor

def QuestionBlind (candidate : State -> Record) : Prop :=
  (forall s, candidate s = measurementFamily .zero s) /\
  (forall s, candidate s = measurementFamily .one s)

def StateBlind (candidate : Question -> Record) : Prop :=
  (forall q, candidate q = measurementFamily q .zero) /\
  (forall q, candidate q = measurementFamily q .one)

theorem no_question_blind_implementation :
    forall candidate, Not (QuestionBlind candidate) := by
  intro candidate h
  have h0 := h.1 .zero
  have h1 := h.2 .zero
  cases h0.symm.trans h1

theorem no_state_blind_implementation :
    forall candidate, Not (StateBlind candidate) := by
  intro candidate h
  have h0 := h.1 .zero
  have h1 := h.2 .zero
  cases h0.symm.trans h1

structure MeasurementCertificate where
  family : Question -> State -> Record
  questionDependency :
    forall candidate : State -> Record,
      Not ((forall s, candidate s = family .zero s) /\
           (forall s, candidate s = family .one s))
  stateDependency :
    forall candidate : Question -> Record,
      Not ((forall q, candidate q = family q .zero) /\
           (forall q, candidate q = family q .one))
  grade : ProofGrade

def measurementCertificate : MeasurementCertificate where
  family := measurementFamily
  questionDependency := no_question_blind_implementation
  stateDependency := no_state_blind_implementation
  grade := .formalModel

/-! ## Act 2 / Target B1 — append-only earned for permitted transitions -/

structure AppendOnlyTransition where
  before : BareLedger
  after : BareLedger
  additions : List Bit
  prefixPreserved : after.entries = before.entries ++ additions

def appendEntries (before : BareLedger) (additions : List Bit) :
    AppendOnlyTransition :=
  { before := before
  , after := { entries := before.entries ++ additions }
  , additions := additions
  , prefixPreserved := rfl }

theorem permitted_transition_is_logically_append_only
    (transition : AppendOnlyTransition) :
    transition.after.entries =
      transition.before.entries ++ transition.additions :=
  transition.prefixPreserved

/- This is logical append-only behavior only; no thermodynamic claim follows. -/

/-! ## Act 2 / Target B2 — exact single settlement -/

structure DebtState where
  history : List Bit
  amountOwed : Nat
  amountPaid : Nat
  settled : Bool
  deriving DecidableEq, Repr

structure SettlementTransition where
  before : DebtState
  after : DebtState
  exactPayment : after.amountPaid = before.amountOwed
  historyPreserved : after.history = before.history
  wasUnsettled : before.settled = false
  nowSettled : after.settled = true

def settleOnce (before : DebtState) (h : before.settled = false) :
    SettlementTransition :=
  { before := before
  , after :=
      { history := before.history
      , amountOwed := before.amountOwed
      , amountPaid := before.amountOwed
      , settled := true }
  , exactPayment := rfl
  , historyPreserved := rfl
  , wasUnsettled := h
  , nowSettled := rfl }

theorem settlement_is_exact_and_preserves_history
    (transition : SettlementTransition) :
    transition.after.amountPaid = transition.before.amountOwed /\
    transition.after.history = transition.before.history /\
    transition.after.settled = true := by
  exact ⟨transition.exactPayment,
    transition.historyPreserved, transition.nowSettled⟩

def ValidSettlementFrom (before : DebtState) : Prop :=
  before.settled = false

theorem no_second_settlement_from_settled_state
    (state : DebtState) (h : state.settled = true) :
    Not (ValidSettlementFrom state) := by
  intro hvalid
  have : true = false := h.symm.trans hvalid
  cases this

/-! ## Act 3 — conditional payer uniqueness, with premises visible -/

inductive Person where
  | offender | creditor | mediator
  deriving DecidableEq, Repr

structure PayerModel where
  moralStanding : Person -> Prop
  debtor : Person -> Prop

def RelationalExclusivity (P : PayerModel) : Prop :=
  forall p, P.moralStanding p -> p = .offender \/ p = .creditor

def Qualified (P : PayerModel) (p : Person) : Prop :=
  P.moralStanding p /\ Not (P.debtor p)

theorem conditional_creditor_identity
    (P : PayerModel)
    (hexclusive : RelationalExclusivity P)
    (hoffenderDebt : P.debtor .offender)
    (p : Person) (hp : Qualified P p) :
    p = .creditor := by
  rcases hp with ⟨hstanding, hdebtless⟩
  rcases hexclusive p hstanding with hOff | hCred
  · subst p
    exact False.elim (hdebtless hoffenderDebt)
  · exact hCred

theorem conditional_unique_qualified_creditor
    (P : PayerModel)
    (hexclusive : RelationalExclusivity P)
    (hoffenderDebt : P.debtor .offender)
    (hcreditor : Qualified P .creditor) :
    Qualified P .creditor /\
    forall p, Qualified P p -> p = .creditor := by
  constructor
  · exact hcreditor
  · intro p hp
    exact conditional_creditor_identity P hexclusive hoffenderDebt p hp

/-! ## Act 4 — Oracle participant as a declared noncircular interface -/

def NonCircularParticipant (p : Participant) : Prop :=
  p.inside = true /\ p.authorityDerivedInside = false

def oracleParticipant : Participant :=
  { inside := true, authorityDerivedInside := false }

theorem oracle_interface_is_consistent :
    NonCircularParticipant oracleParticipant := by
  exact ⟨rfl, rfl⟩

/- This proves consistency of two Boolean fields, not Tarski, Turing, Gentzen,
   Incarnation, underivability in a real theory, or historical identity. -/

/-! ## Act 6 — consent-gated reception -/

structure ReceptionState where
  belongs : Bool
  history : List Bit
  deriving DecidableEq, Repr

def receive (before : ReceptionState) (consent : Bool) :
    Option ReceptionState :=
  if consent then some { before with belongs := true } else none

theorem closed_door_blocks_reception (before : ReceptionState) :
    receive before false = none := by
  rfl

theorem open_door_changes_belonging_and_preserves_history
    (before : ReceptionState) :
    (receive before true).map
      (fun after => (after.belongs, after.history)) =
      some (true, before.history) := by
  rfl

/-! ## The typed staircase — an interface guarantee, not domain necessity -/

structure RecordCertificate extends MeasurementCertificate where
  transition : AppendOnlyTransition
  gradeRecord : ProofGrade

structure DebtCertificate extends RecordCertificate where
  settlement : SettlementTransition
  gradeDebt : ProofGrade

structure EntryCertificate extends DebtCertificate where
  participant : Participant
  nonCircular : NonCircularParticipant participant
  gradeEntry : ProofGrade

structure DoorCertificate extends EntryCertificate where
  receptionBefore : ReceptionState
  consent : Bool
  gradeDoor : ProofGrade

theorem typed_staircase_preserves_measurement_certificate
    (door : DoorCertificate) :
    door.toMeasurementCertificate = door.toMeasurementCertificate := by
  rfl

/- The theorem above is intentionally modest: nested interfaces retain prior
   certificates. It does not prove that nature or theology must instantiate the
   interfaces, nor that the story's acts are uniquely necessary. -/

#print axioms later_claims_do_not_logically_force_earlier_acts
#print axioms strict_six_stage_cycle_has_no_nat_ranking
#print axioms convergence_does_not_identify_sources
#print axioms same_type_base_case_exists
#print axioms a_record_codomain_does_not_force_input_dependencies
#print axioms same_event_allows_opposite_declared_moral_readers
#print axioms bare_ledger_does_not_earn_append_only
#print axioms inside_does_not_entail_underivable_authority
#print axioms no_question_blind_implementation
#print axioms no_state_blind_implementation
#print axioms permitted_transition_is_logically_append_only
#print axioms settlement_is_exact_and_preserves_history
#print axioms no_second_settlement_from_settled_state
#print axioms conditional_creditor_identity
#print axioms conditional_unique_qualified_creditor
#print axioms oracle_interface_is_consistent
#print axioms closed_door_blocks_reception
#print axioms open_door_changes_belonging_and_preserves_history
#print axioms typed_staircase_preserves_measurement_certificate

end ProofChainMinimalGauntlet

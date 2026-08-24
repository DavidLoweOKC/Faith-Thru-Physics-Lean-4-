# What We Tested in Lean Today

**Date:** August 24, 2026

**Project:** Faith Through Physics — restoration, moral debt, death, and resurrection
**Status:** Experimental formal models; all new Lean files passed direct checking

## The question

We began with a simple but serious question:

> Did our formal work imply that somebody had to die, or did it only say that a
> cost or debt had been paid?

Instead of protecting a preferred answer, we repeatedly weakened the model. We
removed assumptions, constructed counterexamples, widened the model from one
person to the whole population, compared religious mechanisms, and finally
compared resurrection with natural historical alternatives.

## How to read the results

Lean checks whether conclusions follow from definitions and stated premises. It
does not observe history, discover theology, or decide whether a model describes
reality. A file can use no custom Lean axioms while still carrying assumptions
inside its definitions and theorem statements.

Accordingly, this report distinguishes:

- **formally established:** Lean checked the implication inside the model;
- **countermodel established:** Lean checked that the weaker premises permit a
  case where the proposed conclusion is false;
- **bridge premise:** a stated connection between different kinds of claims;
- **historical/theological identification:** evaluated outside Lean.

## Test 1 — Does paid cost imply death?

No.

The old restoration model required a `repairCostPaid` field, but it never
defined that cost as death. We constructed:

- paid cost without death;
- death without paid cost.

Both checked. Therefore payment and death were logically independent in that
model.

## Test 2 — What happens if debt may simply be waived?

Once the rule “the debt cannot merely be waived” was removed, Lean admitted a
settlement with:

- a real obligation;
- the debt waived;
- no payment;
- no death.

This exposed the no-waiver rule as load-bearing for the payment conclusion.

## Test 3 — Can a moral mindset silently produce payment?

We supplied real harm, acknowledged truth, real obligation, and restoration,
but did not state a payment rule. Lean could not derive payment or death.

This was important: Lean has no hidden moral intuition. If a principle matters,
it must appear in the formal account. Renaming it “justice” does not make it
assumption-free.

## Test 4 — Where does moral debt come from?

We moved backward through the chain:

```text
agency + knowledge + freedom + wrongful harm
                    ↓
                culpability
                    ↓  requires a normative bridge
             duty to restore
                    ↓  if still unfulfilled
       outstanding restorative debt
```

Culpability did not automatically create a restorative duty. We had to expose
the normative bridge that culpable wrongdoing creates such a duty.

Even then, outstanding restorative debt did not entail punishment, payment, or
death.

## Test 5 — Is one-person accounting too small?

Yes. We replaced the debtor-creditor ledger with a global state containing:

- truth;
- justice;
- victims;
- offenders;
- relationships;
- communion with life.

Waiver, compensation, punishment, and forgiveness each addressed part of the
state, but none alone restored every selected dimension.

However, complete global restoration still did not imply payment or death
without another bridge.

## Test 6 — What if everyone is both victim and offender?

We created a population-wide network.

- Universal victim/offender entanglement did not itself make internal repair
  impossible.
- Preventing self-repair still allowed people to repair one another.
- An external restorer followed only when we added: “an effective restorer must
  not be an offender.”

Then we noticed that offender status had been treated as permanent. Once change
over time was allowed, an offender could change and later become an internal
restorer. That overturned the static external-restorer conclusion.

The next unresolved question became the source of that transformation.

## Test 7 — Does locality disqualify a candidate?

No. A local member of humanity could pass the global criteria if that person
actually possessed global authority, representation, capacity, and freedom
from unresolved culpability.

Our early local candidates failed because their profiles assigned those fields
as false—not because Lean proved locality itself inadequate.

Candidate X, modeled on the Christian claims about Christ, passed. But a second
candidate with the same supplied profile also passed. Structural fit did not
identify a unique historical person.

## Test 8 — Must someone die to restore the dead?

Not from authority alone.

We separated:

- authority to restore the dead;
- personally entering death;
- personally emerging from death.

A sovereign authority could restore living and dead persons without dying in
the sparse model. Personal death followed only from a participation principle:

> A representative restoring people within a condition must enter that same
> condition.

Emergence required another bridge: successful representative passage through
death must end beyond death.

## Test 9 — Authority versus representative participation

Two mechanisms remained structurally coherent:

1. **Authority:** restore the dead by sovereign power without the restorer
   dying.
2. **Participation:** share humanity, enter death, emerge alive, and carry the
   represented population through that transition.

Justice, consent, victim restoration, offender transformation, identity, and
reconciliation could be assigned successfully under either mechanism.

Shared-condition solidarity distinguished participation. Death was necessary
for the participation mechanism, not for the desired outcome considered alone.

## Test 10 — Comparison across religions

Five source lanes were represented first as blinded profiles:

- Christianity;
- Judaism;
- Islam;
- early Buddhism;
- a Bhagavad Gita/Hindu liberation lane.

The selected profiles showed:

- Christianity, Judaism, and Islam covered the common moral-relational test;
- Christianity and Islam covered judgment and bodily restoration of the dead;
- only Christianity claimed representative burden-bearing through a restorer
  who enters and overcomes death.

Islam supplied the strongest mechanism-level control: divine authority,
judgment, and resurrection without Christ's representative death. Therefore
resurrection and judgment did not logically entail atonement through death.

## Test 11 — Diagnosis and history

The evidence audit separated several levels:

### Historically strong

- Jesus existed and was executed under Pontius Pilate.
- Resurrection proclamation arose very early.
- Named followers were reported as claiming appearances.

### Disputed or inferential

- the empty tomb;
- the nature of the appearance experiences;
- bodily resurrection as the best explanation.

### Theological identifications

- Jesus is sinless;
- Jesus is divine;
- Jesus is universally authorized;
- Jesus represents humanity;
- his death accomplishes global restoration.

History can support the execution and the early proclamation. It does not, by
ordinary historical method alone, prove the complete theological identity.

## Test 12 — Resurrection versus rival explanations

The fixed evidence lane contained death, early proclamation, named appearances,
appearance diversity, rapid movement formation, and the disputed empty-tomb
tradition.

- Resurrection covered the lane if divine action was admitted.
- Visions alone did not explain an empty tomb.
- Body relocation alone did not explain appearances and resurrection belief.
- Slow legend fit poorly with early proclamation.
- Survival conflicted with the death datum.
- A composite “body relocation plus visions” hypothesis was deliberately
  permitted the same coarse coverage as resurrection.

This prevented a manufactured victory. Evidence coverage alone did not choose
between one extraordinary divine event and several coordinated natural events.
Source-level evidence, explanatory complexity, independent motivation, and
metaphysical priors remain relevant.

## What the complete experiment supports

The strongest formally controlled conclusion is:

> Generic restoration does not require death. If humanity's globally relevant
> condition is death, and if restoration requires an unfractured representative
> to participate in and carry humanity through that condition, then the
> representative must enter death; successful completion requires emergence
> beyond death.

Christianity uniquely supplies that complete representative
death-and-resurrection mechanism among the religious lanes tested. Jesus'
execution and the early resurrection proclamation are historically anchored.
The bodily resurrection and the divine, sinless, universally representative
identity remain the decisive historical-theological claims.

## What we did not prove

We did not prove:

- that God exists;
- that Christianity is true;
- that resurrection occurred;
- that death is metaphysically required for every possible restoration;
- that the religious or historical alternatives were exhaustively surveyed;
- that “no custom Lean axioms” means “no assumptions.”

## Reproducibility

Nine experimental Lean kernels contain 67 named theorems. Each was checked
directly using:

```powershell
lake env lean <kernel-file>.lean
```

Targeted source scans found no `sorry`, `admit`, `unsafe`, or custom `axiom`
declarations. The technical chronology, theorem inventory, SHA-256 snapshots,
and validation boundaries are recorded in `EXPERIMENT_LOG_2026-08-24.md`.

## Files

- `PremiseAblation.lean`
- `GlobalRestoration.lean`
- `PopulationRestoration.lean`
- `CandidateComparison.lean`
- `DeathScopeAudit.lean`
- `ReligiousComparison.lean`
- `ParticipationVsAuthority.lean`
- `ContinuityJusticeAudit.lean`
- `ResurrectionHypothesisComparison.lean`
- `RELIGIOUS_COMPARISON_EVIDENCE.md`
- `FINAL_DIAGNOSIS_HISTORY_AUDIT.md`
- `EXPERIMENT_LOG_2026-08-24.md`

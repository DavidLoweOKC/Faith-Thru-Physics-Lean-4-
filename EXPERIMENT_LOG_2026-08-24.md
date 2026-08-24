# Lean Restoration, Death, and Religious Comparison Experiment Log

**Date:** 2026-08-24

**Repository:** `D:\GitHub\Faith-Thru-Physics-Lean-4-`

**Branch at start:** `main` tracking `origin/main`

**Toolchain:** Lean 4.31.0 / Mathlib 4.31.0

**Status:** reviewed experimental checkpoint prepared for repository publication

**Validation:** nine direct Lean checks passed; proof-escape scans passed; full `lake build` passed (786 jobs)

## Purpose

The investigation began with a narrow question: did the existing Lean work
imply that somebody had to die, or only that a debt/cost had been paid? It then
expanded through premise ablation, population-wide restoration, candidate and
religious comparison, and historical resurrection hypotheses.

The governing discipline was:

- remove one premise at a time;
- do not hide premises inside definitions such as `justice`, `settled`, or
  `restored`;
- distinguish a Lean compile from a real-world conclusion;
- keep formal, theological, bridge, empirical, and historical claims separate;
- preserve countermodels even when they weaken the preferred conclusion;
- hold criteria fixed when comparing candidates or religions.

## Initial clarification

The pre-existing restoration model encoded `repairCostPaid = true` as one
conjunct of `canRestore`. It therefore proved paid cost only inside that model.
It did not define paid cost as death. The justice/mercy model also rejected
waived debt and offender payment, but did not state what payment consisted of.

Initial result:

> Paid cost did not entail death, and death did not establish paid cost.

## Experiment sequence

### 1. Premise ablation

**File:** `PremiseAblation.lean`

Removed the restoration gates separately:

- paid cost;
- external input;
- information preservation;
- open boundary.

Each removal admitted a countermodel that passed without the removed gate.
This showed that the original necessity theorems were carried by the conjunctive
definition rather than discovered independently.

Then removed the rule that debt cannot merely be waived. Lean admitted:

- debt waived;
- no payment;
- no death;
- settlement successful under the weakened rule.

Added an epistemic preload containing real harm, real obligation, acknowledged
truth, and restoration. Payment and death still did not follow. The expected
failure checks printed unsolved goals by design; the file itself passed.

Added truthful-accounting alternatives:

- broad accounting allowed payment, waiver, or outstanding liability;
- conservation accounting allowed only payment or outstanding liability.

Payment followed only from conservation accounting plus closure. This exposed
the exclusion of waiver as load-bearing.

Finally separated:

- wrongful action;
- culpability;
- duty to restore;
- outstanding restorative debt;
- punishment;
- payment;
- death.

Result: agency, knowledge, freedom, wrongful action, and real harm established
culpability by definition. A separate normative bridge was still needed to
derive a duty to restore. Outstanding restorative debt meant an unfulfilled
restorative duty and did not entail punishment, payment, or death.

### 2. Global-state correction

**File:** `GlobalRestoration.lean`

The one-offender/one-victim ledger was replaced by a world state tracking:

- truth;
- justice;
- victim restoration;
- offender transformation;
- relational reconciliation;
- communion with life.

Waiver, payment/compensation, punishment, and forgiveness offered were tested
as local operations. None alone restored every dimension in the selected
world-state model.

Critical boundary: complete global restoration still did not entail payment or
death. Loss of communion with life also did not entail an occurred death until
a life/death bridge was supplied.

### 3. Population-wide victim/offender network

**File:** `PopulationRestoration.lean`

The global model was challenged for still being effectively microscopic. A
population model made every internal person both victim and offender.

Results:

- universal victim/offender entanglement alone did not make restoration
  impossible;
- forbidding self-repair still allowed cross-repair;
- an external restorer followed only after adding the rule that an effective
  restorer must not be an offender;
- externality did not identify God or death.

The user then caught the static-status flaw: offenders can change. A dynamic
model admitted someone who begins as an offender, changes, and later becomes an
internal qualified restorer. This overturned the static external-restorer
conclusion. The source of change remained unresolved rather than discovered.

### 4. Fixed candidate comparison

**File:** `CandidateComparison.lean`

Fixed base criteria were defined before testing candidate profiles:

- belongs to the population;
- free of unresolved culpability;
- authorized;
- represents the whole population;
- has global restorative capacity;
- acts voluntarily.

Self-repair, mutual help, community cascade, transformed former offender, and
ordinary innocent third-party profiles failed as assigned. Blinded Candidate X
passed.

Anti-smuggling controls then showed:

- base global success did not entail death;
- locality alone did not force failure;
- two differently labeled candidates with the same profile both passed;
- structural fit did not uniquely identify a historical person.

The earlier local failures therefore depended on profile assignments, not on a
Lean derivation that local candidates necessarily lacked global properties.

### 5. Scope over living and dead

**File:** `DeathScopeAudit.lean`

The population was divided into living and dead conditions. Capacity to restore
the dead was separated from personal entry into death.

Results:

- authority over living and dead did not require the restorer to die;
- authority did not require personal emergence from death;
- entry followed only after adding a participation bridge;
- emergence required a second visible bridge.

### 6. Blinded religious comparison

**Files:** `ReligiousComparison.lean`,
`RELIGIOUS_COMPARISON_EVIDENCE.md`

Profiles were blinded in Lean and mapped in the evidence ledger:

- A: Christianity, Pauline death/resurrection lane;
- B: Judaism, Ezekiel 18 responsibility/repentance lane;
- C: Islam, Quranic responsibility/mercy/resurrection lane;
- D: early Buddhism, Four Noble Truths lane;
- E: Bhagavad Gita surrender/liberation lane.

Ambiguous internal variation was retained as `partialSupport`, `disputed`,
`notCentral`, `rejected`, or `open` rather than forced to false.

Results under the selected profiles:

- A, B, and C covered the common moral-relational test;
- A and C covered the selected judgment/bodily-restoration test;
- only A claimed representative burden-bearing through a restorer who enters
  and overcomes death;
- C demonstrated that judgment and bodily resurrection did not entail a
  representative death mechanism.

This distinguished mechanisms but did not prove any religion true.

### 7. Authority versus participation

**File:** `ParticipationVsAuthority.lean`

Two rival mechanisms were compared against one restored outcome:

1. sovereign authority restores without entering death;
2. a representative shares the population's condition, enters death, emerges,
   and carries the united population through the transition.

Both were structurally coherent. Death was necessary for representative
continuity, not for the shared observable outcome alone.

### 8. Justice, agency, identity, and solidarity

**File:** `ContinuityJusticeAudit.lean`

Authority-only and participation models were both allowed to satisfy:

- truth;
- victim restoration;
- justice;
- offender transformation;
- consent;
- personal identity;
- reconciliation.

Those safeguards did not select between mechanisms. Shared-condition
solidarity selected participation. Even solidarity did not entail bodily death
until the same-condition bridge explicitly required entry into the population's
death condition.

### 9. Diagnosis and historical identification

**File:** `FINAL_DIAGNOSIS_HISTORY_AUDIT.md`

Claim-level calibration:

- universal biological mortality: empirically supported;
- sin and death as one integrated reign: Christian theological diagnosis;
- Jesus' execution under Pontius Pilate: historically strong;
- very early resurrection proclamation and reported appearances: historically
  strong as belief/testimony;
- empty tomb: historically disputed;
- bodily resurrection: contested historical/metaphysical inference;
- sinlessness, divinity, universal authority, and global representation:
  theological identifications, not ordinary historical findings.

### 10. Resurrection rival hypotheses

**File:** `ResurrectionHypothesisComparison.lean`

Fixed evidence lanes:

- execution/death;
- early raised-Jesus proclamation;
- named appearance tradition;
- appearance diversity;
- empty-tomb tradition;
- rapid movement formation.

Results:

- resurrection covered the full selected lane if divine action was admitted;
- visions alone did not cover an empty tomb;
- body relocation alone did not cover appearances and resurrection belief;
- slow legend fit poorly with early proclamation;
- survival conflicted with confirmed death;
- a composite relocation-plus-visions hypothesis was deliberately allowed the
  same coarse coverage as resurrection.

Coverage alone therefore did not uniquely select resurrection. The remaining
comparison concerns source-level fit, independent evidence, complexity, and
metaphysical priors.

## User corrections that materially changed the work

1. **The original repo-location assumption was stale.** The live work was
   found under `D:\GitHub\Faith-Thru-Physics-Lean-4-`, with related material on
   `C:\theophysics`.
2. **“The debt can be waived” was removed.** This eliminated payment and death
   from the weakened settlement model.
3. **The debt itself had been preloaded.** The model was moved backward from
   harm to culpability to restorative duty to outstanding debt.
4. **The global model was still local.** It was replaced with a population-wide
   victim/offender network.
5. **Offender status was treated as static.** Adding change allowed an internal
   person to become a later qualified restorer.
6. **Locality was treated as disqualifying.** An anti-smuggling countermodel
   showed a local candidate could pass if genuinely globally qualified.
7. **Religious comparison risked Christian scoring criteria.** Separate common
   moral, eschatological, and representative-death evaluators were added.
8. **Weak natural alternatives risked a manufactured resurrection victory.** A
   composite natural hypothesis was granted full coarse coverage.

## Strongest supported conclusion

Generic restoration does not entail death. Authority over death can be modeled
without the restorer dying. If humanity's globally relevant condition is death
and restoration requires representative same-condition participation, then the
representative must enter death; if the representative carries the population
through that condition, emergence beyond death is required.

Christianity uniquely supplies this representative death-and-resurrection
mechanism among the compared source lanes. Jesus' execution and the very early
resurrection proclamation are historically anchored. The bodily resurrection,
divine identity, sinlessness, universal authority, and representative role
remain the decisive historical-theological inferences.

## What was not established

- Lean did not prove God, Christianity, the Resurrection, or atonement true.
- `#print axioms` reporting no custom axioms did not mean there were no
  assumptions; definitions and theorem statements carried commitments.
- No exhaustive survey of every religion, denomination, atonement theory, or
  historical hypothesis was completed.
- No probability calculation was justified.
- Repository publication records the experiment; it does not promote the
  conditional findings into canonical theological or historical conclusions.
- The full build emitted existing linter warnings and intentional
  `#check_failure` diagnostics; it completed successfully.

## Validation record

Nine new Lean kernels were directly checked and passed:

1. `PremiseAblation.lean`
2. `GlobalRestoration.lean`
3. `PopulationRestoration.lean`
4. `CandidateComparison.lean`
5. `DeathScopeAudit.lean`
6. `ReligiousComparison.lean`
7. `ParticipationVsAuthority.lean`
8. `ContinuityJusticeAudit.lean`
9. `ResurrectionHypothesisComparison.lean`

Across these files there are 67 named `theorem` declarations. Targeted scans
found no source occurrences of `sorry`, `admit`, `unsafe`, or custom `axiom`
declarations. Some expected-failure diagnostics printed generated `sorry` text
while demonstrating intentionally unprovable implications; the source scan was
clean.

Final serial project validation:

```text
lake build
Build completed successfully (786 jobs).
```

### SHA-256 snapshot

```text
B20A4386882BF2EA774A2C3322EDADC4710A884BCC08FCB9BD56C8EB10AE692A  PremiseAblation.lean
D08C33DDFF7B383EF07588397F5CB0879BC32B01C6B3BF7A78A6F2D1C894616E  GlobalRestoration.lean
B8E243C95926B6F44F3C32DC6092C1C65CFA4D488A30683D222C1F7E68EAA524  PopulationRestoration.lean
11303779A92C0BC1AE4FFB97BE4752520B344B3C0EE75B392FB47CBF13EA8263  CandidateComparison.lean
2659A8C471DB9839E68B89D8AFAB5AF3ED2ABF83EDB156D3387EFC51E23EFF3F  DeathScopeAudit.lean
9C0BF5D70D71EC4616E867C8136D32D05E7156F654621919D1802B17CAF5634B  ReligiousComparison.lean
5293FD416199FD9ABC395E1EFB4F40465E42907EEE75BE87A0249A9B23543915  ParticipationVsAuthority.lean
3B8633A41B3EB091A25137B8430C43871282F5655FD8947BB227AB69404C9E71  ContinuityJusticeAudit.lean
E3DC0AC4CF38D283A13D38F08C0A0CD389BBD9F9A221D30989DEE86BACA4777F  ResurrectionHypothesisComparison.lean
```

## Remaining work

1. Perform source-level explanatory-cost analysis for resurrection versus the
   composite relocation-plus-visions hypothesis.
2. Adjudicate each religious profile with specialists or denomination-specific
   primary sources before treating the matrix as final.
3. Decide whether representative solidarity is independently necessary or a
   specifically Christian disclosed mechanism.
4. Expand historical source-level comparison without converting attestation
   into theological proof.

/-!
# ResurrectionFormal.StageMachine

A first-pass finite state machine for the paper's operation sequence.

This is intentionally modest. The file proves facts about the ordering of the
stages; it does not claim that the physics or theology has been established.
-/

namespace ResurrectionFormal

inductive Stage where
  | preLocalization
  | localization
  | stabilization
  | release
  | confirmation
  | redistribution
deriving DecidableEq, Repr

inductive StageStep : Stage → Stage → Prop where
  | beginLocalization :
      StageStep Stage.preLocalization Stage.localization
  | stabilize :
      StageStep Stage.localization Stage.stabilization
  | release :
      StageStep Stage.stabilization Stage.release
  | confirm :
      StageStep Stage.release Stage.confirmation
  | redistribute :
      StageStep Stage.confirmation Stage.redistribution

inductive StageReaches : Stage → Stage → Prop where
  | refl (s : Stage) :
      StageReaches s s
  | tail {a b c : Stage} :
      StageStep a b → StageReaches b c → StageReaches a c

theorem reaches_localization_from_pre :
    StageReaches Stage.preLocalization Stage.localization := by
  apply StageReaches.tail
  · exact StageStep.beginLocalization
  · exact StageReaches.refl _

theorem reaches_redistribution_from_pre :
    StageReaches Stage.preLocalization Stage.redistribution := by
  apply StageReaches.tail
  · exact StageStep.beginLocalization
  apply StageReaches.tail
  · exact StageStep.stabilize
  apply StageReaches.tail
  · exact StageStep.release
  apply StageReaches.tail
  · exact StageStep.confirm
  apply StageReaches.tail
  · exact StageStep.redistribute
  · exact StageReaches.refl _

theorem no_stage_step_back_to_pre_from_localization :
    ¬ StageStep Stage.localization Stage.preLocalization := by
  intro h
  cases h

theorem no_stage_step_back_to_release_from_confirmation :
    ¬ StageStep Stage.confirmation Stage.release := by
  intro h
  cases h

theorem no_stage_step_back_to_confirmation_from_redistribution :
    ¬ StageStep Stage.redistribution Stage.confirmation := by
  intro h
  cases h

end ResurrectionFormal

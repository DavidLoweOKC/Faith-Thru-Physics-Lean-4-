/-!
# ResurrectionFormal.Mapping

A toy correspondence between the paper's physics-side operation names and
theology-side event names.

This is not yet category theory. It is a deliberately small order-preservation
test: if the physics sequence is mapped operation-by-operation, Lean verifies
that it becomes the stated theology sequence.
-/

namespace ResurrectionFormal

inductive PhysicsOp where
  | localization
  | stabilization
  | release
  | confirmation
  | redistribution
deriving DecidableEq, Repr

inductive TheologyEvent where
  | incarnation
  | lifeAndTemptation
  | crucifixion
  | resurrection
  | pentecost
deriving DecidableEq, Repr

def eventOfPhysicsOp : PhysicsOp → TheologyEvent
  | PhysicsOp.localization => TheologyEvent.incarnation
  | PhysicsOp.stabilization => TheologyEvent.lifeAndTemptation
  | PhysicsOp.release => TheologyEvent.crucifixion
  | PhysicsOp.confirmation => TheologyEvent.resurrection
  | PhysicsOp.redistribution => TheologyEvent.pentecost

def physicsSequence : List PhysicsOp :=
  [ PhysicsOp.localization
  , PhysicsOp.stabilization
  , PhysicsOp.release
  , PhysicsOp.confirmation
  , PhysicsOp.redistribution
  ]

def theologySequence : List TheologyEvent :=
  [ TheologyEvent.incarnation
  , TheologyEvent.lifeAndTemptation
  , TheologyEvent.crucifixion
  , TheologyEvent.resurrection
  , TheologyEvent.pentecost
  ]

theorem map_physics_sequence_is_theology_sequence :
    physicsSequence.map eventOfPhysicsOp = theologySequence := by
  rfl

theorem localization_maps_to_incarnation :
    eventOfPhysicsOp PhysicsOp.localization = TheologyEvent.incarnation := by
  rfl

theorem confirmation_maps_to_resurrection :
    eventOfPhysicsOp PhysicsOp.confirmation = TheologyEvent.resurrection := by
  rfl

end ResurrectionFormal

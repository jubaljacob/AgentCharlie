// Random exploration decision maker
+!decision_maker : state(State) &
    State == explore <-

    .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir);
    !action(move, Dir).

// Look for nearest dispenser
+!decision_maker : state(State) &
    State == explore & 
    location(dispenser, _, X, Y) <-

    +target_dispenser(X, Y);
    -+state(move_to_dispenser).
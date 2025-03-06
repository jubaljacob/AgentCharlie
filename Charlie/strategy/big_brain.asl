// Random exploration decision maker
+!decision_maker : state(State) &
    State == explore <-

    .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir);
    !action(move, Dir).

// Look for nearest dispenser
+!decision_maker : state(State) &
    State == explore & 
    not(block(_)) &
    location(dispenser, _Type, _, _) <-

    !find_nearest_dispenser(0, 0, Xd, Yd, _Type);
    +target_dispenser(_Type, Xd, Yd);
    -+state(move_to_dispenser);
    !decision_maker.

// Look for nearest goal
+!decision_maker : state(State) & 
    State == explore &
    block(_) &
    target_dispenser(_Type, X, Y) <- 

    !find_nearest_goal(0, 0, Xg, Yg);
    +target_goal(Xg, Yg);
    -+state(move_to_goal);
    !decision_maker.

// Move to nearest dispenser
+!decision_maker : state(State) & 
    State == move_to_dispenser &
    target_dispenser(_Type, X, Y) <- 

    DispenserX = math.abs(X);
    DispenserY = math.abs(Y);

    // When agent is adjacent to dispenser
    if ( (DispenserX == 1 & DispenserY == 0) || (DispenserX == 0 & DispenserY == 1) ) {
        -+state(request_block);
        !decision_maker;
    }
    // Agent moves X then moves Y to dispenser
    else {
        if (math.abs(X) > 0) {
            if (X > 0) { 
                -+target_dispenser(X-1,Y);
                !action(move, e);
            }
            else {
                -+target_dispenser(X+1,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0) {
            if (Y > 0) {
                -+target_dispenser(X,Y-1);
                !action(move, s);
            }
            else {
                -+target_dispenser(X,Y+1);
                !action(move, n);
            }
        }
        else {
            // If the agent is on top of dispenser
            -+target_dispenser(X,Y+1);
            !action(move, n);
        }

        // !action(move, Dir);
    }.

// State 2 -4



// Agent search for goal position
+!decision_maker : state(State) & 
    State == move_to_goal &
    target_goal(X, Y) <- 

    GoalX = math.abs(X);
    GoalY = math.abs(Y);

    // When agent is on the goal
    if ( (GoalX == 0 & GoalY == 0) ) {
        -+state(submit_goal);
        !decision_maker;
    }
    else {
        if (math.abs(X) > 0) {
            if (X > 0) { 
                -+target_dispenser(X-1,Y);
                !action(move, e);
            }
            else {
                -+target_dispenser(X+1,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0) {
            if (Y > 0) {
                -+target_dispenser(X,Y-1);
                !action(move, s);
            }
            else {
                -+target_dispenser(X,Y+1);
                !action(move, n);
            }
        }
    }

// WIP: Check if agent IS REALLY at the goal position

// Agent search for goal position
// +!decision_maker : state(State) & 
//     State == submit_goal &
//     target_goal(X, Y) <- 


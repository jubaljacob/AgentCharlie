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

// Look for nearest goal when agent carries block
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
    if ( (DispenserX == 1 & DispenserY == 0) | (DispenserX == 0 & DispenserY == 1) ) {
        -+state(request_block);
        !decision_maker;
    }
    // Agent moves X then moves Y to dispenser
    else {
        if (x == 0 | y == 0) {
            !convert_move_axis;
        }

        ?move_axis(Axis);
        if (math.abs(X) > 0 & Axis == x) {
            if (X > 0) { 
                -+target_dispenser(X-1,Y);
                !action(move, e);
            }
            else {
                -+target_dispenser(X+1,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0 && Axis == y) {
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
// Request block from dispenser
+!decision_maker : state(State) & 
    State == request_block &
    target_dispenser(Type, X, Y) <- 
    
    // Check if agent is adjacent to dispenser
    if ((math.abs(X) == 1 & Y == 0) | (math.abs(Y) == 1 & X == 0)) {
        // Determine direction to request block based on dispenser position
        if (X == -1 & Y == 0) {
            +dir(e);  // East
            !action(request, e);
            -+state(attach_block);
        } 
        elif (X == 1 & Y == 0) {
            +dir(w);  // West
            !action(request, w);
            -+state(attach_block);
        } 
        elif (X == 0 & Y == 1) {
            +dir(s);  // South
            !action(request, s);
            -+state(attach_block);
        } 
        elif (X == 0 & Y == -1) {
            +dir(n);  // North
            !action(request, n);
            -+state(attach_block);
        }
        else {
            -+state(move_to_dispenser);
        }
    }
    else {
        // If not adjacent to dispenser, go back to finding dispenser
        -+state(move_to_dispenser);
    }
    !decision_maker.

// Attach block after request
+!decision_maker : state(State) & 
    State == attach_block &
    dir(Direction) <- 
    
    // Perform attach action based on direction
    if (Direction == n) {
        !action(attach, n);
    } 
    elif (Direction == s) {
        !action(attach, s);
    } 
    elif (Direction == e) {
        !action(attach, e);
    } 
    elif (Direction == w) {
        !action(attach, w);
    }
    
    // Remove direction belief and move to next state
    -dir(Direction);
    -+state(rotate_block);
    !decision_maker.

// Rotate block after attaching
+!decision_maker : state(State) & 
    State == rotate_block &
    rotation(Rotation) <- 
    
    // Rotate clockwise or counter-clockwise 
    if (not Rotation) {
        !action(rotate, cw);
    } 
    else {
        !action(rotate, ccw);
    }
    
    // Update attachment count
    ?attached(Count);
    -+attached(Count+1);
    
    // Check if we've attached enough blocks
    if (Count+1 > 3) {
        -+state(move_to_goal);
    } 
    else {
        -+state(request_block);
    }
    
    !decision_maker.

// Initialize rotation and attached count if they don't exist
+!init_block_beliefs : true <-
    +rotation(false);
    +attached(0).



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
        ?move_axis(Axis);
        if (math.abs(X) > 0 & Axis == x) {
            if (X > 0) { 
                -+target_dispenser(X-1,Y);
                !action(move, e);
            }
            else {
                -+target_dispenser(X+1,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0 Axis == y) {
            if (Y > 0) {
                -+target_dispenser(X,Y-1);
                !action(move, s);
            }
            else {
                -+target_dispenser(X,Y+1);
                !action(move, n);
            }
        }
    }.

// WIP: Check if agent IS REALLY at the goal position

// Agent search for goal position
+!decision_maker : state(State) & 
    State == submit_goal &
    block(Type) &
    free_task(Task, _, _, X, Y, Type) &
    target_goal(X, Y) <- 

    !find_nearest_goal(0, 0, Xg, Yg);

    // Find the blocks that the agent has
    !find_agent_block(Dirs, _BlockNumber);
    // Find Task that matches the current hold direction
    !find_task_block_dir(Dirs, Task);
    if (Xg == 0 && Yg == 0) {
        // When agent is on goal and has an task that fits the direction of the block, submit. Otherwise, rotate clockwise
        if(not(Task == null)) {
            !action(submit, Task);
        }
        else {
            ?rotate_dir(RotateDir);
            !action(rotate, RotateDir);
        }
    } 
    else {
        // When agent is not on top of the goal, that says if agent is on top, nearest should be 0,0
        // Change the state to explore to trigger the agent to move_to_goal when agent carries a block
        -+state(explore);
    }.
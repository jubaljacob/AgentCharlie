// Look for nearest dispenser
+!decision_maker : state(State) &
    State == explore & 
    attached(Blocks) & 
    Blocks == 0 &
    location(dispenser, Type, Xd, Yd) <-
    .print("State1");

    // !find_nearest_dispenser(0, 0, Xd, Yd, _Type);
    +targetType(Type);
    +target_dispenser(Xd, Yd);
    -+state(move_to_dispenser);
    !decision_maker.

// Look for nearest goal with blocks carried, but if found other agent near goal, move away
// +!decision_maker : state(State) &
//     State == explore & 
//     (location(entity,_,X_ag,Y_ag) & (math.abs(X_ag) + math.abs(Y_ag) < 3) )&
//     location(goal,_,Xg,Yg) &
//     (math.abs(X_ag-Xg) >= 1 | math.abs(Y_ag-Yg) >= 1) &
//     attached(Blocks) & 
//     Blocks > 0 <- 
//     .print("State2");

//     // If agent found agent 1 distance away from agent/goal, activate contigency plan
//     !call_for_backup(explore).

// Look for nearest goal with blocks carried, but if other agent is near me, move away
+!decision_maker : state(State) &
    State == explore & 
    location(entity,_,X_ag,Y_ag) &
    (math.abs(X_ag) >= 1 | math.abs(Y_ag) >= 1) &
    attached(Blocks) & 
    Blocks > 0 <- 
    .print("State3");

    // If agent found agent 1 distance away from agent/goal, activate contigency plan
    !call_for_backup(explore).

// Look for nearest goal when agent carries block
+!decision_maker : state(State) & 
    State == explore &
    location(goal, null, Xg, Yg) & 
    attached(Blocks) & 
    Blocks > 0 <- 
    .print("State4");

    // !find_nearest_goal(0, 0, Xg, Yg);
    +target_goal(Xg, Yg);
    -+state(move_to_goal);
    !decision_maker.

// Random exploration decision maker
+!decision_maker : state(State) &
    State == explore <-
    // .print("State5");

    !move_random(Dir);
    !action(move, Dir).

// Contigency move 5 steps away, 1 step already taken in exception handler
+!decision_maker : state(State) &
    State == contigency & 
    contigency(PrevState, RemainingSteps) <- 
    // .print("State6");

    ?lastActionParams([Direction])[_];

    // Update of remaining step and move
    if (RemainingSteps >= 0) {
        -+contigency(PrevState, RemainingSteps-1);
        !action(move, Direction);
    }
    // When remaining step == 0, change the agent's state back to previous step
    else {
        -contigency(_, _);
        -+state(PrevState);
        !decision_maker;
    }.

// Move to nearest dispenser
+!decision_maker : state(State) & 
    State == move_to_dispenser &
    target_dispenser(X, Y) <- 
    .print("State7");

    // .print("Sensed ", Xt, ", ", Yt);
    // .print("Target ", X, ", ", Y);
    // DispenserX = math.abs(X);
    // DispenserY = math.abs(Y);

    if (X == 0 & Y == 0) {
        // If the agent is on top of dispenser
        NewY = Y + 1;
        -+target_dispenser(X,NewY);
        !action(move, n);
    }
    // When agent is adjacent to dispenser
    if ( (math.abs(X) == 1 & Y == 0) | (X == 0 & math.abs(Y) == 1) ) {
        -+state(request_block);
        !decision_maker;
    }
    // Agent moves X then moves Y to dispenser
    else {
        // if (X == 0 | Y == 0) {
        //     !convert_move_axis;
        // }

        // ?move_axis(Axis);
        if (math.abs(X) > 0) {
            if (X > 0) { 
                NewX = X - 1;
                -+target_dispenser(NewX,Y);
                !action(move, e);
            }
            elif(X < 0) {
                NewX = X + 1;
                -+target_dispenser(NewX,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0) {
            if (Y > 0) {
                NewY = Y - 1;
                -+target_dispenser(X,NewY);
                !action(move, s);
            }
            elif (Y < 0) {
                NewY = Y + 1;
                -+target_dispenser(X,NewY);
                !action(move, n);
            }
        }
        else {
            // If the agent is on top of dispenser
            NewY = Y + 1;
            -+target_dispenser(X,NewY);
            !action(move, n);
        }
    }.

// State 2 -4
// Request block from dispenser
+!decision_maker : state(State) & 
    State == request_block &
    target_dispenser(X, Y) <- 
    .print("State8");

    // -target_dispenser(X,Y);
    
    // Check if agent is adjacent to dispenser
    if ((math.abs(X) == 1 & Y == 0) | (math.abs(Y) == 1 & X == 0)) {
        // Determine direction to request block based on dispenser position
        if (X == -1 & Y == 0) {
            +dir(e);  // East
            -+state(attach_block);
            !action(request, e);
            
        } 
        elif (X == 1 & Y == 0) {
            +dir(w);  // West
            -+state(attach_block);
            !action(request, w);
            
        } 
        elif (X == 0 & Y == 1) {
            +dir(s);  // South
            -+state(attach_block);
            !action(request, s);
            
        } 
        elif (X == 0 & Y == -1) {
            +dir(n);  // North
            -+state(attach_block);
            !action(request, n);
            
        }
    }
    else {
        // If not adjacent to dispenser, go back to finding dispenser
        -+state(move_to_dispenser);
        !decision_maker;
    }.

// Attach block after request
+!decision_maker : state(State) & 
    State == attach_block &
    dir(Direction) & 
    attached(Count) <- 
    .print("State9");

    // Remove direction belief and move to next state
    -dir(Direction);
    -+state(request_rotate);
    
    // // Update attachment count
    // -+attached(Count+1);

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
    }.

// Rotate block after attaching
+!decision_maker : state(State) & 
    State == request_rotate &
    rotate_dir(Rotation) <- 
    .print("State10");
    
    ?attached(Count);
    // Check if we've attached enough blocks
    if (Count > 3) {
        -target_dispenser(X,Y);
        -+state(explore);
        !decision_maker;
    } 
    else {
        -+state(request_block);
        // Rotate clockwise or counter-clockwise 
        !action(rotate, Rotation);
    }.

// Agent search for goal position
+!decision_maker : state(State) & 
    State == move_to_goal &
    target_goal(X, Y) <- 
    .print("State11");

    if (X == 0 & Y == 0) {
        -+state(submit_goal);
        !decision_maker;
    }
    // When agent is adjacent to dispenser
    if ( (math.abs(X) == 1 & Y == 0) | (X == 0 & math.abs(Y) == 1) ) {
        if (math.abs(X) == 1) {
            if (X == 1) {
                NewX = X - 1;
                -+target_goal(NewX,Y);
                !action(move, e);
            }
            elif (X == -1) {
                NewX = X + 1;
                -+target_goal(NewX,Y);
                !action(move, w);
            }
        }
        if (math.abs(Y) == 1) {
            if (Y == 1) {
                NewY = Y - 1;
                -+target_goal(X,NewY);
                !action(move, s);
            }
            elif (Y == -1) {
                NewY = Y + 1;
                -+target_goal(X,NewY);
                !action(move, n);
            }
        }
    }
    // Agent moves X then moves Y to goal
    else {
        if (math.abs(X) > 0) {
            if (X > 0) { 
                NewX = X - 1;
                -+target_goal(NewX,Y);
                !action(move, e);
            }
            elif(X < 0) {
                NewX = X + 1;
                -+target_goal(NewX,Y);
                !action(move, w);
            }
        }
        elif (math.abs(Y) > 0) {
            if (Y > 0) {
                NewY = Y - 1;
                -+target_goal(X,NewY);
                !action(move, s);
            }
            elif (Y < 0) {
                NewY = Y + 1;
                -+target_goal(X,NewY);
                !action(move, n);
            }
        }
        else {
            // If the agent is on top of dispenser
            -+state(submit_goal);
            !decision_maker;
        }
    }.

    // // When agent is on the goal
    // if ( (X == 0 & Y == 0) ) {
    //     -+state(submit_goal);
    //     !decision_maker;
    // }
    // else {
    //     if (math.abs(X) > 0) {
    //         if (X > 0) { 
    //             NewX = X - 1;
    //             -+target_goal(NewX,Y);
    //             !action(move, e);
    //         }
    //         elif (X < 0) {
    //             NewX = X + 1;
    //             -+target_goal(NewX,Y);
    //             !action(move, w);
    //         }
    //     }
    //     elif (math.abs(Y) > 0) {
    //         if (Y > 0) {
    //             NewY = Y - 1;
    //             -+target_goal(X,NewY);
    //             !action(move, s);
    //         }
    //         elif (Y < 0) {
    //             NewY = Y + 1;
    //             -+target_goal(X,NewY);
    //             !action(move, n);
    //         }
    //     }
    // }.

// Agent search for goal position
+!decision_maker : state(State) & 
    State == submit_goal &
    // block(Type) &
    attached(Count) & 
    Count > 0 &
    targetType(Type) &
    free_task(Task, _, _, _X, _Y, Type) &
    target_goal(Xg, Yg) <- 
    .print("State12");

    // !find_nearest_goal(0, 0, Xg, Yg);

    // // Find the blocks that the agent has
    // !find_agent_block(Dirs, _BlockNumber);
    // // Find Task that matches the current hold direction
    // !find_task_block_dir(Dirs, Task);
    

    // .print("Goal: ", Xg, Yg);
    if (Xg == 0 & Yg == 0) {
        !action(submit, Task);
        // // When agent is on goal and has an task that fits the direction of the block, submit. Otherwise, rotate clockwise
        // if(not(Task == null)) {
        //     .print("Submitting Task");
        //     // Remove task and submit
        //     // -free_task(Task,_,_,_,_,_);
        //     !action(submit, Task);
        // }
        // else {
        //     ?rotate_dir(RotateDir);
        //     !action(rotate, RotateDir);
        // }
    } 
    else {
        // When agent is not on top of the goal, that says if agent is on top, nearest should be 0,0
        // Change the state to explore to trigger the agent to move_to_goal when agent carries a block
        -targetType(Type);
        -+state(explore);
    }.
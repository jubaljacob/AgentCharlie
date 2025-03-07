// If move to goal fails more than twice, go contigency plan and move 5 steps away from this BAD goal
+!failure_handler(move, _Result, _Direction) : state(submit_goal) & 
    failed_attempt(Attempt) & 
    Attempt > 2 <- 

    -target_goal(X,Y);
    -+state(contigency);
    !call_for_backup(explore).

// If move action failed, move 90 perpendicular
+!failure_handler(move, _Result, Direction) <-
    
    if (Direction == n | Direction == s) {
        .random(R);
        if (R < 0.5) {
            !action(move, e);
        } else {
            !action(move, w);
        }
    } else {
        .random(R);
        if (R < 0.5) {
            !action(move, n);
        } else {
            !action(move, s);
        }
    }.


// If at requesting block, but rotation failed more than once, look for goal
+!failure_handler(rotate, _Result, _Direction) : state(request_block) & 
    failed_attempt(Attempt) & 
    Attempt > 1 <- 

    -target_dispenser(X,Y);
    -+state(explore).

// If rotate at goal fails more than once, go contigency plan and move 5 steps away from this BAD goal
+!failure_handler(rotate, _Result, _Direction) : state(submit_goal) & 
    failed_attempt(Attempt) & 
    Attempt > 1 <- 

    -target_goal(X,Y);
    -+state(contigency);
    !call_for_backup(explore).

// If rotate fails in any situation, rotate other direction, and change rotating behaviour
+!failure_handler(rotate, _Result, Direction) <-
    if (Direction == cw) {
        -+rotate_dir(ccw);
        !action(rotate, ccw);
    }
    elif (Direction == ccw) {
        -+rotate_dir(cw);
        !action(rotate, cw);
    }.

// If request failed, agent has blocks, move 5 steps away, then switch to look for goal
+!failure_handler(request, failed_blocked, _Param) : attached(Blocks) & 
    Blocks > 0 <- 

    -dir(_);
    -target_dispenser(X,Y);
    -+state(contigency);
    !call_for_backup(explore).

// If request failed, agent does not have blocks carried, request again
+!failure_handler(request, failed_blocked, _Param) : attached(Blocks) & 
    Blocks == 0 <- 
    -+state(request_block);
    -dir(_);
    !decision_maker.

// If request failed, agent move 5 steps away, giving up the dispenser
+!failure_handler(request, failed_target, _Param) <- 
    -dir(_);
    -target_dispenser(_X,_Y);
    -+state(contigency);
    !call_for_backup(explore).

// If submit failed because no task is invalid, search again for task and submit
// +!failire_handler(submit, failed_target, _Param) <- 
//     -+state(submit_goal);
//     !decision_maker.
+!failure_handler(submit, _Failure, _Param) : rotate_dir(RotateDir) <-
    -+state(submit_goal);
    !action(rotate, RotateDir).

// If attach fails, because nothing to attach, request a block again [failed_target]
+!failure_handler(attach, failed_target, _Param) <-
    -+state(request_block);
    -dir(_);
    !decision_maker.

// If attach fails, because held by other agent, check if agent attached something, if do, moves 5 steps away from dispenser then look for goal
+!failure_handler(attach, failed, _Param) : attached(Blocks) & 
    Blocks > 0 <- 

    -target_dispenser(X,Y);
    -+state(contigency);
    !call_for_backup(explore).

// If attach fails, because held by other agent, check if agent attached something, if not, request again
+!failure_handler(attach, failed, _Param) : attached(Blocks) & 
    Blocks == 0 <- 

    -+state(request_block);
    !decision_maker.

// Convert the moving axis 
// Condition 1: When agent move in x axis, but when target x = 0, then change move axis to y
// Condition 2: When agent move in y axis, but stucked, agent moves 90 degree perpendicular frm failure handler then, attempt to move in y axis
@convert_move_axis[atomic]
+!convert_move_axis <- 
    // If previous moving axis follows from x first then y, then change to move by y first then x
    ?move_axis(Axis);
    if (Axis == x) {
        -+move_axis(y);
    }
    else {
        -+move_axis(x);
    }.

+!call_for_backup(PrevState) <- 
    -+state(contigency);
    +contigency(PrevState, 5);
    
    !move_random(Dir);
    !action(move, Dir).
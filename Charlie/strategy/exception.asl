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
    

// If at requesting block, but rotation failed, straight change state to move to goal?
+!failure_handler(rotate, _Result, Direction) : state(request_block) <- 
    -+state(explore).

// If request failed, make belief to rotate otherwise





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
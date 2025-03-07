// If move action failed, move 90 perpendicular, then change belief to go another axis so agent behave on diff move strategy
+!failure_handler(move, _Result, Direction) <-
    !convert_move_axis;
    
    if (Direction == n) {
        !action(move, w);
    } 
    elif (Direction == s) {
        !action(move, e);
    }
    elif (Direction == e) {
        !action(move, n);
    }
    elif (Direction == w) {
        !action(move, s);
    }.
    

// If at requesting block, but rotation failed, straight change state to move to goal?
+!failure_handler(rotate, _Result, Direction) : state(request_block) <- 
    -+state(explore).

// If request failed, make belief to rotate otherwise





// Convert the moving axis
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
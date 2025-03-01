// Move action that tends to be prioritized so agent always consider to move first
@move[atomic]
+!move(Dir) : 
    position(X_self, Y_self) & 
    check_direction(X, Y, Dir) <- 

    move(Dir);
    -+position((X_self+X), (Y_self+Y)).

// Move to goal when provided with agent's position, it still retrieves possible direction to move
@move_to_goal
+!move_to_goal(X, Y): 
    position(X_self, Y_self) & 
    to_goal_direction((X-X_self), (Y-Y_self), Dir) &
    check_direction(NewX, NewY, Dir) & 
    active_task(Name, _, _, X_Task, Y_Task, Type) <-

    if (Dir == null) { !rotate_direction(Name, X_Task, -Y_Task, Type); }
    else { !move(Dir); }.


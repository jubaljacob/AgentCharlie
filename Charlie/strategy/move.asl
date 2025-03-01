// Move action that tends to be prioritized so agent always consider to move first
@move[atomic]
+!move(Dir) : 
    agent_pos(X_self, Y_self) & 
    check_direction(X, Y, Dir) <- 

    move(Dir);
    -+agent_pos((X_self+X), (Y_self+Y)).

// Move to goal when provided with agent's position, it still retrieves possible direction to move
@move_to_goal
+!move_to_goal(X, Y): 
    agent_pos(X_self, Y_self) & 
    to_goal_direction((X-X_self), (Y-Y_self), Dir) &
    check_direction(NewX, NewY, Dir) & 
    active_task(Name, _, _, X_Task, Y_Task, Type) <-

    if (Dir == null) { !rotate_direction(Name, X_Task, -Y_Task, Type); }
    else { !move(Dir); }.

// Move to dispenser using agent's position to determine if there is possible new direcrion to move
@move_to_dispenser
+!move_to_dispenser(X, Y, Type): 
    agent_pos(X_self, Y_self) & 
    to_dispenser_direction((X-X_self), (Y-Y_self), Dir) &
    not(Dir = null) <-
    
	!move(Dir).

// If move to dispenser fails
-!move_to_dispenser(X,Y,Type) : 
    self_location(X_self, Y_self) <-

    !explore.

// When agent is adjacent to dispenser, initiate request
@move_to_dispenser_request
+!move_to_dispenser(X, Y, Type) : 
    agent_pos(X_self, Y_self) & 
    to_dispenser_direction((X-X_self), (Y-Y_self), null) <- 
    
	!request_from_dispenser(X, Y, Type).

// If agent is adjacent to the dispenser, but direction is not free, rotate agent and try request
@request_from_dispenser_rotate
+!request_from_dispenser(X, Y, Type) : 
    agent_pos(X_self, Y_self) &
    check_direction((X-X_self), (Y-Y_self), Dir) &
    not obstacle((X-X_self), (Y-Y_self)) &
    not(free_direction(Dir)) &
    free_direction(Free_Dir) &
    not (Free_Dir = Dir) &
    rotating_dir(Dir, Free, R_Action) <-

    rotate(R_Action);
    !update_block_rotation(R_Action);
    !request_from_dispenser(X, Y, Type).

// Request block from dispenser if adjacent direction is free, then add to mapper
@request_from_dispenser_free
+!request_from_dispenser(X, Y, Type) : 
    agent_pos(X_self, Y_self) &
    check_direction((X-X_self), (Y-Y_self), Dir) &
    not obstacle((X-X_self), (Y-Y_self)) &
    free_direction(Dir) <-

    request(Dir);
    !attach_to_block(Dir).

// Attach block if the desired block type is already at the dispenser
@request_from_dispenser_block_exist
+!request_from_dispenser(X, Y, Type) : 
    agent_pos(X_self, Y_self) &
    check_direction((X-X_self), (Y-Y_self), Dir) &
    thing((X-X_self), (Y-Y_self), block, Type) & 
    free_direction(Dir) <-

    !attach_to_block(Dir).

// When a block is attached, add to belief that a block is with the agent (direction now not free) and agent changes to goal state.
@attach_to_block
+!attach_to_block(Dir) <-

    attach(Dir);
    +block(Dir, Type);
    -free_direction(Dir);
    -+state(goal_state).

// If attach block fails, sleep for 0.2 seconds and attempt again
-!attach_to_block(Dir) <- 

    .wait(200);
    !attach_to_block(Dir).
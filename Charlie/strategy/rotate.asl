// To rotate the block to goal (opposite direction) when agent is submitting the task
// B_Dir: Block direction / E_Dir: Expected direction / R_Action: Next Executable direction (cw, ccw)
@rotate_action_free
+!rotate_action_free(Task, X, Y, Type) :
    check_direction(-X, -Y, E_Dir) &
    block(B_Dir, Type) & 
    not (R_Dir == B_Dir) &
    goal_rotation(E_Dir, B_Dir, R_Action) <-

    rotate(R_Action);
    !update_block_rotation(R_Action);
    !rotate_action_free(Task, X, Y, Type).

// If block is at desired direction, stop rotating and submit the task
@rotate_action_free_submit
+!rotate_action_free(Task, X, Y, Type) :
    check_direction(-X, -Y, E_Dir) &
    block(B_Dir, Type) & 
    (R_Dir == B_Dir) <-

    !submit_task(Task, B_Dir, Type).

// If failed, rotation is blocked, therefore execute rotate action obstacle goal
-!rotate_action_free(Task, X, Y, Type) <- !rotate_action_obstacle(Task, X, Y, Type).

// Attempt to rotate opposite direction if normal rotate fails, then fallback to normal rotate
@rotate_action_obstacle
+!rotate_action_obstacle(Task, X, Y, Type) :
    check_direction(-X, -Y, E_Dir) &
    block(B_Dir, Type) & 
    not (R_Dir == B_Dir) &
    goal_rotation(E_Dir, B_Dir, R_Action) & 
    obstacle_rotation(R_Action, New_R) <-

    rotate(New_R);
    !update_block_rotation(R_Action);
    !rotate_action_free(Task, X, Y, Type).

// If fails the failure of a normal rotate action, deem rotation is not possible, detach block and run away
-!rotate_action_obstacle(Task, X, Y, Type) : 
    block(B_Dir, Type) <-

    detach(B_Dir);
    -block(B_Dir, Type);
    +state(explore).

// Prioritized intention to update beliefs of block & free direction
@change_block_dir[atomic]
+!change_block_dir(B, Old_Dir, R_Action) : 
    rotating_dir(Old_Dir, New_Dir, R_Action) <-

    -block(Old_Dir, B);
    +block(New_Dir, B);
    -free_direction(New_Dir);
    +free_direction(Old_Dir).

// Update for 4 blocks
@update_block_rotation4[atomic]
+!update_block_rotation(R_Action) : 
    block(Dir1, B1) & 
    block(Dir2, B2) & 
    block(Dir3, B3) & 
    block(Dir4, B4) & 
    (not(Dir1 = Dir2)) & 
    (not(Dir1 = Dir3)) & 
    (not(Dir1 = Dir4)) & 
    (not(Dir2 = Dir3)) & 
    (not(Dir2 = Dir4)) & 
    (not(Dir3 = Dir4)) <- 
    
    !change_block_dir(B1, Dir1, R_Action);
    !change_block_dir(B2, Dir2, R_Action);
    !change_block_dir(B3, Dir3, R_Action);
    !change_block_dir(B4, Dir4, R_Action).

// Update for 3 blocks
@update_block_rotation3[atomic]
+!update_block_rotation(R_Action) :
    block(Dir1, B1) & 
    block(Dir2, B2) & 
    block(Dir3, B3) & 
    (not(Dir1 = Dir2) & 
     not(Dir1 = Dir3) & 
     not(Dir2 = Dir3)) <- 
    
    !change_block_dir(B1, Dir1, R_Action);
    !change_block_dir(B2, Dir2, R_Action);
    !change_block_dir(B3, Dir3, R_Action).

// Update for 2 blocks
@update_block_rotation2[atomic]
+!update_block_rotation(R_Action) : 
    block(Dir1, B1) & 
    block(Dir2, B2) & 
    (not(Dir1 = Dir2)) <- 
                                
    !change_block_dir(B1, Dir1, R_Action);
    !change_block_dir(B2, Dir2, R_Action).

// Update for 1 block
@update_block_rotation1[atomic]
+!update_block_rotation(R_Action) : 
    block(Dir, B) <- 

    !change_block_dir(B, Dir, R_Action).
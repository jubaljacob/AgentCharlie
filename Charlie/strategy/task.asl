// If agent's all directions are free and has no active task running, get a free task if has dispenser found in local map belief
@look_for_task_all_dir_free
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) > 1) &
    not (active_task(_, _, _, _, _, _)) & 
    free_task(Name, Deadline, R, X, Y, Type) & 
    location(dispenser, Type, _, _) <- 

    !take_task(Name, Deadline, R, X, Y, Type).

// If agent has b0 block around itself, find if block matches any task (b0/b1)
@look_for_task_has_block_b0
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) < 4) &
    not (active_task(_, _, _, _, _, _)) & 
    block(B_Dir, b0) &
    free_task(Name, Deadline, R, X, Y, b0) <- 

    !take_task_block(Name, Deadline, R, X, Y, b0).

@look_for_task_has_block_b1
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) < 4) &
    not (active_task(_, _, _, _, _, _)) & 
    block(B_Dir, b1) &
    free_task(Name, Deadline, R, X, Y, b1) <- 

    !take_task_block(Name, Deadline, R, X, Y, b1).

// If look for task failed, agent waits for 1.5s and look for task again. Agent perform random action to prevent from dying
// When agent cant look for available task, agent goes into power saving state
@look_for_task_failed
-!look_for_task <- 

    -+state(power_saving).
    // .wait(150); 
    // !explore;
    // !look_for_task.

// Take task and broadcast to all agents to notify them that task is no longer applicable, if agent has block, dont need go dispenser
@take_task_submit_with_block
+!take_task_block(Name, Deadline, R, X, Y, Type) : 
    free_task(Name, _, _, _ , _, _) &
    block(B_Dir, Type) <-

    .broadcast(tell, task_assigned(Name));
    -+state(goal_state);
    -free_task(Name, _, _, _ , _, _);
    +active_task(Name, Deadline, R, X, Y, Type).

// Take task and broadcast to all agents to notify them that task is no longer applicable, if task taken by other agents, wait
@take_task
+!take_task(Name, Deadline, R, X, Y, Type) <-

    !find_optimal_plan(X_self, Y_self, Type, plan(X_d, Y_d, X_g, Y_g, _));
    if( free_task(Name, _, _, _ , _, _) ) {
        .broadcast(tell, task_assigned(Name));
        .print("An op plan is found for task ", Name, " Dispenser ", X_d, " Goal ", X_g);
        +targeted_dispenser(X_d, Y_d, Type);
        +targeted_goal(X_g, Y_g);
        -+state(find_blocks);
        -free_task(Name, _, _, _ , _, _);
        +active_task(Name, Deadline, R, X, Y, Type)
    }.

// If submit task was success, change state belief to explore state, tell other agents task succeed
@submit_task
+!submit_task(Task, B_Dir, Type) : name(Ag) <-

    // submit(Task);
    // .broadcast(tell,task_attempt_succeed(Task,Ag));
    -active_task(_,_,_,_,_,_);
    -block(B_Dir, Type);
    submit(Task);
    +free_direction(B_Dir);
    -+state(find_task).

// If agent fails to submit then run away
@submit_task_failed
-!submit_task(Task, B_Dir, Type) <- 
    !task_submit_failure(Task, B_Dir, Type).

// Actions when task submission attempt fails, do not add back to free task, as agent is not able to achieve
+!task_submit_failure(Task, B_Dir, Type) : name(Ag) <-

    detach(B_Dir);
    .broadcast(tell,failed_attempt_task(Task, Ag));
    -active_task(Name,_,_,_,_,_);
    -block(B_Dir, Type);
    -+state(find_task).
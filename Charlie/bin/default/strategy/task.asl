// If agent's all directions are free and has no active task running, get a free task if has dispenser found in local map belief
@look_for_task_all_dir_free
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) > 1) &
    not (active_task(_, _, _, _, _, _)) & 
    free_task(Name, Deadline, R, X, Y, Type) & 
    location(dispenser, Type_, _, _) <- 

    !take_task(Name, Deadline, R, X, Y, Type).

// If agent has b0 block around itself, find if block matches any task (b0/b1)
@look_for_task_has_block_b0
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) < 4) &
    not (active_task(_, _, _, _, _, _)) & 
    block(B_Dir, b0) &
    free_task(Name, Deadline, R, X, Y, b0) <- 

    !take_task(Name, Deadline, R, X, Y, b0).

@look_for_task_has_block_b1
+!look_for_task : 
    .findall(Dir, free_direction(Dir), Dirs) &
    (.length(Dirs) < 4) &
    not (active_task(_, _, _, _, _, _)) & 
    block(B_Dir, b1) &
    free_task(Name, Deadline, R, X, Y, b1) <- 

    !take_task(Name, Deadline, R, X, Y, b1).

// If look for task failed, agent waits for 1.5s and look for task again. Agent perform random action to prevent from dying
@look_for_task_failed
-!look_for_task <- 
    .wait(150); 
    !explore;
    !look_for_task.

// Take task and broadcast to all agents to notify them that task is no longer applicable
@take_task
+!take_task(Name, Deadline, R, X, Y, Type) : 
    free_task(Name, _, _, _ , _, _) <-

    .broadcast(tell, task_assigned(Name));
    -+state(find_blocks);
    -free_task(Name, _, _, _ , _, _);
    +active_task(Name, Deadline, R, X, Y, Type).

// If submit task was success, change state belief to explore state
@submit_task
+!submit_task(Task, B_Dir, Type) <-

    submit(Task);
    -active_task(_,_,_,_,_,_);
    -block(B_Dir, Type);
    +free_direction(B_Dir);
    -+state(explore).

// If agent fails to submit then run away
@submit_task_failed
-!submit_task(Task, B_Dir, Type) <- 
    !task_submit_failure(Task, B_Dir, Type).

// Actions when task submission attempt fails
+!task_submit_failure(Task, B_Dir, Type) <-

    detach(B_Dir);
    -active_task(_,_,_,_,_,_);
    -block(B_Dir, Type);
    +free_direction(B_Dir);
    -+state(explore).
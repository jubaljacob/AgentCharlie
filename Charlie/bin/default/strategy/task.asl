// If submit task was success, change state belief to explore state
+!submit_task(Task, B_Dir, Type) <-

    submit(Task);
    -active_task(_,_,_,_,_,_);
    -block(B_Dir, Type);
    +free_direction(B_Dir);
    -+state(explore).

// If agent fails to submit then run away
-!submit_task(Task, B_Dir, Type) <- 

    detach(B_Dir);
    -block(B_Dir, Type);
    +free_direction(B_Dir);
    +state(explore).
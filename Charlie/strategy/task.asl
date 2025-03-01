// If submit task was success, change state belief to explore state
+!submit_task(Task, B_Dir, Type) <-

    submit(Task);
    -active_task(_,_,_,_,_,_);
    -block(B_Dir, Type)
    -state(_);
    +state(explore_state).

// If agent fails to submit then run away
-!submit_task(Task, B_Dir, Type) <- 

    detach(B_Dir);
    -block(B_Dir, Type)
    -state(_);
    +state(explore_state).
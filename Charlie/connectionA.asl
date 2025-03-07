{ include("strategy/actions.asl") }
{ include("strategy/big_brain.asl") }
{ include("strategy/right_brain.asl") }
{ include("strategy/exception.asl") }

/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

stepCount(0).
position(0,0).
state(explore).
move_axis(x).
rotate_dir(cw).
attached(0).
failed_attempt(0).

/* Initial goals */

!start.

+!start <-
    .print("jasonDummyA starting. Waiting for step percepts...").

/* A dummy plan to keep the agent busy */
+!monitor_percepts <-
    !process_things;
	!process_goals;
	!process_tasks.

// Process all things as beliefs
+!process_things <-  
    .findall([X, Y, Details, Type], thing(X, Y, Details, Type), ThingList);
    !iterate_things(ThingList).

+!iterate_things([]) <-  
    true.

// Details like dispenser/entity/block, Type like b0/b1
+!iterate_things(ThingList) <- 
	for ( .member([X, Y, Details, Type], ThingList) ) {
		+location(Details, Type,  X, Y);
	}.

// Process all goals as beliefs
+!process_goals <-  
    .findall([X, Y], goal(X, Y), GoalList);
    !iterate_goals(GoalList).

+!iterate_goals([]) <-  
    true.

+!iterate_goals(GoalList) <- 
	for ( .member([X, Y], GoalList) ) {
		+location(goal, null,  X, Y);
	}.

// Process all tasks with free task beliefs, make sure no task is left out
+!process_tasks <-  
    .findall(free_task(Name0, Deadline0, R0, X0, Y0, Type0), 
		(task(Name0, Deadline0, R0, Params) &
		 (.length(Params) == 1) & 
    	 .member(req(X0, Y0, Type0), Params) &
		 not(free_task(Name0, _, _, _, _, _))), 
		TaskList);
    !iterate_tasks(TaskList);
	.findall(exp_task(Name1, Deadline1, R1, X1, Y1, Type1),
		(free_task(Name1, Deadline1, R1, X1, Y1, Type1) & 
		 stepCount(Steps) & 
		 Steps >= Deadline1),
		ExpiredTasks);
	!iterate_expired_tasks(ExpiredTasks).

+!iterate_tasks([]) <-  
    true.

+!iterate_expired_tasks([]) <-
	true.

// Add all leftout tasks and remove all expired tasks
+!iterate_expired_tasks(TaskList) <-  
	for ( .member(free_task(Name, Deadline, R, X, Y, Type), TaskList) ) {
		+free_task(Name, Deadline, R, X, Y, Type);
	}.

+!iterate_expired_tasks(ExpiredTasks) <- 
	for ( .member(exp_task(Name, Deadline, R, X, Y, Type), ExpiredTasks) ) {
		-free_task(Name, Deadline, R, X, Y, Type);
	}.

// Add task as a free task belief
@reveive_task_assignment_single_block
+task(Name, Deadline, R, Params) : 
    (.length(Params) == 1) & 
    .member(req(X, Y, Type), Params) <-
    +free_task(Name, Deadline, R, X, Y, Type).

+step(Num) <-
	-+stepCount(Num);
    !monitor_percepts.

// Xheck action status
+!check_prev_action_status(Act, Res, Par) <- 
	?lastAction(Act);
	?lastActionResult(Res);
    ?lastActionParams([Par])[_].

-!check_prev_action_status(Act, Res, Par) <- Act = null; Res=null; Par=null.

+actionID(X) : true <-
	!check_prev_action_status(Act, Res, Par);

	// If previous action failed, look for exception handler, otherwise go for decision maker
	if ((Res == failed) | (Res == failed_target) | (Res == failed_blocked) | 
		(Res == failed_forbidden) | (Res == failed_path)) {	
			-+failed_attempt(Failure+1);
			!failure_handler(Act, Res, Par);
		}
	else {
		-+failed_attempt(0);
		!decision_maker;
	}.

	// mypackage.MyAction(1, K, S, C, A, Result, Act);


	
	// if   (K == 1) { move(n); }
    // elif (K == 2) { move(s); }
	// elif (K == 3) { move(w); }
	// elif (K == 4) { move(e); }
	// elif (K == 100) { !move_random; }
	// elif (K == 0) { skip; }
	// elif (K == 5) { request(n); }
	// elif (K == 6) { request(s); }
	// elif (K == 7) { request(w); }
	// elif (K == 8) { request(e); }
	// elif (K == 9) { attach(n); }
	// elif (K == 10) { attach(s); }
	// elif (K == 11) { attach(w); }
	// elif (K == 12) { attach(e); }
	// elif (K == 13) { rotate(cw); }
	// elif (K == 14) { rotate(ccw); }
	// elif (K == 15) { submit(C); }
	
	// .print("Received: ", K, " State is:", S, " Task chosen: ", C, " Action taken: ", T," Action Result: ", J, " Alligned: ", A).
	/*!move_random.*/
	
//    skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)	<-	
	move(Dir).

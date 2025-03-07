{ include("strategy/actions.asl") }
{ include("strategy/big_brain.asl") }
{ include("strategy/right_brain.asl") }
{ include("strategy/exception.asl") }

/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

position(0,0).
state(explore).
move_axis(x).
rotate_dir(cw).
attached(0).

/* Initial goals */

!start.

+!start <-
    .print("jasonDummyA starting. Waiting for step percepts...").

/* A dummy plan to keep the agent busy */
+!monitor_percepts <-
    !process_things;
	!process_goals;

// Process all things as beliefs
+!process_things <-  
    .findall([X, Y, Details, Type], thing(X, Y, Details, Type), ThingList);
    !iterate_things(ThingList).

+!iterate_things([]) <-  
    true.

// Details like dispenser/entity/block, Type like b0/b1
+!iterate_things([[X, Y, Details, Type] | Rest]) <-  
	+location(Details, Type,  X, Y);
    !iterate_things(Rest).

+!iterate_things([_ | Rest]) <-  
    !iterate_things(Rest).

// Process all goals as beliefs
+!process_goals <-  
    .findall([X, Y], goal(X, Y), GoalList);
    !iterate_goals(GoalList).

+!iterate_goals([]) <-  
    true.

+!iterate_goals([[X, Y] | Rest]) <-  
	+location(goal, null,  X, Y);
	!iterate_goals(Rest).

// Add task as a free task belief
@reveive_task_assignment_single_block
+task(Name, Deadline, R, Params) : 
    (.length(Params) == 1) & 
    .member(req(X, Y, Type), Params) <-
    +free_task(Name, Deadline, R, X, Y, Type).

+step(Num) <-
    !monitor_percepts.
	
+actionID(X) : true <-
	?lastAction(Act);
	?lastActionResult(Res);
    ?lastActionParams([Par])[_];

	// WIP
	// !exception(Act, Res, Per);
	
	if ((Res == failed) | (Res == failed_target) | (Res == failed_blocked) | 
		(Res == failed_forbidden) | (Res == failed_path)) {
			!failure_handler(Act, Res, Par);
		}
	else {
		!decide_action;
	}

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
	
	.print("Received: ", K, " State is:", S, " Task chosen: ", C, " Action taken: ", T," Action Result: ", J, " Alligned: ", A).
	/*!move_random.*/
	
//    skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).

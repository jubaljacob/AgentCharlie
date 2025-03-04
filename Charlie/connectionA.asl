/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* Initial goals */

!start.

+!start : true <-
    .print("jasonDummyA starting. Waiting for step percepts...").

/* A dummy plan to keep the agent busy */
+!monitor_percepts : true <-
    !process_things;
	!process_goals;
	!process_tasks.


+!process_things <-  
    .findall([X, Y, Details, Type], thing(X, Y, Details, Type), ThingList);
    !iterate_things(ThingList).

+!iterate_things([]) <-  
    USELESS = 1.

+!iterate_things([[X, Y, Details, Type] | Rest]) <-  
	mypackage.MyAction(2, X, Y, Details, Type);
    !iterate_things(Rest).

+!iterate_things([_ | Rest]) <-  
    !iterate_things(Rest).

+!process_goals <-  
    .findall([X, Y], goal(X, Y), GoalList);
    !iterate_goals(GoalList).

+!iterate_goals([]) <-  
    USELESS = 1.

+!iterate_goals([[X, Y] | Rest]) <-  
    mypackage.MyAction(3, X, Y);
	!iterate_goals(Rest).

+!process_tasks <-  
    .findall([X, Y, Details, Type], task(X, Y, Details, Type), TaskList);
    !iterate_tasks(TaskList).

+!iterate_tasks([]) <-  
    USELESS = 1.

+!iterate_tasks([[X, Y, Details, Type] | Rest]) <-  
	mypackage.MyAction(4, X, Y, Details, Type);
    !iterate_tasks(Rest).

/*+task(X, Y, Details, Type) : true <- mypackage.MyAction(4, X, Y, Details, Type).*/

/*+goal(X, Y) : true <- .print("This goal X: ", X, " & Y", Y).*/

+step(Num) : true <-
    !monitor_percepts.
    /*.print("Received step percept (number): ", Num).
 	?score(K);
    .print("Last score is: ", K).*/
	
+actionID(X) : true <-
	?lastActionResult(J);
	?lastAction(T);
	mypackage.MyAction(1, K, S, C, A, J, T);
	
	if   (K == 1) { move(n); }
    elif (K == 2) { move(s); }
	elif (K == 3) { move(w); }
	elif (K == 4) { move(e); }
	elif (K == 100) { !move_random; }
	elif (K == 0) { skip; }
	elif (K == 5) { request(n); }
	elif (K == 6) { request(s); }
	elif (K == 7) { request(w); }
	elif (K == 8) { request(e); }
	elif (K == 9) { attach(n); }
	elif (K == 10) { attach(s); }
	elif (K == 11) { attach(w); }
	elif (K == 12) { attach(e); }
	elif (K == 13) { rotate(cw); }
	elif (K == 14) { rotate(ccw); }
	elif (K == 15) { submit(C); }
	
	.print("Received: ", K, " State is:", S, " Task chosen: ", C, " Action taken: ", T," Action Result: ", J, " Alligned: ", A).
	/*!move_random.*/
	
//    skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).

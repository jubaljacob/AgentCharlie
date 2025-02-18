/* jasonDummyA.asl */

/* Initial Goal */
!start.

/* Plans */

/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* When the agent starts, print a welcome message and start monitoring percepts */
+!start : true <-
    .print("jasonDummyA starting. Waiting for step percepts...").

/* A dummy plan to keep the agent busy */
+!monitor_percepts : true <-
    !process_things;
    !monitor_percepts.

+!process_things <-  
    .findall([X, Y, Details, Type], thing(X, Y, Details, Type), ThingList);
    !iterate_things(ThingList).

+!iterate_things([]) <-  
    .print("Finished checking all things.").

+!iterate_things([[X, Y, dispenser, Type] | Rest]) <-  
    .print("Dispenser found at X: ", X, ", Y: ", Y, " | Type: ", Type);
    !iterate_things(Rest).

+!iterate_things([_ | Rest]) <-  
    !iterate_things(Rest).

/* Plan for a step percept received as a simple number */

+step(Num) : true <-
    !monitor_percepts.
    /*.print("Received step percept (number): ", Num).
	?score(K);
    .print("Last score is: ", K).*/

+actionID(X) : true <- 
	!move_random.
//	skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).
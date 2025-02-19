/* Initial Goal */
!start.

/* Plans */

/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* When the agent starts, print a welcome message and start monitoring percepts */
+!start : true <-
    .print("jasonDummyA starting. Waiting for step percepts...");
    +my_pos(0, 0); // Agent always sees itself at (0,0)
    !monitor_percepts.

/* Monitor percepts and process things */
+!monitor_percepts : true <-
    !process_things;
    !decide_action.

+!process_things <-  
    .findall([X, Y, Details, Type], thing(X, Y, Details, Type), DispLoc);
    !iterate_things(DispLoc).

// Dispenser 
+!iterate_things([]) <-  
    .print("Finished checking all things.").

+!iterate_things([[X, Y, dispenser, Type] | Rest]) <-
    .print("Dispenser found at X: ", X, ", Y: ", Y, " | Type: ", Type);
    +dispenser_found(X, Y); // Add belief that dispenser was found
    !iterate_things(Rest).

+!iterate_things([_ | Rest]) <-  
    !iterate_things(Rest).

/* Plan for a step percept received as a simple number */
+step(Num) : true <-
    !monitor_percepts.

+actionID(X) : true <- 
    !decide_action.

/* Decide what action to take based on whether a dispenser was found */
+!decide_action : dispenser_found(X, Y) <-
    .print("Deciding to move to dispenser at ", X, ",", Y);
    !move_to_dispenser(X, Y).

+!decide_action : not dispenser_found(_, _) <-
    .print("No dispenser found, moving randomly.");
    !move_random.

/* Move randomly */
+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir) 
<-  move(Dir).

// Plan to move to dispenser or stay if adjacent
+!move_to_dispenser(X, Y) : true <-
    .print("Moving towards dispenser at ", X, ",", Y);
    !calculate_offset(X, Y, OffsetX, OffsetY);
    !move_towards(OffsetX, OffsetY).

+!calculate_offset(X, Y, OffsetX, OffsetY) <-
    OffsetX = X;
    OffsetY = Y.

// Helper plan to move towards the dispenser 
+!move_towards(X, Y) : X = 0 & Y = 0 <-
    .print("Reached dispenser, stopping.");
    skip.

+!move_towards(X, Y) : adjacent(X, Y) <-
    .print("Adjacent to dispenser at offset ", X, ",", Y, ", stopping.");
    skip.

+!move_towards(X, Y) : X > 0 <- move(e); !move_towards(X-1, Y).
+!move_towards(X, Y) : X < 0 <- move(w); !move_towards(X+1, Y).
+!move_towards(X, Y) : Y > 0 <- move(s); !move_towards(X, Y-1).
+!move_towards(X, Y) : Y < 0 <- move(n); !move_towards(X, Y+1).

// Check if adjacent to the dispenser (within one block)
+adjacent(X, Y) : (X = 0 & (Y = -1 | Y = 1)) | (Y = 0 & (X = -1 | X = 1)).





// /* jasonDummyA.asl */

// /* Initial Goal */
// !start.

// /* Plans */

// /* Initial beliefs and rules */
// random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

// /* When the agent starts, print a welcome message and start monitoring percepts */
// +!start : true <-
//     .print("jasonDummyA starting. Waiting for step percepts...").

// /* A dummy plan to keep the agent busy */
// +!monitor_percepts : true <-
//     !process_things;
//     !monitor_percepts.

// +!process_things <-  
//     .findall([X, Y, Details, Type], thing(X, Y, Details, Type), ThingList);
//     !iterate_things(ThingList).

// +!iterate_things([]) <-  
//     .print("Finished checking all things.").

// +!iterate_things([[X, Y, dispenser, Type] | Rest]) <-  
//     .print("Dispenser found at X: ", X, ", Y: ", Y, " | Type: ", Type);
//     !iterate_things(Rest).

// +!iterate_things([_ | Rest]) <-  
//     !iterate_things(Rest).

// /* Plan for a step percept received as a simple number */

// +step(Num) : true <-
//     !monitor_percepts.
//     /*.print("Received step percept (number): ", Num).
// 	?score(K);
//     .print("Last score is: ", K).*/

// +actionID(X) : true <- 
// 	!move_random.
// 	// skip.

// +!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
// <-	move(Dir).
// If agent is not in goal state, agent will retrieve a new free task
@navigation_new_task
+!navigation: 
	agent_pos(X_self, Y_self) &
	not(state(goal_state)) & 
	location(goal, _, _, _) & 
	free_task(Name, Deadline, R, X, Y, Type) & 
	block(Dir, Type) & 
	not task_already_taken(Name) <-

	.broadcast(tell,task_already_taken(Name));
	-free_task(Name, Deadline, R, X, Y, Type);
	+active_task(Name, Deadline, R, X, Y, Type);
	-+state(goal_state).

// Agent continues to move towards the same direction considering that if the previous move was success
@navigation_success
+!navigation: 
	agent_pos(X_self, Y_self) & 
	lastAction(move) & 
	lastActionResult(success) & 
	lastActionParams([Dir]) & 
	check_direction(_, _, Dir) <-

	!move(Dir).

// Agent makes a random navigation movement
@navigation_random
+!navigation : 
	agent_pos(X_self, Y_self) &
	.random(RandomNumber) & 
	random_dir([n,s,e,w], RandomNumber, Dir) & 
	check_direction(X, Y, Dir) <-
	
	!move(Dir).


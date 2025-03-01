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

// Agent continues to move towards the same direction considering that if the previous move was success (initial Exploration*)
// @navigation_success
// +!navigation: 
// 	agent_pos(X_self, Y_self) & 
// 	lastAction(move) & 
// 	lastActionResult(success) & 
// 	lastActionParams([Dir]) & 
// 	check_direction(_, _, Dir) <-

// 	!move(Dir).


// when the agent is in exploration state , it can move clockwise in a direction for 5 steps and once 5 steps is completed the agent will move in rotation
// different to the previous rotation( cw/ccw) and the agent will move in that direction.
@navigation_explore
+!navigation : 
	state(navigation) & dirch_step(PStep, Old_r) & step_count(CStep) & 
	dirch_step_calc(CStep, PStep) & lastActionParams([Dir]) & obstacle_rotation(Old_r,New_r) & rotating_dir(Dir,R_Dir,New_r) <-

	.print(CStep);
	!move(R_Dir);
	-+dirch_step(CStep, New_r).

// If agent move succeed, then continue in that direction
@navigation_success
+!navigation : 
	agent_pos(X_self, Y_self) & lastAction(move) & lastActionParams([Dir]) <- 

	!move(Dir).

// Agent makes a random navigation movement (initial Exploration*)
@navigation_random
+!navigation : 
	agent_pos(X_self, Y_self) &
	.random(RandomNumber) & random_dir([n,s,e,w], RandomNumber, Dir) & check_direction(X, Y, Dir) <-

	!move(Dir).


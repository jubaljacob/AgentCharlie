// when the agent is in exploration state , it can move clockwise in a direction for 5 steps and once 5 steps is completed the agent will move in rotation
// different to the previous rotation( cw/ccw) and the agent will move in that direction.
@explore_pattern
+!explore : 
	(state(explore) | state(power_saving)) & 
	dirch_step(PStep, Old_r) & 
	step_count(CStep) & 
	dirch_step_calc(CStep, PStep) & 
	lastActionParams([Dir]) & 
	obstacle_rotation(Old_r,New_r) & 
	rotating_dir(Dir,R_Dir,New_r) <-

	!move(R_Dir);
	-+dirch_step(CStep, New_r);
	if (CStep == 30) { -+state(find_task); }.

// If agent found dispenser for block b0 and b1 and a goal, agent will stop exploring
@explore_early_stop_all
+!explore : 
	state(explore) & 
	location(dispenser, b0_, _, _) &
	location(dispenser, b1_, _, _) & 
	location(goal, _, _, _) <-

	-+state(find_task).

// If agent move succeed, then continue in that direction
@explore_success
+!explore : 
	agent_pos(X_self, Y_self) & 
	(state(explore) | state(power_saving)) & 
	lastAction(move) & 
	lastActionParams([Dir]) & 
	lastActionResult(success) <- 

	!move(Dir).	


// Agent makes a random explore movement
@explore_random[atomic]
+!explore : 
	agent_pos(X_self, Y_self) &
	.random(RandomNumber) & 
	random_dir([n,s,e,w], RandomNumber, Dir) & 
	check_direction(X, Y, Dir) <-

	!move(Dir).


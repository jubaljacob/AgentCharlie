
{ include("strategy/explore.asl") }
{ include("strategy/path.asl") }
{ include("strategy/rotate.asl") }
{ include("strategy/service.asl") }
{ include("strategy/task.asl") }
{ include("strategy/move.asl") }

// Initial beliefs

agent_pos(0,0).
state(explore).
dirch_step(0,cw).
step_count(0).

// Initial goals 

!start.                

//  Plans 

+!start : true <-
	.print("Hello massim world.").
    
+step(S) : lastAction(move) & step_count(Count) <-
    -+step_count(Count+1).

// Explore state
+actionID(ID) : state(State) & State == explore <- 
	!explore.

// Find task state
+actionID(ID) : state(State) & State == find_task <- 
	!look_for_task.

// Find block state
+actionID(ID) : state(State) & State == find_blocks &
    targeted_dispenser(X_d, Y_d, Type) <- 
    
    !move_to_dispenser(X_d, Y_d, Type).

// If in find block state, but no targeted_dispenser, attempt look for dispenser
+actionID(ID) : 
    agent_pos(X_self, Y_self) &
    state(State) & State == find_blocks & 
    active_task(Name, _, _, _, _, Type) <- 

    !find_optimal_plan(X_self, Y_self, Type, plan(X_d, Y_d, X_g, Y_g, _));
    .print("An op plan is found for task ", Name);
    +targeted_dispenser(X_d, Y_d);
    +targeted_goal(X_g, Y_g);
    !move_to_dispenser(X_d, Y_d, Type).

// Find goal state
+actionID(ID) : state(State) & 
    State == goal_state &
    targeted_goal(X_g, Y_g) <-

    !move_to_goal(X_g, Y_g).

// If in find goal state, but no targeted goal, attempt look for nearest goal and submit
+actionID(ID) : state(State) & 
    State == goal_state &
     not(targeted_goal(X_g, Y_g))  <-

    !find_nearest_goal(X_self, Y_self, X_g, Y_g);
    +targeted_goal(X_g, Y_g);
    !move_to_goal(X_g, Y_g).

// When agent is in power saving mode, agent continue explore world, but very slowly
+actionID(ID) : state(State) &
    State == power_saving <-

    .wait(150);
    !explore.

// Percept and add dispenser to local beliefs if never been before
@percept_dispenser
+thing(X, Y, dispenser, Type) : 
    agent_pos(X_self, Y_self) &
    not(location(dispenser, Type, (X_self+X), (Y_self+Y))) <-
    
	+location(dispenser,Type,(X_self+X),(Y_self+Y)).

// Percept and add goal to local beliefs if never been before
@percept_goal
+goal(X, Y) : 
    agent_pos(X_self, Y_self) &
    not(location(goal,_,(X_self+X),(Y_self+Y))) <-
    
	+location(goal,null,(X_self+X),(Y_self+Y)).

// When agent receive a single block task assignment from server and agent in power saving mode with applicable task, immediately accept task
@reveive_task_assignment_power_saving[atomic]
+task(Name, Deadline, R, Params) : 
    state(power_saving) & 
    (.length(Params) == 1) & 
    .member(req(X, Y, Type), Params) <-
    
    +free_task(Name, Deadline, R, X, Y, Type); 
    !take_task(Name, Deadline, R, X, Y, Type).

// When agent receive a single block task assignment from server
@reveive_task_assignment_single_block
+task(Name, Deadline, R, Params) : 
    (.length(Params) == 1) & 
    .member(req(X, Y, Type), Params) <-
    +free_task(Name, Deadline, R, X, Y, Type).

// If agent received other agent took a task, remove task from agent's belief
@task_assigned_by_other_agents[atomic]
+task_assigned(Name)[source(A)] : free_task(Name, _, _, _ , _, _) <- 

    -free_task(Name, _, _, _ , _, _);
    .print("Task ", Name, " is taken by agent ", A).

// Add back failed task by other agents as free task
@add_failed_task_by_other_agents
+failed_attempt_task(Task, Ag) : 
    not(free_task(Task, _, _, _ , _, _)) &
    task(Task, Deadline, R, Params) &
    .member(req(X, Y, Type), Params) <-

    .print(Ag, " has failed task submission, adding task ", Task, "back to free task belief");
    +free_task(Name, Deadline, R, X, Y, Type).

// When task has been succeed by other agent, drop from task belief, reduce computation memory
@task_attempt_succeed
+task_attempt_succeed(Task, Ag) <- 

    .print("Pop champagne! Congratulations to ", Ag);
    -task(Task, _, _, _).
 
// +actionID(ID) :  state(find_blocks) & target_dispenser(Type,X,Y) <-
// 	!move_to_dispenser(X,Y,Type).

// // 【actionID】 The agent is currently in find_goal mode and is trying to get to a goal.
// +actionID(ID) : state(goal_state) & location(goal,_,X,Y) <- 
// 	!move_to_goal(X,Y).































// // This plan is used to give the agent the ability to store the dispenser's information in target_dispenser when it finds a dispenser that has not yet sensed the block type and switches to find_blocks mode.
// // @assign_dispenser[atomic] 
// +!id_dispenser(Type) : not block(_,Type) & location(dispenser,Type,X,Y) <-
// 	.print("The agent target_dispenser Type=",Type);
// 	-+target_dispenser(Type,X,Y);
// 	-+state(find_blocks).

// // This plan is a backup plan in case agent fails to execute the assign_dispenser plan, and only prints the information.
// // @dispenser_error[atomic] 
// -!id_dispenser <-
// 	.time(H,M,S,MS); 	
// 	.print("The agent gives up a target_dispenser Type=",Type).

// // 【thing】When the agent receives the thing sense from the server and the sense is dispenser, it will calculate the absolute position by the relative position of the dispenser and update the dispenser_list.Finally,
// //			it will call the dispenser_found plan.
// // @percept_dispenser[atomic] 
// +thing(X, Y, dispenser, Type) : agent_pos(X0,Y0)<-
// 	.time(H,M,S,MS);
// 	.print("[",H,":",M,":",S,":",MS,"] ", Type, " dispenser detected at ",X,",",Y);
// 	+location(dispenser,Type,(X0+X),(Y0+Y));
// 	!dispenser_found(Type,(X0+X),(Y0+Y)).

// // 【!dispenser_found】 In this case, if the agent has not found any blocks yet, then it records the target_dispenser information and updates its own status to find_blocks.
// // @dispenser_found[atomic] 
// +!dispenser_found(Type,X,Y) : not block(_,_)<-
// 	.time(H,M,S,MS);
// 	.print("Dispenser found");
// 	-+target_dispenser(Type,X,Y);
// 	-+state(find_blocks).

// // 【-!dispenser_found】 In this case, the agent prints only the message.
// // @dispenser_found_no_action[atomic] 
// -!dispenser_found(Type,X,Y) : true<-
// 	.time(H,M,S,MS);
// 	.print("Dispenser found").

// // 【goal】 Used to update the location information of an undiscovered goal into goal_list.
// // @goal1[atomic] 
// +goal(X,Y): agent_pos(X0,Y0) <- 
// 	.time(H,M,S,MS);
// 	.print("Goal detected at ",X,",",Y);
// 	+location(goal,null,(X0+X),(Y0+Y)).

// // 【location(goal,_,X,Y)】 When an agent receives a location(goal,_,X,Y) belief, if it is not currently executing any tasks and has not received any task conflict information, it will get a task from free_task
// //							gets a task and broadcasts a notification of the conflict to all agents in the same team.
// // @goal2[atomic] 
// +location(goal,_,X,Y): not(state(goal_state)) & free_task(Name, Deadline, Rew,TX,TY,Type) & block(Dir,Type) & not task_already_taken(Name)<- 
// 	.time(H,M,S,MS); 	
// 	.print("The agent sees a goal:",X,",",Y);
	
// 	.broadcast(tell,task_already_taken(Name));
// 	-free_task(Name, Deadline, Rew,TX,TY,Type);
// 	+current_job(Name, Deadline, Rew,TX,TY,Type);
// 	-+state(goal_state);
// 	.print(" Agent start task ",N).

// // 【have_block】 When an agent succeeds in taking possession of a block, it broadcasts a notification of a conflict to other agents in the same team.
// // @have_block[atomic] 
// +have_block(Dir,B) : not(state(goal_state)) & location(goal,_,XG,YG) & free_task(Name, Deadline, Rew,X,Y,Type) & block(Dir,Type) & not task_already_taken(Name)<-
// 	.broadcast(tell,task_already_taken(Name));
// 	-free_task(Name, Deadline, Rew,X,Y,Type);
// 	+current_job(Name, Deadline, Rew, X, Y, Type);
// 	-+state(goal_state);
// 	-have_block(Dir,Type).

// // 【task】 When the agent receives a task belief from the server, it will only accept tasks of a specific block length. Currently only tasks with a block length of 1 are accepted.
// +task(Name, Deadline, Rew, Req) : (.length(Req) == 1) <-
// 	.member(req(X,Y,Type),Req);
// 	.print("Task ",Name, " added.");
// 	+free_task(Name, Deadline, Rew, X, Y, Type).

// // 【free_task】Upon receiving a free_task belief, the agent will query if it is currently executing or if there is a task conflict. If it is not executing and there is no conflict, 
// // 			   it transforms the task into a current_job and broadcasts a conflict notification.
// // @free_task[atomic] 
// +free_task(Name, Deadline, Rew,X,Y,Type) : not(state(goal_state)) & location(goal,_,XG,YG) & block(Dir,Type) & not task_already_taken(Name)<-
// 	.time(H,M,S,MS); 	
// 	.print("The agent took task ",Name);
// 	.broadcast(tell,task_already_taken(Name));
// 	-free_task(Name, Deadline, Rew,X,Y,Type);
// 	+current_job(Name, Deadline, Rew,X,Y,Type);
// 	-+state(goal_state).
	
// // 【task_already_taken】 Upon receiving a task conflict message from another agent, this agent will add the task content from the conflict message to its own task conflict beliefs.
// +task_already_taken(Name)[source(Ag)]  :  not(Ag = self) <- 
// 	+task_already_taken(Name);
// 	.time(H,M,S,MS); 	
// 	.print("Task ",Name," was already taken by", Ag).

// // 【agent_pos(X,Y)】 Manage the agent's own coordinates. The initial starting position is the coordinate origin, and thereafter the coordinate offsets generated by
// // 							the agent's movements and the positions of the objects it sees are updated based on that origin.
// +agent_pos(X,Y) : true <-
// 	.time(H,M,S,MS); 	
// 	.print("Agent now at",X,",",Y).


// // 【lastAction(Action)】 Handling failure events after interaction with the environment
// +lastAction(Action) : lastActionResult(Result)<-
// 	if(Action == attach & Result == failed){
// 		!attach_failed;
// 	}elif(Action == attach & Result == failed_target){
// 		!attach_failed_target;
// 	}elif(Action == request & Result == failed_blocked){
// 		!request_failed_blocked;
// 	}elif(Action == detach & Result == failed){
// 		!detach_failed;
// 	}elif(Action == detach & Result == failed_target){
// 		!detach_failed_target;
// 	}.

// // 【lastAction(Action)】 Handling failed parameterized events after interaction with the environment
// +lastAction(Action) : lastActionResult(Result) & lastActionParams(Params)<-
// 	if(Action == rotate & Result == failed){
// 		!rotate_failed(Params)
// 	}elif(Action == attach & Result == failed){
// 		!attach_failed;
// 	}elif(Action == attach & Result == failed_target){
// 		!attach_failed_target;
// 	}elif(Action == request & Result == failed_blocked){
// 		!request_failed_blocked;
// 	}elif(Action == submit & Result == failed){
// 	  !submit_failed(Params);
// 	}elif(Action == submit & Result == success){
// 	  !submit_success(Params);
// 	}elif(Action == move & Result == failed_forbidden){
// 		!move_exploration_failed_forbidden(Params);
// 	}elif(Action == move & Result == failed_path){
// 		!move_failed_path(Params);
// 	}.

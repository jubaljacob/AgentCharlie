
+!navigation: not(state(goal_state)) & location(goal,_,XG,YG) & agent_pos(X0,Y0) & available_job(Name, Deadline, Rew,X,Y,Type) & block(Dir,Type) & not task_already_taken(Name)<-
	.broadcast(tell,task_already_taken(Name));
	-available_job(Name, Deadline, Rew,X,Y,Type);
	+current_job(Name, Deadline, Rew,X,Y,Type);
	-+state(goal_state);
	.print(" Agent start task ",Name).


+!navigation: agent_pos(X0,Y0)  & lastAction(move) & lastActionResult(success) & lastActionParams([Dir]) & check_direction(X1,Y1,Dir)<-
	.time(H,M,S,MS); 	
	.print("Agent (",X0,",",Y0,") move ",Dir);
	-+agent_pos(X0+X1,Y0+Y1);
	move(Dir).

+!navigation : .random(RandomNumber) & random_dir([n,s,e,w] ,RandomNumber,Dir) & agent_pos(X0,Y0) & check_direction(X1,Y1,Dir)<-
    -+agent_pos(X0+X1,Y0+Y1);
	move(Dir);
	.time(H,M,S,MS); 	
	.print("Agent (",X0,",",Y0,") move randomly ",Dir).


// Detect and record obstacles
+obstacle_detected(X,Y) : agent_pos(CX,CY) & .count(location(obstacle,_,_,_),N) & (N == 0) <- 
    +location(obstacle,_,(CX+X),(CY+Y));
    !determine_direction(CX+X, CY+Y);
    .print("Obstacle registered at ",(CX+X),",",(CY+Y)).

// Determine which direction the obstacle is in relative to the agent
+!determine_direction(OX, OY) : agent_pos(PX, PY) <- 
    // Calculate direction vector from agent to obstacle
    DX = OX - PX;
    DY = OY - PY;
    
    // Check which direction has the obstacle
    !check_direction(DX, DY).

// Direction checking plans - each handles a specific direction
+!check_direction(1, 0) <- +avoid_from("e").   
+!check_direction(-1, 0) <- +avoid_from("w").  
+!check_direction(0, 1) <- +avoid_from("s").  
+!check_direction(0, -1) <- +avoid_from("n"). 

// Avoidance strategies - each selects moves based on available options
+avoid_from(Dir) : true <- 
    !select_available_moves(Dir).

// For each direction, define the available moves (excluding going back toward the obstacle)
+!select_available_moves("e") <- +available_moves(["n", "s"]).
+!select_available_moves("w") <- +available_moves(["n", "s"]).
+!select_available_moves("n") <- +available_moves(["e", "w"]).
+!select_available_moves("s") <- +available_moves(["e", "w"]).

// Choose a random direction from available options
+available_moves(Options) : true <- 
    .length(Options, L);
    .random(R);
    Index = math.floor(R * L);
    .nth(Index, Options, ChosenDir);
    !execute_move(ChosenDir).

// Execute the chosen move
+!execute_move(Dir) : agent_pos(PX, PY) <- 
    .print("Moving ", Dir, " to avoid obstacle");
    move(Dir).

// Detect obstacle based on perception from environment
+thing(X, Y, obstacle, _) : true <-
    +obstacle_detected(X, Y).

// Add this to your explore.asl to handle obstacles during explore
@explore_obstacle
+!explore : location(obstacle,_,_,_) & avoid_from(Dir) <- 
    !select_available_moves(Dir).

// Make sure this rule gets added to your explore priority above the random movement
// but below the success case
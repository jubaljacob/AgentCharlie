
+obstacle_detected(X,Y) : current_position(CX,CY) & .count(location(obstacle,_,_,_),N) & (N == 0) <- 
    +gridLoc(obstacle,_,(CX+X),(CY+Y));
    +determine_direction(CX+X, CY+Y);
    .print("Obstacle registered at ",(CX+X),",",(CY+Y)).

// Determine which direction the obstacle is in relative to the agent
+determine_direction(OX, OY) : current_position(PX, PY) <- 
    // Calculate direction vector from agent to obstacle
    DX = OX - PX;
    DY = OY - PY;
    
    // Check which direction has the obstacle
    +check_direction(DX, DY).

// Direction checking plans - each handles a specific direction
+check_direction(1, 0) <- +avoid_from("east").   
+check_direction(-1, 0) <- +avoid_from("west").  
+check_direction(0, 1) <- +avoid_from("south").  
+check_direction(0, -1) <- +avoid_from("north"). 

// Avoidance strategies - each selects moves based on available options
+avoid_from(Dir) : true <- 
    +select_available_moves(Dir).

// For each direction, define the available moves (excluding going back toward the obstacle)
+select_available_moves("east") <- +available_moves(["north", "south"]).
+select_available_moves("west") <- +available_moves(["north", "south"]).
+select_available_moves("north") <- +available_moves(["east", "west"]).
+select_available_moves("south") <- +available_moves(["east", "west"]).

// Choose a random direction from available options
+available_moves(Options) : true <- 
    .length(Options, L);
    .random(R);
    Index = math.floor(R * L);
    .nth(Index, Options, ChosenDir);
    +execute_move(ChosenDir).

// Execute the chosen move
+execute_move("north") : current_position(PX, PY) <- 
    current_position(PX, PY-1);
    move(n);
    .print("Moving north to avoid obstacle").

+execute_move("south") : current_position(PX, PY) <- 
    current_position(PX, PY+1);
    move(s);
    .print("Moving south to avoid obstacle").

+execute_move("east") : current_position(PX, PY) <- 
    current_position(PX+1, PY);
    move(e);
    .print("Moving east to avoid obstacle").

+execute_move("west") : current_position(PX, PY) <- 
    current_position(PX-1, PY);
    move(w);
    .print("Moving west to avoid obstacle").
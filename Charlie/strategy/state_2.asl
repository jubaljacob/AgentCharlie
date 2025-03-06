+!handle_state(2) : true <-
    ?targetX(TargetX);
    ?targetY(TargetY);
    ?is_target_reached((math.abs(TargetX) == 1 & TargetY == 0) | (math.abs(TargetY) == 1 & TargetX == 0));
    
    +distance_to_closest_dispenser(1000);
    
    for (dispenser(X, Y, Type)) {
        ?distance_to_closest_dispenser(CurrentDistance);
        Sum = math.abs(X) + math.abs(Y);
        
        if (Sum < CurrentDistance) {
            -+distance_to_closest_dispenser(Sum);
            -+targetX(X);
            -+targetY(Y);
            -+block_type(Type);
        }
    }
    
    ?distance_to_closest_dispenser(FinalDistance);
    if (FinalDistance \== 1) {
        -+state(0);
    } else {
        ?targetX(TX);
        ?targetY(TY);
        
        if (TX == -1 & TY == 0) {
            -+action(7);  
            -+dir(4);
            -+state(3);
        } else {
            if (TX == 1 & TY == 0) {
                -+action(8);  
                -+dir(3);
                -+state(3);
            } else {
                if (TX == 0 & TY == 1) {
                    -+action(6);  
                    -+dir(2);
                    -+state(3);
                } else {
                    if (TX == 0 & TY == -1) {
                        -+dir(1);
                        -+action(5);  
                        -+state(3);
                    }
                }
            }
        }
    }.
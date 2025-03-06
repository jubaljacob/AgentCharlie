// Get distance of thing from agent
@measure_distance_from_agent
+!measure_distance_from_agent(X_self, Y_self, Thing, Type, ThingDistances) <-
    .findall(
            point(Xd,Yd,Distance),
                (location(Thing,Type,Xd,Yd) &
                calculate_distance(X_self, Y_self, Xd, Yd, Distance)),
            ThingDistances
    ).

// WIP Need the Dispenser Type
@find_nearest_dispenser
+!find_nearest_dispenser(X_self, Y_self, Xg, Yg, _Type) <- 
    !measure_distance_from_agent(X_self, Y_self, dispenser, _Type, ThingDistances);
    .min(ThingDistances, point(Xg,Yg,Distance)).

@find_nearest_goal
+!find_nearest_goal(X_self, Y_self, Xg, Yg) <- 
    !measure_distance_from_agent(X_self, Y_self, goal, null, ThingDistances);
    .min(ThingDistances, point(Xg,Yg,Distance)).

@find_agent_has_block_number
+!find_agent_block(BlockNumber) <- 
    .findall(
            Type,
                (location(block,Type,Xd,Yd) &
                ((math.abs(Xd) == 1 & math.abs(Yd) == 0) | (math.abs(Xd) == 0 | math.abs(Yd) == 1))),
            Blocks
    );
    .length(Blocks, BlockNumber).

// To calculate the manhattan distance between from/to X & Y
calculate_distance(X1, Y1, X2, Y2, Dist) :-
    Dist = math.sqrt(((X2 - X1)*(X2 - X1)) + ((Y2 - Y1)*(Y2 - Y1))).
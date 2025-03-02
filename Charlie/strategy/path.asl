// Get distance of thing from agent
@measure_distance_from_agent
+!measure_distance_from_agent(X_self, Y_self, Thing, Type, ThingDistances) <-
    .findall(
            point(Xd,Yd,Distance),
                (location(Thing,Type,Xd,Yd) &
                calculate_distance(X_self, Y_self, Xd, Yd, Distance)),
            ThingDistances
    ).

// To get shortest path to complete a given task with specific type
@find_optimal_plan
+!find_optimal_plan(X_self, Y_self, Type, plan(Xd_F,Yd_F,Xg_F,Yg_F,MinDist)) <-

    !measure_distance_from_agent(X_self, Y_self, dispenser, Type, DispenserDistances);
    .findall(
        plan(DispX, DispY, GoalX, GoalY, TotalDistance),
        (   .member(point(DispX, DispY, DispDist), DispenserDistances) &
            location(goal, _, GoalX, GoalY) &
            calculate_distance(DispX, DispY, GoalX, GoalY, GoalDist) &
            TotalDistance = DispDist + GoalDist
        ),
        AllPlans
    );
    .min(AllPlans, plan(Xd_F,Yd_F,Xg_F,Yg_F,MinDist)).

@find_optimal_plan_failed
-!find_optimal_plan(_,_,_, plan(null,null,null,null,null)) <- .print("No plan found!"); false.

// To calculate the manhattan distance between from/to X & Y
calculate_distance(X1, Y1, X2, Y2, Dist) :-
    Dist = math.sqrt(((X2 - X1)*(X2 - X1)) + ((Y2 - Y1)*(Y2 - Y1))).

@find_nearest_goal
+!find_nearest_goal(X_self, Y_self, Xg, Yg) <- 
    !measure_distance_from_agent(X_self, Y_self, goal, null, ThingDistances);
    .min(ThingDistances, point(Xg,Yg,Distance)).
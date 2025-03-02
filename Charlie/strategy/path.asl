// To get shortest path to complete a given task with specific type
+!find_optimal_plan(X_self, Y_self, Type, plan(Xd_F,Yd_F,Xg_F,Yg_F,MinDist)) <-

    .findall(
            point(Xd,Yd,Distance),
                (location(dispenser,Xd,Yd,Type) &
                calculate_distance(X_self, Y_self, Xd, Yd, Distance)),
            DispenserDistances
    );
    .findall(
        plan(DispX, DispY, GoalX, GoalY, TotalDistance),
        (   .member(point(DispX, DispY, DispDist), DispenserDistances) &
            location(goal, GoalX, GoalY, _) &
            calculate_distance(DispX, DispY, GoalX, GoalY, GoalDist) &
            TotalDistance = DispDist + GoalDist
        ),
        AllPlans
    );
    .min(AllPlans, plan(Xd_F,Yd_F,Xg_F,Yg_F,MinDist)).

-!find_optimal_plan(_,_,_, plan(null,null,null,null,null)) <- .print("No plan found!").

// To calculate the manhattan distance between from/to X & Y
calculate_distance(X1, Y1, X2, Y2, Dist) :-
    Dist = math.sqrt(((X2 - X1)*(X2 - X1)) + ((Y2 - Y1)*(Y2 - Y1))).
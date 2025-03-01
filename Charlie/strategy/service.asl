// Free direction around the agent
free_direction(n).
free_direction(s).
free_direction(e).
free_direction(w).

// To check the direction based on X & Y or get X & Y based on direction provided
check_direction(0, -1, n).
check_direction(0, 1, s).
check_direction(1, 0, e).
check_direction(-1, 0, w).
check_direction(0, 0, null).
check_direction(_, _, e).

// When agent is adjacent, no next direction
to_dispenser_direction(0, 1, null).
to_dispenser_direction(0, -1, null).
to_dispenser_direction(1, 0, null).
to_dispenser_direction(-1, 0, null).
// When agent is at location, move to adjacent (east)
to_dispenser_direction(0, 0, e).
// Condition 1: When agent is at the corner, move to adjacent position X = 1/-1
// Condition 2: Agent always move X position to location, then move Y
to_dispenser_direction(X, _, e):- X >= 1.
to_dispenser_direction(X, _, w):- X =< -1.
to_dispenser_direction(_, Y, s):- Y > 1.
to_dispenser_direction(_, Y, n):- Y < -1.

// Directions to rotate n(0) -> e(1) -> s(2) -> w(3), if From > To, then clockwise
direction(n, 0).
direction(e, 1).
direction(s, 2).
direction(w, 3).
rotation(F, T, cw) :- (T - F + 4) mod 4 < (F - T + 4) mod 4.
rotation(F, T, ccw) :- (T - F + 4) mod 4 > (F - T + 4) mod 4.
// Non-defined direction transitions
rotation(_, _, null).

to_goal_direction(X,_,w) :- X < 0.
to_goal_direction(X,_,e) :- X > 0.
to_goal_direction(_,Y,n) :- Y < 0.
to_goal_direction(_,Y,s) :- Y > 0.
to_goal_direction(_,_,null).
// Free direction around the agent
free_direction(n).
free_direction(s).
free_direction(e).
free_direction(w).

// To check the direction based on X & Y or get X & Y based on direction provided
// check_direction(0, -1, n).
// check_direction(0, 1, s).
// check_direction(1, 0, e).
// check_direction(-1, 0, w).
// check_direction(0, 0, null).
// check_direction(_, _, e).

check_direction(0,-1,n).
check_direction(0,1,s).
check_direction(1,0,e).
check_direction(-1,0,w).
check_direction(X,Y,e) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).
check_direction(0, 0, null).

get_dir_on(0,-1,s).
get_dir_on(0,1,n).
get_dir_on(1,0,w).
get_dir_on(-1,0,e).
get_dir_on(X,Y,null) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).

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
to_dispenser_direction(X, _, w):- X <= -1.
to_dispenser_direction(_, Y, s):- Y > 1.
to_dispenser_direction(_, Y, n):- Y < -1.

// // Directions to rotate n(0) -> e(1) -> s(2) -> w(3), if From > To, then clockwise
// direction(n, 0).
// direction(e, 1).
// direction(s, 2).
// direction(w, 3).
// rotation(F, T, cw) :- (T - F + 4) mod 4 < (F - T + 4) mod 4.
// rotation(F, T, ccw) :- (T - F + 4) mod 4 > (F - T + 4) mod 4.
// // Non-defined direction transitions
// rotation(_, _, null).
// // Get new direction after rotating(cw/ccw)
// rotating_dir(w, n, cw).
// rotating_dir(n, w, ccw).
// rotating_dir(F_Dir, T_Dir, cw) :- direction(F_Dir, F_Idx) & direction(T_Dir, F_Idx+1).
// rotating_dir(F_Dir, T_Dir, ccw) :- direction(F_Dir, F_Idx) & direction(T_Dir, F_Idx-1).


// // Wrapper of rotation for agent rotating for goal submission > 90 degrees
// goal_rotation(X, Y, Dir) :- rotating_dir(X, Y, Dir) & not(Dir == null).
// goal_rotation(_, _, Dir) :- Dir = ccw.

rotating_dir(n,e,ccw).
rotating_dir(n,w,cw).
rotating_dir(e,s,ccw).
rotating_dir(e,n,cw).
rotating_dir(s,w,ccw).
rotating_dir(s,e,cw).
rotating_dir(w,n,ccw).
rotating_dir(w,s,cw).
rotating_dir(n,n,null).
rotating_dir(e,e,null).
rotating_dir(s,s,null).
rotating_dir(w,w,null).

// 【needed_rotate_dir】 Predefined encapsulation of rotate_dir.
goal_rotation(DirA, DirB, RDir) :- rotating_dir(DirA, DirB, RDir).
goal_rotation(n,s,ccw).
goal_rotation(e,w,ccw).
goal_rotation(s,n,RDir).
goal_rotation(w,e,RDir).

// Rotate the opposite direction when obstacle meets at original rotation direction
obstacle_rotation(cw, ccw).
obstacle_rotation(ccw, cw).

// Goal directed moving direction
to_goal_direction(X,_,w) :- X < 0.
to_goal_direction(X,_,e) :- X > 0.
to_goal_direction(_,Y,n) :- Y < 0.
to_goal_direction(_,Y,s) :- Y > 0.
to_goal_direction(_,_,null).

// Calculation if direction should change in every 5 steps in exploration
dirch_step_calc(CStep,PStep) :- ((CStep - PStep ) mod 5) == 0.
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).
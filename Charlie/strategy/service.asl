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
to_dispenser_direction(X, Y, e):- X >= 1.
to_dispenser_direction(X, Y, w):- X =< -1.
to_dispenser_direction(X, Y, s):- Y > 1.
to_dispenser_direction(X, Y, n):- Y < -1.

// Directions to rotate
rotate_angle(n, e, cw).
rotate_angle(s, w, cw).
rotate_angle(e, s, cw).
rotate_angle(w, n, cw).

rotate_angle(n, w, ccw).
rotate_angle(s, e, ccw).
rotate_angle(e, n, ccw).
rotate_angle(w, s, ccw).

// Non-defined direction transitions
rotate_dir(_, _, null).
random_dir(DirList, RandomNumber, Dir) :-
(RandomNumber <= 0.25 & .nth(0, DirList, Dir))
| (RandomNumber <= 0.5 & .nth(1, DirList, Dir))
| (RandomNumber <= 0.75 & .nth(2, DirList, Dir))
| .nth(3, DirList, Dir).

position(X,Y)

!start.

+!start : true <-
.print("hello massim world.").

+step(StepCount) : true <-
.print("Received step percept: ", StepCount).

+!determine_action.

+actionID(ID) : true <-
.print("Determining my action").
!determine_action.

+thing(X, Y, Type, Details) : Type == dispenser <-
dispenser(X, Y).

+!determine_action : not dispenser(X, Y)
<-
!move_random.

+!determine_action : dispenser(X,Y)
<-
.print("Dispenser found at (", X, ",", Y, ")! Stopping random movement.").

+!move_random
: .random(RandomNumber) & random_dir([n,s,e,w], RandomNumber, Dir)
<-
move(Dir).

+!move : thing(0,0)

+!determine_action : true <-
skip.
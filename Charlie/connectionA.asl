/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).
position(0,0).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

+step(X) : true <-
	.print("Received step percept.").
	
+actionID(X) : true <- 
	.print("Determining my action");
	!move_random.
//	skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	
+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	if (Dir == w) {-position(X,Y); +position(X-1,Y);}
	elif (Dir == e) {-position(X,Y); +position(X+1,Y);}
	elif (Dir == s) {-position(X,Y); +position(X,Y+1);}
	elif (Dir == n) {-position(X,Y); +position(X,Y-1);}
	.print("X: ", X, ", Y:", Y );
	move(Dir).
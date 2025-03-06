+!action(Action, Param) <-
    if (Action == move) {
        !move(Param);
    }
    elif (Action == request) {
        !request_block(Param);
    }
    elif (Action == attach) {
        !attach(Param);
    }
    elif (Action == rotate) {
        !rotate(Param);
    }
    elif (Action == submit) {
        !rotate(Param);
    }.

+!move(Dir) <- 
    move(Dir).

+!request_block(Dir) <- 
    request(Dir).

+!attach_block(Dir) <-
    attach(Dir).

+!rotate(Rotation) <-
    rotate(Rotation).

+!submit(TaskName) <-
    submit(TaskName).
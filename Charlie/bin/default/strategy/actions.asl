+!action(Action, Param) <-

    .abolish(location(_, _, _, _));
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
        !submit(Param);
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
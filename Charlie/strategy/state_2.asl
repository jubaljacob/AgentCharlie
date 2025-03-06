+!handle_state(2) : true <-
    ?targetX(TargetX);
    ?targetY(TargetY);
    
    AdjX = math.abs(TargetX);
    AdjY = math.abs(TargetY);
    Adjacent = (AdjX == 1 & AdjY == 0) | (AdjX == 0 & AdjY == 1);
    
    !find_nearest_dispenser(0, 0, DispX, DispY, Type);
    +target_dispenser(Type, DispX, DispY);
    
    calculate_distance(0, 0, DispX, DispY, Distance);
    
    if (Distance \== 1) {
        -+state(explore);
    } else {
        if (DispX == -1 & DispY == 0) {
            !action(request, w);  // Request block from west
            +dir(w);
            -+state(3);
        } elif (DispX == 1 & DispY == 0) {
            !action(request, e);  // Request block from east
            +dir(e);
            -+state(3);
        } elif (DispX == 0 & DispY == 1) {
            !action(request, s);  // Request block from south
            +dir(s);
            -+state(3);
        } elif (DispX == 0 & DispY == -1) {
            !action(request, n);  // Request block from north
            +dir(n);
            -+state(3);
        }
    }
.
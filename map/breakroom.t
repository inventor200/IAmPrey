breakroom: Room {
    vocab = 'The Breakroom;break[weak];room[weak]'
    roomTitle = 'The Breakroom'
    desc =
    "The room is lit by a single light in the middle of the ceiling,
    acting almost like a spotlight for the table below it.\b
    A fridge sits in the southwest corner,
    while a counter is against the north wall.
    A locker sits against the west wall. "

    northMuffle = serverRoomBottom
    eastMuffle = deliveryRoom
    westMuffle = utilityPassage

    mapModeDirections = [&south]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}
+breakRoomFridge: Fridge;
++AwkwardFloorHeight;
+CounterTop;
+StorageLocker;
++AwkwardFloorHeight;
++JumpOverLink -> breakRoomFridge;
++JumpOverLink -> CounterTop;
+Chair
    homeDesc = "The chair sits <<homePhrase>>. "
    homePhrase = 'between the counter and the table'
;
+breakroomTable: Table;
++JumpOverLink -> breakRoomFridge;
++Trinket { 'bowl;of[prep] kelp[n]'
    "A small bowl of pale kelp slices. "
    contType = In
    isLikelyContainer() {
        return nil;
    }

    bulk = 1
}
+++Trinket { 'pale kelp slices;;slice'
    "A few slices of pale kelp remain in the bowl. "
    isFixed = true
    plural = true

    cannotTakeMsg =
        '{I} can hardly eat these, and the smell{dummy} would follow {me} everywhere. '

    smellDesc = "They smell leafy. "
    tasteDesc = "They taste both bitter and sour, in the worst way imaginable. "

    dobjFor(Eat) {
        verify() {
            illogical('{I} try to eat one, but cannot bring {myself} to actually do it. ');
        }
    }
}
++Trinket { 'ceramic plate;;platter'
    "A ceramic place. "

    bulk = 1
}
+++Trinket { 'trophy;;figurine'
    "It's a little hand-made clay trophy, painted black, with
    ornate patterns of shiny, golden linework.
    It's in the shape of a humanoid, crouched in defiance. "

    bulk = 1
}

DefineDoorSouthTo(southHall, breakroom, 'the Breakroom door')
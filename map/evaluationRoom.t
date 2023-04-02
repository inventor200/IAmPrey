evaluationRoom: Room {
    vocab = 'The Evaluation Room;eval'
    roomTitle = 'The Evaluation Room'
    desc =
    "This room is mostly empty space, observed from the north through a window.
    Storage shelves, weapon racks, and a locker line the south wall, while
    a projector screen covers most of the east wall.
    The southern half of the room has a gym mat, for cushioning impacts. "

    northMuffle = labB
    eastMuffle = storageBay

    regions = [labEvalSightLine]

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == northDir) return windowInevaluationRoom;
        return inherited(dirObj);
    }

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}
+Decoration { 'gym mats;wrestling gel;mat'
    "Thick gel mats, which can provide protection against floor impacts. "
    plural = true
}
+evaluationShelves: MetalShelves;
++AwkwardFloorHeight;
++JumpOverLink -> StorageLocker;
+WeaponRack;
+StorageLocker;
++AwkwardFloorHeight;

DefineDoorWestTo(eastHall, evaluationRoom, 'the Evaluation Room door;eval')
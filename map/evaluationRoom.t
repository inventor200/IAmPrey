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
+FakePlural, Decoration { 'gym mats;wrestling gel one[weak] of[prep];mat'
    "Thick gel mats, which can provide protection against floor impacts. "
    fakeSingularPhrase = 'gym mat'
}
+evaluationShelves: MetalShelves;
++AwkwardFloorHeight;
++JumpOverLink -> evaluationLocker;
+WeaponRack;
+evaluationLocker: StorageLocker;
++AwkwardFloorHeight;

DefineDoorWestTo(eastHall, evaluationRoom, 'the Evaluation Room door;eval')
evaluationRoom: Room { 'The Evaluation Room'
    "TODO: Add description. "

    northMuffle = labB
    eastMuffle = storageBay

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == northDir) return windowInevaluationRoom;
        return inherited(dirObj);
    }

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}

DefineDoorWestTo(eastHall, evaluationRoom, 'the Evaluation Room door')
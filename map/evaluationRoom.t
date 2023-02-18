evaluationRoom: Room { 'The Evaluation Room'
    "TODO: Add description. "

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == northDir) return windowInevaluationRoom;
        return inherited(dirObj);
    }
}

DefineDoorWestTo(eastHall, evaluationRoom, 'the evaluation room door')
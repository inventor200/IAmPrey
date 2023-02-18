labEvalSightLine: HallRegion;

labB: Room { 'Lab B'
    "TODO: Add description. "

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == southDir) return windowInlabB;
        return inherited(dirObj);
    }
}

DefineWindowPair(evaluationRoom, labB)
    vocab = 'observation window;reinforced evaluation eval evaluator\'s viewing lab'
    desc = "TODO: Add description. "
    breakMsg = 'The window is reinforced, and designed to resist creatures like you. '
    remoteHeader = 'through the window'
;

DefineDoorWestTo(northeastHall, labB, 'the door to[weak] lab B[weak]')
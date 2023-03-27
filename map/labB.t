labEvalSightLine: WindowRegion;

labB: Room { 'Lab B'
    "TODO: Add description. "

    northMuffle = loadingArea
    eastMuffle = storageBay
    southMuffle = evaluationRoom

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == southDir) return windowInlabB;
        return inherited(dirObj);
    }

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
}

DefineWindowPair(evaluationRoom, labB)
    vocab = 'observation window;reinforced evaluation eval evaluator\'s viewing lab glass;glass pane'
    desc = "TODO: Add description. "
    breakMsg = 'The window is reinforced,
        and designed to resist{dummy} creatures like {me}. '
    remoteHeader = 'through the window'
;

DefineDoorWestTo(northeastHall, labB, 'the door[n] to[prep] Lab[n] B[weak]')
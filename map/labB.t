labEvalSightLine: WindowRegion;

labB: Room { 'Lab B'
    "The Lab is fairly large, but mostly empty. In front of the window to the south,
    there is a lone table. A whiteboard covers the east wall. "

    northMuffle = loadingArea
    eastMuffle = storageBay
    southMuffle = evaluationRoom

    regions = [labEvalSightLine]

    getSpecialPeekDirectionTarget(dirObj) {
        if (dirObj == southDir) return windowInlabB;
        return inherited(dirObj);
    }

    mapModeDirections = [&west]
    familiar = roomsFamiliarByDefault
    roomNavigationType = killRoom
}

+labBTable: Table;
++Decoration { 'microphone;mic;mic stand'
    "A small microphone on a stand. "
}
+Whiteboard {
    hasWriting = true
    writtenDesc() {
        "THIS IS NOT LIBERATION! THIS IS A SIEGE!";
        return true;
    } 
}

DefineWindowPair(evaluationRoom, labB)
    vocab = 'observation window;reinforced evaluation eval evaluator\'s viewing lab glass;glass pane'
    desc = "The window looks like it's supposed to be make of one-way glass, but there's enough
    light in both rooms to make it transparent. "
    breakMsg = 'The window is reinforced,
        and designed to resist{dummy} creatures like {me}. '
    remoteHeader = 'through the window'
;

DefineDoorWestTo(northeastHall, labB, 'the door[n] to[prep] Lab[n] B[weak]')
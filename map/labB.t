labEvalSightLine: HallRegion;

labB: Room { 'Lab B'
    "TODO: Add description. "

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }
}

+labWindowLabSide: Fixture { 'window'
    "TODO: Add description. "

    canLookThroughMe = true
    skipInRemoteList = true
    breakMsg = 'The window is reinforced, and designed to resist creatures like you. '

    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(Search) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        action() { }
        report() {
            evaluationRoom.observeFrom(gActor, 'through the window');
        }
    }

    dobjFor(Break) {
        validate() {
            illogical(breakMsg);
        }
    }
}

DefineDoorWestTo(northeastHall, labB, 'the door to[weak] lab B[weak]')
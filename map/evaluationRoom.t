evaluationRoom: Room { 'The Evaluation Room'
    "TODO: Add description. "

    regions = [labEvalSightLine]

    descFrom(pov) {
        "TODO: Add remote description. ";
    }
}

+labWindowEvalSide: Fixture {
    vocab = labWindowLabSide.vocab
    desc = labWindowLabSide.desc

    canLookThroughMe = true
    skipInRemoteList = true

    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(Search) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        action() { }
        report() {
            labB.observeFrom(gActor, 'through the window');
        }
    }

    dobjFor(Break) {
        validate() {
            illogical(labWindowLabSide.breakMsg);
        }
    }
}

DefineDoorWestTo(eastHall, evaluationRoom, 'the evaluation room door')
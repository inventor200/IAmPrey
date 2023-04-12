class Sink: Fixture {
    vocab = 'sink;metal'
    desc = "A simple, metal sink. "
    maxSingleBulk = 2
    bulkCapacity = 4

    faucet = nil
    water = nil

    waterNoiseDaemon = nil

    startWaterNoise() {
        if (waterNoiseDaemon != nil) return;
        waterNoiseDaemon = new Daemon(self, &doRunningWaterNoise, 0);
    }

    endWaterNoise() {
        if (waterNoiseDaemon == nil) return;
        waterNoiseDaemon.removeEvent();
    }

    doRunningWaterNoise() {
        soundBleedCore.createSound(
            runningWaterNoiseProfile,
            faucet,
            getOutermostRoom(),
            true
        );
        soundBleedCore.createSound(
            runningWaterNoiseProfile,
            faucet,
            getOutermostRoom(),
            nil
        );
    }

    contType = In

    specialDesc() {
        if (!faucet.isRunning) return nil;
        "\^<<theName>> has water running from its faucet. ";
        return true;
    }

    isLikelyContainer() {
        return true;
    }

    dobjFor(SwitchVague) { remap = faucet }
    dobjFor(TurnOn) { remap = faucet }
    dobjFor(SwitchOn) { remap = faucet }
    dobjFor(Open) { remap = faucet }
    dobjFor(TurnOff) { remap = faucet }
    dobjFor(SwitchOff) { remap = faucet }
    dobjFor(Close) { remap = faucet }
}

runningWaterNoiseProfile: SoundProfile {
    'the muffled noise of running water'
    'the nearby noise of running water'
    'the reverberating noise of running water'
    strength = 3

    afterEmission(room) {
        say('<.p>(Emitted running water in <<room.roomTitle>>.)<.p>');
    }
}

DefineDistComponentFor(RunningWater, Sink)
    vocab = 'water;running;stream runnel runnels'
    desc() {
        if (isRunning) {
            "Clean water runs from the faucet. ";
        }
        else {
            noWaterMsg();
        }
    }
    listenDesc() {
        if (isRunning) {
            "Running water makes quite the audible noise! ";
        }
        else {
            if (!gActionIs(ListenTo)) return;
            noWaterMsg();
        }
    }
    tasteDesc() {
        if (isRunning) {
            "The water tastes chilly and clean! ";
        }
        else {
            noWaterMsg();
        }
    }

    isRunning = (
        lexicalParent.faucet.isRunning
    )

    noWaterMsg() {
        "{I} see no running water. ";
    }

    postCreate(_lexParent) {
        _lexParent.water = self;
    }

    dobjFor(Drink) {
        preCond = [touchObj]
        verify() {
            if (!isRunning) {
                illogical('No water is running out of the faucet. ');
            }
        }
        check() { }
        action() { }
        report() {
            "Refreshing! ";
        }
    }

    dobjFor(SwitchVague) { remap = lexicalParent.faucet }
    dobjFor(TurnOn) { remap = lexicalParent.faucet }
    dobjFor(SwitchOn) { remap = lexicalParent.faucet }
    dobjFor(Open) { remap = lexicalParent.faucet }
    dobjFor(TurnOff) { remap = lexicalParent.faucet }
    dobjFor(SwitchOff) { remap = lexicalParent.faucet }
    dobjFor(Close) { remap = lexicalParent.faucet }
;

DefineDistComponentFor(Faucet, Sink)
    vocab = 'faucet;;spigot tap'
    desc = "A silvery faucet.<<if isRunning>>
    Water steadily streams from it, with an audible sound.<<end>> "
    isRunning = nil

    postCreate(_lexParent) {
        _lexParent.faucet = self;
    }

    dobjFor(SwitchVague) {
        preCond = [touchObj]
        verify() { }
        check() { }
        action() {
            if (isRunning) {
                doNested(Close, self);
            }
            else {
                doNested(Open, self);
            }
        }
        report() { }
    }

    dobjFor(TurnOn) asDobjFor(Open)
    dobjFor(SwitchOn) asDobjFor(Open)
    dobjFor(Open) {
        preCond = [touchObj]
        verify() {
            if (isRunning) {
                illogicalNow('The faucet is already expelling water. ');
            }
            if (gActorIsPrey) {
                if (huntCore.pollTrick(&distractingSinkCount) == noTricksRemaining) {
                    illogical(
                        '<<gSkashekName>> probably won\'t
                        let another sink distract him again.'
                    );
                }
            }
        }
        check() { }
        action() {
            isRunning = true;
            "{I} open the tap, and water begins running out of the faucet. ";
            lexicalParent.startWaterNoise();
            if (gCatMode) return;
            local tricksLeft = huntCore.spendTrick(&distractingSinkCount);
            switch (tricksLeft) {
                case noTricksRemaining:
                    "Distracting <<gSkashekName>> with running water
                    probably isn't going to work again, after this. ";
                    break;
                case oneTrickRemaining:
                    "{I} suspect this little distraction will only work
                    one more time. <<gSkashekName>> might be losing patience
                    by now. ";
                    break;
            }
        }
        report() { }
    }

    dobjFor(TurnOff) asDobjFor(Close)
    dobjFor(SwitchOff) asDobjFor(Close)
    dobjFor(Close) {
        preCond = [touchObj]
        verify() {
            if (!isRunning) {
                illogicalNow('No water runs out of the faucet. ');
            }
        }
        check() { }
        action() {
            isRunning = nil;
            "{I} close the tap, and water ceases to run out of the faucet. ";
            lexicalParent.endWaterNoise();
        }
        report() { }
    }
;

class PluralSink: FakePlural, Sink {
    vocab = 'sinks;metal one[weak] of[prep];sink'
    desc = "Simple, metal sinks, all built to factory standard. "
    fakeSingularPhrase = 'sink'
}

class PluralShower: FakePlural, Fixture {
    vocab = 'shower stalls;shower[weak] communal one[weak] of[prep];stalls shower stall'
    desc = "A cluster of open, communal shower stalls. "
    betterStorageHeader
    fakeSingularPhrase = 'shower stall'
    isEnterable = true
    isOpenable = nil

    contType = In

    isLikelyContainer() {
        return true;
    }

    noWaterFlowMsg =
        'It seems like water doesn\'t flow into the showers right now. '

    dobjFor(SwitchVague) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(TurnOn) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(SwitchOn) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(Open) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(TurnOff) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(SwitchOff) { verify() { illogical(noWaterFlowMsg); } }
    dobjFor(Close) { verify() { illogical(noWaterFlowMsg); } }
}

DefineDistComponentFor(ShowerHead, PluralShower)
    vocab = 'shower[weak] head;metal'
    desc = "A conical, metal shower head. It seems like they've
    been used recently, but they're bone-dry right now. "
    isDecoration = true
;

class PluralToilet: FakePlural, FixedPlatform {
    vocab = 'toilets;toilet[weak] metal one[weak] of[prep];seats toilet seat'
    desc = "A row of round, metal toilets. "
    betterStorageHeader
    fakeSingularPhrase = 'toilet'

    contType = In

    isLikelyContainer() {
        return true;
    }
}
cloneQuarters: Room { 'Clone Sleeping Quarters'
    "TODO: Add description. "

    north = southEnrichmentRoomDoorExterior

    muffleEast = utilityPassage
    southMuffle = southHall
}

+southEnrichmentRoomDoorExterior: Door { 'the enrichment room door'
    desc = standardDoorDescription
    otherSide = southEnrichmentRoomDoorInterior
    soundSourceRepresentative = southEnrichmentRoomDoorInterior
}

+southeastCloneBed: Fixture { 'southeast[weak] bed;se[weak] bunk;cot'
    "TODO: Add description. "

    remapOn: SubComponent {
        betterStorageHeader
        canLieOnMe = true
        isEnterable = true
        isBoardable = true
        isClimbable = true

        dobjFor(ParkourClimbOverInto) asDobjFor(Board)
        dobjFor(Climb) asDobjFor(Board)
    }
    remapUnder: SubComponent {
        betterStorageHeader
        canSlideUnderMe = true

        hiddenUnder = [holeUnderBedDiscovery]

        dobjFor(SlideUnder) {
            preCond = [touchObj, actorInStagingLocation]
            verify() {
                if (gActor.isIn(self)) {
                    illogicalNow(actorAlreadyOnMsg);
                }
            }
            check() { checkInsert(gActor); }
            action() {
                parkourCore.cacheParkourRunner(gActor);
                gParkourRunner.actionMoveInto(self);
                if (!underBedWallPipes.revealedUnderBed) {
                    doNested(LookUnder, southeastCloneBed);
                }
            }
            report() {
                "{I} crawl{s/ed} under {the dobj}. ";
            }
        }

        dobjFor(GetOutOf) {
            verify() {
                if (!gActor.isIn(self)) {
                    illogicalNow('{I} {am} not under {the dobj}. ');
                }
            }
        }

        canBonusReachDuring(obj, action) {
            return obj == underBedWallPipes && underBedWallPipes.revealedUnderBed;
        }

        doStandardLook(prep, hiddenPrep, hiddenProp, lookPrepMsgProp) {
            inherited(prep, hiddenPrep, hiddenProp, lookPrepMsgProp);
            // This is here to facilitate the discovery message, but needs
            // to be removed afterward.
            if (holeUnderBedDiscovery.isIn(southeastCloneBed.remapUnder)) {
                holeUnderBedDiscovery.moveInto(nil);
            }
        }
    }

    dobjFor(ParkourClimbOverInto) asDobjFor(Board)
    dobjFor(Climb) asDobjFor(Board)
    dobjFor(Board) {
        remap = remapOn
    }

    dobjFor(Enter) {
        remap = remapOn
    }

    dobjFor(SlideUnder) {
        remap = remapUnder
    }

    dobjFor(GetOutOf) {
        remap = (gActor.isIn(remapUnder) ? remapUnder : remapOn)
    }
}

#define cloneQuartersPipesVocab 'hole[n] under[prep] the bed;in[prep] the wall[n];tubing tubes pipes'

missingUnderBedWallPipes: Unthing { cloneQuartersPipesVocab
    'The hole {i} saw in the utility corridor should be somewhere in this
        room, but {i} {do} not {know} where... '
}

unreachableUnderBedWallPipes: Unthing { cloneQuartersPipesVocab
    'The secret hole with the pipes is found under the bed. '
}

underBedWallPipes: PassablePipes { cloneQuartersPipesVocab
    desc = "TODO: Add description. "
    destination = utilityPassage
    oppositeLocalPlatform = utilityWallPipes
    stagingLocation = southeastCloneBed.remapUnder
    exitLocation = southeastCloneBed.remapUnder
    requiresPeekAngle = true

    spottedHoleFromOtherSide = nil
    revealedUnderBed = nil
    isHidden = (!gPlayerChar.isIn(stagingLocation))

    spotFromOtherSide() {
        if (spottedHoleFromOtherSide) return;
        spottedHoleFromOtherSide = true;
        missingUnderBedWallPipes.moveInto(cloneQuarters);
    }

    revealUnderBed() {
        if (revealedUnderBed) return;
        revealedUnderBed = true;
        if (spottedHoleFromOtherSide) {
            missingUnderBedWallPipes.moveInto(nil);
        }
        moveInto(cloneQuarters);
        unreachableUnderBedWallPipes.moveInto(cloneQuarters);
    }

    dobjFor(LookThrough) {
        preCond = [objVisible, touchObj, actorHasPeekAngle]
        action() {
            utilityWallPipes.foundOtherSide = true;
        }
        report() {
            utilityPassage.observeFrom(gActor, utilityWallPipes.remoteHeader);
        }
    }
}

holeUnderBedDiscovery: Thing { 'hole with some pipes on the other side'
    "Lol, you should not be able to read this right now. "

    moveInto(loc) {
        if (loc != nil) {
            if (loc.getOutermostRoom() == cloneQuarters) {
                underBedWallPipes.revealUnderBed();
            }
        }
        inherited(loc);
    }
}

DefineDoorWestTo(southwestHall, cloneQuarters, 'the clone sleeping quarters door')
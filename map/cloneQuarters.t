cloneQuarters: Room { 'Clone Sleeping Quarters'
    "TODO: Add description. "

    north = southEnrichmentRoomDoorExterior

    muffleEast = utilityPassage
    //southeastMuffle = southwestishHall

    ceilingObj = industrialCeiling
    floorObj = carpetedFloor

    mapModeDirections = [&north, &west]
    familiar = roomsFamiliarByDefault
}

+southEnrichmentRoomDoorExterior: PrefabDoor { 'the Enrichment Room door'
    desc = standardDoorDescription
    otherSide = southEnrichmentRoomDoorInterior
    soundSourceRepresentative = southEnrichmentRoomDoorInterior
    pullHandleSide = nil
}

+southeastCloneBed: Fixture { 'southeast bed;se bunk;cot'
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
        isHidingSpot = true

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
                "{I} crawl{s/ed} under {the dobj}.<.p>";
                underBedWallPipes.specialDesc();
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

        finalizeSearch(searchAction) {
            if (searchAction.ofKind(LookUnder)) {
                // This is here to facilitate the discovery message, but needs
                // to be removed afterward.
                if (holeUnderBedDiscovery.isIn(southeastCloneBed.remapUnder)) {
                    holeUnderBedDiscovery.moveInto(nil);
                }
                underBedWallPipes.revealUnderBed();
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

#define cloneQuartersPipesVocab 'hole[n] in[prep] the wall[n];under[prep] the bed[weak] exposed;tubing tubes pipes'
#define pipesMatchList ['hole', 'pipes', 'wall', 'tubing', 'tubes', 'pipes']

missingUnderBedWallPipes: Unthing { cloneQuartersPipesVocab
    'The hole {i} saw in the utility corridor should be somewhere in this
        room, but {i} {do} not {know} where... '
    
    matchPhrases = pipesMatchList
}

unreachableUnderBedWallPipes: Unthing { cloneQuartersPipesVocab
    'The secret hole with the pipes is found under the bed. '
    
    matchPhrases = pipesMatchList
}

underBedWallPipes: PassablePipes { cloneQuartersPipesVocab
    desc = "TODO: Add description. "
    destination = utilityPassage
    oppositeLocalPlatform = utilityWallPipes
    stagingLocation = southeastCloneBed.remapUnder
    exitLocation = southeastCloneBed.remapUnder
    requiresPeekAngle = true
    plural = nil

    spottedHoleFromOtherSide = nil
    revealedUnderBed = nil
    isHidden = (!gPlayerChar.isIn(stagingLocation))

    specialDesc = "Some pipes are exposed through a hole under this bed. "
    
    matchPhrases = pipesMatchList

    travelDesc = "<<if gCatMode
        >>{I} easily slip between the pipes in the wall<<else
        >>It's a tight squeeze, but {i} manage to fit between the pipes
        in the wall<<end>>, and find {myself} standing in the utility
        corridor, on the other side. "

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
        southeastCloneBed.remapUnder.fakeContents = [underBedWallPipes];
        secretLocalPlatform = nil;
        oppositeLocalPlatform.secretLocalPlatform = nil;
    }

    dobjFor(LookThrough) {
        preCond = [objVisible, touchObj, actorHasPeekAngle]
        action() {
            utilityWallPipes.foundOtherSide = true;
        }
        report() {
            handleCustomPeekThrough(utilityPassage, utilityWallPipes.remoteHeader);
        }
    }
}

holeUnderBedDiscovery: Thing { 'discovered pipes'
    "Lol, you should not be able to read this right now. "

    discoveryPhrase = 'hole in the wall, with some pipes on the other side'
    aName = 'a <<discoveryPhrase>>'
    theName = 'the <<discoveryPhrase>>'
    name = (discoveryPhrase)

    abcName(action, role) {
        return discoveryPhrase;
    }

    /*moveInto(loc) {
        if (loc != nil) {
            if (loc.getOutermostRoom() == cloneQuarters) {
                underBedWallPipes.revealUnderBed();
            }
        }
        inherited(loc);
    }*/
}

DefineDoorWestTo(southwestHall, cloneQuarters, 'the Clone Sleeping Quarters door')
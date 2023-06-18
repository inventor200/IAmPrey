hangarSightLine: HallRegion;

storageBay: Room { 'The Storage Bay'
    "The Bay connects seamlessly to the Hangar,
    with only a massive, pressure membrane keeping both areas distinct.
    The space is mostly littered with empty, plastic pallets.\b
    To the <<hyperDir('west')>> is the Loading Area, and the <b>Emergency
    Airlock</b> is visible on the <<hyperDir('east')>> side of the Hangar. "

    west = loadingArea
    north = wasteProcessingEntry
    south = freezerNorthEntry

    westMuffle = labB
    southwestMuffle = evaluationRoom

    regions = [hangarSightLine]
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    ambienceObject = hangarAmbience

    roomDaemon() {
        checkRoomDaemonTurns;
        northFreezerFog.rollingDesc(freezerNorthEntry);
        inherited();
    }

    mapModeDirections = [&west, &south, &east]
    mapModeLockedDoors = [wasteProcessingEntry]
    familiar = roomsFamiliarByDefault
    roomNavigationType = bigRoom
}

+wasteProcessingEntry: MaintenanceDoor { 'the waste processing door'
    desc = lockedDoorDescription
    otherSide = southUtilityPassageExit
    travelBarriers = [wasteProcessingBarrier]
    pullHandleSide = true
}

wasteProcessingBarrier: TravelBarrier {
    canTravelerPass(actor, connector) {
        return actor == skashek || !connector.isOpen;
    }
    
    explainTravelBarrier(actor, connector) {
        "<<gSkashekName>> has apparently modified the facility
        into a game arena. Though he{dummy} is hunting {me}, he has also
        crafted a <q>fair</q> environment, as it includes a means
        of escape.\b
        Whatever waits on the other side of <i>that door</i>,
        however, would be the <i>purest</i> expression of desperate
        evasion, <i>with zero chances of survival</i>.\b
        Maybe {i} should take {my} chances with the plausible exit
        that <<gSkashekName>> has permitted, and remain on <i>this</i>
        side of the door... ";
    }
}

hangar: Room { 'The Hangar'
    "The Hangar boasts the highest of ceilings, and is separated from
    the Storage Bay (<<hyperDir('west')>>) by a pressure membrane.\b
    To the <<hyperDir('east')>> is the Emergency Airlock. "

    regions = [hangarSightLine]

    east = airlockInsideEntry
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    ambienceObject = hangarAmbience

    mapModeDirections = [&west, &east]
    familiar = roomsFamiliarByDefault
    roomNavigationType = bigRoom
}

/*
#if __DEBUG_SUIT
+testWearObstruction: Thing {
    'wear obstruction'
    "Just something to really get in the way of WEAR ALL! "
    bulk = 2
}
#endif
*/

+airlockInsideEntry: PrefabDoor { 'the Emergency Airlock door'
    airlockDoorDesc
    otherSide = airlockInsideExit

    airlockDoor = true
    isTransparent = true
    canSlamMe = nil

    canTravelerPass(actor) {
        if (emergencyAirlock.allPartsPrepared()) return true;
        return skashek.isChasing();
    }
    
    explainTravelBarrier(actor) {
        "The Airlock might as well be called <q>Slaughterhouse</q> while
        <<gSkashekName>> is still chasing me. {I} need to lose him, first! ";
    }
}

DefineBrokenWindowPairLookingAway(east, west, hangar, storageBay)
    vocab = 'pressure membrane;plastic rubber greasy marked[weak];veil curtain sheet slit'
    desc = "A colossal membrane divides the area into two sections: The Storage Bay, and Hangar.
    The membrane is organic, and has reflexes to seal off the Hangar, in the event of a poison
    gas contamination event. It's transparent, and gives everything behind it a blurry, streaky effect.\b
    There is a single, large slit in the middle, which can be passed through. It jiggles a little, as the
    surface is still very alive. "
    feelDesc = "It feels greasy, like a giant, lubricated condom. "
    breakMsg = 'The membrane absolutely refuses to be torn, cut, or sliced in any way. '
    remoteHeader = 'through the membrane'
    travelDesc = "{I} pass{es/ed} through a marked slit
        in the greasy pressure membrane. "
;

wasteProcessing: Room { 'Waste Processing'
    "An ominous, dark corridor. It does not likely connect to
    the rest of the facility, so entry might be more of a death
    trap than a valid escape route. "

    south = wasteProcessingExit
    
    floorObj = cementFloor
    ceilingObj = industrialCeiling
    ambienceObject = industrialAmbience
    mapModeLockedDoors = [wasteProcessingExit]
}

+wasteProcessingExit: MaintenanceDoor { 'the waste processing exit'
    desc = lockedDoorDescription
    otherSide = wasteProcessingEntry
    soundSourceRepresentative = wasteProcessingEntry
    pullHandleSide = nil
}

emergencyAirlock: Room { 'The Emergency Airlock'
    "The emergency airlock is a cramped tube, full of bright colors,
    allowing anyone to identify it in a hurry. "

    east = airlockOutsideExit
    west = airlockInsideExit

    mapModeDirections = [&east, &west]
    familiar = roomsFamiliarByDefault
    ambienceObject = tileAmbience

    hasAllSuitParts = nil
    suitReportMsg = ''

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
        if (!traveler.isOrIsIn(gPlayerChar)) return;
        hasAllSuitParts = allPartsPrepared();
        local strBfr = new StringBuffer(32);
        strBfr.append(
            '{I} need all seven pieces of the
            envirosuit in {my} inventory, before
            {i} can leave!\b'
        );
        suitReportMsg = '{I} need all seven pieces of the
            envirosuit in {my} inventory, before
            {i} can leave!\b' + suitTracker.getProgressLists() + '<.p>';
        
        if (hasAllSuitParts) {
            local chasedBySkashek = (skashek.getOutermostRoom() == hangar);
            
            local heldVector = new Vector(16);
            local dirHeld = gPlayerChar.directlyHeld;

            for (local i = 1; i <= dirHeld.length; i++) {
                local item = dirHeld[i];
                if (item == enviroSuitBag) continue;
                if (enviroSuitBag.affinityFor(item) <= 90) {
                    heldVector.appendUnique(item);
                }
            }

            if (gPlayerChar.outfit != nil) {
                heldVector.appendUnique(gPlayerChar.outfit);
                gPlayerChar.outfit.makeWorn(nil);
                gPlayerChar.outfit = nil;
            }

            if (gPlayerChar.canReach(enviroSuitBag)) {
                for (local i = 1; i <= enviroSuitBag.remapIn.contents.length; i++) {
                    local item = enviroSuitBag.remapIn.contents[i];
                    if (enviroSuitBag.affinityFor(item) <= 90) {
                        heldVector.appendUnique(item);
                    }
                }
            }

            if (heldVector.length == 0) return;

            for (local i = 1; i <= heldVector.length; i++) {
                heldVector[i].actionMoveInto(hangar);
            }

            if (heldVector.length > 0) {
                if (chasedBySkashek) {
                    "<.p>
                    {I} suppose {i} do not need to bring <i>everything</i>{dummy}
                    with {me}, so {i} decide to throw
                    <<smartInventoryCore.getList(heldVector)>> at <<gSkashekName>>,
                    which makes for a competent distraction!\b
                    <q>Prey!</q> he shouts, batting away <<heldVector[1].theName>>.
                    <q>Your aim is <i>fine</i>, but your technique is <i>abysmal!</i></q>
                    <.p>";
                }
                else {
                    "<.p>
                    {I} leave
                    <<smartInventoryCore.getList(heldVector)>>
                    behind for another Prey to use, so we may all
                    have the same opportunities to escape.
                    <.p>";
                }
            }
        }
    }

    travelerLeaving(traveler, destination) {
        inherited(traveler, destination);
        if (!traveler.isOrIsIn(gPlayerChar)) return;
        if (destination != hangar) return;
        if (!wearingParts()) return;

        local applicableParts = new Vector(8);

        for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
            local piece = suitTracker.missingPieces[i];
            if (piece.wornBy == nil) continue;
            applicableParts.append(piece);
        }

        smartInventoryCore.performOperationOn(operationDoffItems, applicableParts);

        "{I} cannot risk damaging the suit,
        or letting it{dummy} weigh {me} down.<.p>";
    }

    allPartsPrepared() {
        for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
            local piece = suitTracker.missingPieces[i];
            if (piece.isIn(gPlayerChar)) continue;
            if (piece.getOutermostRoom() == emergencyAirlock) continue;
            return nil;
        }
        return true;
    }

    wearingParts() {
        for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
            if (suitTracker.missingPieces[i].wornBy == gPlayerChar) return true;
        }
        return nil;
    }
}

+airlockInsideExit: PrefabDoor { 'the inner exit door'
    airlockDoorDesc
    otherSide = airlockInsideEntry
    soundSourceRepresentative = airlockInsideEntry

    airlockDoor = true
    isTransparent = true
    canSlamMe = nil
}

+airlockOutsideExit: PrefabDoor { 'the outer exit door'
    airlockDoorDesc
    otherSide = airlockOutsideEntry
    soundSourceRepresentative = airlockOutsideEntry

    airlockDoor = true
    canSlamMe = nil

    dobjFor(Open) {
        verify() {
            if (!emergencyAirlock.hasAllSuitParts) {
                illogical(emergencyAirlock.suitReportMsg);
                return;
            }
            logical;
        }
        action() {
            local needToWearList = [];

            for (local i = 1; i <= suitTracker.missingPieces.length; i++) {
                local piece = suitTracker.missingPieces[i];
                if (piece.wornBy == gPlayerChar) continue;
                needToWearList += piece;
            }

            if (needToWearList.length > 0) {
                "<.p><i>({I} first put on the
                <<makeListStr(valToList(needToWearList), &shortName, 'and')>>.)</i><.p>";
            }

            epilogueCore.leaveFacility();
        }
        report() { }
    }
}

fakeOutside: Room { 'Outside the Facility'
    "Ominous toxic fumes fill the air; a measure taken by
    those{dummy} who wanted to control {me}.
    Luckily, the suit{dummy} allows
    {me} to walk through it all. "

    west = airlockOutsideEntry

    mapModeDirections = [&west]
}

+airlockOutsideEntry: PrefabDoor { 'the outer Airlock door'
    airlockDoorDesc
    otherSide = airlockOutsideExit

    airlockDoor = true
    canSlamMe = nil
}
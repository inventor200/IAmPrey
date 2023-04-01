modify TravelConnector {
    // If the player attempts travel through a trapped connector, they die.
    isTrapped = nil

    setTrap(stat) { }

    mostLikelyDestination() {
        return destination.getOutermostRoom();
    }

    execTravel(actor, traveler, conn) {
        evaluateTrapsAndTracks(actor);
        inherited(actor, traveler, conn);
    }

    evaluateTrapsAndTracks(actor) {
        if (!skashekAIControls.isNoTargetMode) {
            if (actor == gPlayerChar && isTrapped) {
                if (actor.getOutermostRoom() == skashek.getOutermostRoom()) {
                    actor.springInteriorTrap();
                }
                else {
                    actor.springExteriorTrap();
                }
                return;
            }
        }
        if (actor == gPlayerChar) {
            if (skashek.canSee(actor)) {
                skashek.informLikelyDestination(mostLikelyDestination());
            }
        }
    }
}

modify Door {
    isPlayerTrapped = nil

    getTrappedStatus() {
        return isTrapped || isPlayerTrapped;
    }

    setTrap(stat) {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        <<if stat>>TRAP SET:<<else
        >>TRAP CLEARED:<<end>> <<theName>>
        <.p>";
        #endif
        isTrapped = stat;
        if (otherSide != nil) otherSide.isTrapped = stat;
    }

    setPlayerTrap(stat) {
        isPlayerTrapped = stat;
        if (otherSide != nil) otherSide.isPlayerTrapped = stat;
    }

    execTravel(actor, traveler, conn) {
        evaluateTrapsAndTracks(actor);
        setPlayerTrap(nil);
        local oldRoom = actor.getOutermostRoom();
        local slamsLeft = huntCore.pollTrickNumber(&closeDoorCount);
        local startedInSameRoom =
            oldRoom == skashek.getOutermostRoom();

        inherited(actor, traveler, conn);

        local newRoom = actor.getOutermostRoom();
        if (
            oldRoom != newRoom &&
            actor == gPlayerChar &&
            skashek.isChasing() &&
            slamsLeft > 0 &&
            location.ofKind(Room) &&
            otherSide.getOutermostRoom().mapModeVersion != nil
        ) {
            setPlayerTrap(true);
            if (startedInSameRoom) {
                local trickCount = (slamsLeft == 1) ?
                    'one final trick' : spellNumber(slamsLeft) + ' tricks';
                local slamChoice = new ChoiceGiver(
                    'Slam ' + theName + '?',
                    'You have <b>' + trickCount + ' remaining</b>, which you
                    can spend on slamming the door in his face!
                    This will delay his chase, but
                    will cost <b>one</b> of your tricks!'
                );
                slamChoice.add('Y', 'Slam the door!');
                slamChoice.add('L', 'Leave door open');
                local choice = slamChoice.ask();
                if (choice == 1) {
                    doNested(SlamClosed, otherSide);
                }
                else {
                    "<.p><i>{I} decide to save {my} antics
                    for another time...</i><.p>";
                }
            }
        }
    }

    checkBeingChased() {
        // Is Skashek chasing?
        if (!skashek.isChasing()) return nil;
        local som = skashek.getOutermostRoom();
        local pom = skashek.getPracticalPlayer().getOutermostRoom();
        // Is he right on the player before travel?
        return som == pom;
    }
}

modify Room {
    mostLikelyDestination() {
        return self;
    }

    setTrap(stat) {
        #if __DEBUG_SKASHEK_ACTIONS
        "<.p>
        <<if stat>>TRAP SET:<<else
        >>TRAP CLEARED:<<end>> <<roomTitle>>
        <.p>";
        #endif
        isTrapped = stat;
    }

    execTravel(actor, traveler, conn) {
        evaluateTrapsAndTracks(actor);
        inherited(actor, traveler, conn);
    }
}

/*modify LocalClimbPlatform {
    execTravel(actor, traveler, conn) {
        evaluateTrapsAndTracks(actor);
        inherited(actor, traveler, conn);
    }
}*/
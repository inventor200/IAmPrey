sneakyCore: object {
    allowSneak = nil
    sneakSafetyOn = nil
    armSneaking = nil // If travel is happening, are sneaking first?
    armEndSneaking = nil
    sneakDirection = nil
    sneakVerbosity = 3
    useVerboseReminder = true

    performStagingCheck(stagingLoc) {
        if (parkourCore.currentParkourRunner.location != stagingLoc) {
            if (!actorInStagingLocation.doPathCheck(stagingLoc, true)) {
                exit;
            }
        }
    }

    getDefaultTravelAction() {
        return sneakSafetyOn ? 'sn' : 'go';
    }

    getDefaultDoorTravelAction() {
        return sneakSafetyOn ? 'sn through' : 'go through';
    }

    getDefaultDoorTravelActionClass() {
        return sneakSafetyOn ? SneakThrough : GoThrough;
    }

    trySneaking() {
        if (allowSneak) {
            if (sneakSafetyOn) {
                armSneaking = true;
                return;
            }
            "<.p>You have voluntarily disabled auto-sneak for this tutorial!\n
            If you would like to, you can <<formatCommand('turn sneak on', longCmd)>>.<.p>";
            exit;
        }
        remindNoSneak();
        exit;
    }

    remindNoSneak() {
        say(formatAlert('Auto-sneaking is disabled outside of tutorial modes!'));
        if (useVerboseReminder) {
            "<<remember>>
            If the Predator expects <b>silence</b>, then
            <b>maintain the silence</b>!
            If the Predator expects a door to <b>slam shut</b>,
            then <b>let the door slam shut</b>!\b
            Reducing your trace on the environment
            is crucial for maintaining excellent stealth!";
        }
        "\bGood luck!<.p>";
        useVerboseReminder = nil;
    }

    disarmSneaking() {
        armSneaking = nil;
        armEndSneaking = nil;
        sneakDirection = nil;
    }

    heardDangerFromDirection(actor, direction) {
        if (direction == nil) return nil;
        local scopeList = Q.scopeList(actor);
        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!obj.ofKind(SubtleSound)) continue;
            if (!actor.canHear(obj)) continue;
            if (obj.isBroadcasting && obj.isSuspicious) {
                if (obj.lastDirection == direction) {
                    return true;
                }
            }
        }
        return nil;
    }

    getSneakLine(line) {
        return '<.p>\t<i><tt>(' + line + ')</tt></i><.p>';
    }

    getSneakStep(number, line, actionText) {
        local fullLine = '';
        if (sneakVerbosity >= 1) {
            fullLine += getSneakLine('<b>STEP ' + number + ': </b>' + line);
        }
        if (gFormatForScreenReader) {
            return fullLine +
                '<.p><i>({I} automatically tr{ies/ied}</i> ' +
                formatTheCommand(actionText) +
                '<i>.)</i><.p>';
        }
        return fullLine + '<.p>' + formatInput(actionText) + '<.p>';
    }

    beginSneakLine() {
        if (sneakVerbosity >= 2) {
            "<<getSneakLine('{I} {am} sneaking, so {i} perform{s/ed}
                the necessary safety precautions, as a reflex...')>>";
        }
        else {
            "<<getSneakLine('Sneaking...!')>>";
        }
    }

    concludeSneakLine() {
        if (sneakVerbosity < 2) return;
        "<<getSneakLine('And thus concludes the art of sneaking!')>>";
    }

    doSneakStart(conn, direction) {
        if (armSneaking) {
            sneakVerbosity--;
            armEndSneaking = true;
            armSneaking = nil;
            beginSneakLine();
            "<<getSneakStep(1, formatCommand('LISTEN') + ' for nearby threats!', 'listen')>>";
            local listenPrecache = heardDangerFromDirection(
                gActor, direction
            );
            nestedAction(Listen);
            if (listenPrecache) {
                "<.p>It sounds rather dangerous that way...
                Maybe {i} should go another way...";
                concludeSneakLine();
                exit;
            }

            local allowPeek = true;
            local peekComm = direction.name;
            if (conn.ofKind(Door)) {
                peekComm = conn.name;
                allowPeek = conn.allowPeek;
                if (!allowPeek && (conn.lockability == notLockable)) {
                    "<.p>(first opening <<conn.theName>>)<.p>";
                    nestedAction(Open, conn);
                    allowPeek = conn.allowPeek;
                }
            }

            if (allowPeek) {
                peekComm = (gFormatForScreenReader ? 'peek ' : 'p ') + peekComm;

                "<<getSneakStep(2, formatCommand('PEEK') +
                    ', just to be sure!', peekComm)>>";
                local peekPrecache = conn.destination.getOutermostRoom().hasDanger();
                if (direction.ofKind(Door) || direction.ofKind(Passage)) {
                    nestedAction(PeekThrough, conn);
                }
                else {
                    sneakDirection = direction;
                    nestedAction(PeekDirection);
                }
                if (peekPrecache) {
                    "Maybe {i} should go another way...<.p>";
                    concludeSneakLine();
                    exit;
                }
            }
            else {
                "{I} cannot peek through <<conn.theName>>...";
            }
            "<.p>";
        }
    }

    doSneakEnd(conn) {
        if (armEndSneaking) {
            armEndSneaking = nil;
            if (conn.ofKind(Door)) {
                local closingSide = conn.otherSide;
                if (closingSide == nil) closingSide = conn;
                else if (!gActor.canReach(closingSide)) closingSide = conn;

                if (closingSide != nil) {
                    checkDoorClosedBehind(closingSide);
                }
            }
            concludeSneakLine();
        }
    }

    checkDoorClosedBehind(closingSide) {
        local expectsOpen =
            closingSide.checkOpenExpectationFuse(&skashekCloseExpectationFuse) ||
            closingSide.skashekExpectsAirlockOpen;
        if (!expectsOpen) {
            "<<getSneakStep(3, 'Quietly ' +
                formatCommand('CLOSE') + ' the door{dummy} behind {me}!',
                'close ' + closingSide.name)>>";
            nestedAction(Close, closingSide);
        }
        else {
            local closeExceptionLine = getSneakLine(
                'Normally, {i} should ' +
                formatCommand('CLOSE') + ' the door behind {myself},
                but {i} did not open this door.
                Therefore, it\'s better to<<if closingSide.airlockDoor>>
                <i>leave it open</i>,<<else>>
                let it <i>close itself</i>,<<end>>
                according to what <<gSkashekName>> expects!'
            );
            "<<closeExceptionLine>>";
        }
    }
}
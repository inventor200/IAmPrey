doorSlamCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of a door automatically closing'
    'the echoing <i>ka-chunk</i> of a door automatically closing'
    'the reverberating <i>thud</i> of a door automatically closing'
    strength = 5

    afterEmission(room) {
        say('\b(Emitted door slam in <<room.roomTitle>>.)');
    }
}

doorSuspiciousCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of a door automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the echoing <i>ka-chunk</i> of a door automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the reverberating <i>thud</i> of a door automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    strength = 5
    isSuspicious = true

    afterEmission(room) {
        say('\b(Emitted suspicious door slam in <<room.roomTitle>>.)');
    }
}

doorSuspiciousSilenceProfile: SoundProfile {
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    '<<lastSuspicionTarget.suspiciousSilenceMsg>> '
    strength = 5
    isSuspicious = true
    absoluteDesc = true

    afterEmission(room) {
        say('\b(Emitted suspicious door silence in <<room.roomTitle>>.)');
    }
}

#define peekExpansion ('peek'|'peer'|'spy'|'check'|'watch'|'p')

VerbRule(PeekThrough)
    peekExpansion ('through'|'thru'|) singleDobj
    : VerbProduction
    action = PeekThrough
    verbPhrase = 'peek/peeking through (what)'
    missingQ = 'what do you want to peek through'    
;

DefineTAction(PeekThrough)
    turnsTaken = 0
    implicitAnnouncement(success) {
        if (success) {
            return 'peeking through {the dobj}';
        }
        return 'failing to peek through {the dobj}';
    }
;

VerbRule(PeekInto)
    [badness 100] peekExpansion ('in'|'into'|'inside' 'of') singleDobj
    : VerbProduction
    action = PeekInto
    verbPhrase = 'peek/peeking into (what)'
    missingQ = 'what do you want to peek into'    
;

DefineTAction(PeekInto)
    implicitAnnouncement(success) {
        if (success) {
            return 'peeking into {the dobj}';
        }
        return 'failing to peek into {the dobj}';
    }
;

VerbRule(PeekDirection)
    peekExpansion singleDir
    : VerbProduction
    action = PeekDirection
    verbPhrase = 'peek/peeking (where)'  
;

DefineTAction(PeekDirection)
    turnsTaken = 0
    direction = nil

    execCycle(cmd) {
        if (sneakyCore.sneakDirection != nil) {
            direction = sneakyCore.sneakDirection; 
            sneakyCore.sneakDirection = nil;
        }
        else {
            direction = cmd.verbProd.dirMatch.dir;
        }
        
        IfDebug(actions, "[Executing PeekDirection <<direction.name>>]\n");
        
        inherited(cmd);
    }

    execAction(cmd) {
        if (sneakyCore.sneakDirection != nil) {
            direction = sneakyCore.sneakDirection; 
            sneakyCore.sneakDirection = nil;
        }

        parkourCore.cacheParkourRunner(gActor);
        local loc = parkourCore.currentParkourRunner.getOutermostRoom();
        local conn = nil;

        // Get destination
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);

            local clear = true;
            if (conn == nil) clear = nil;
            if (conn != nil) {
                if (!conn.isConnectorApparent) {
                    clear = nil;
                }
            }

            if (!clear) {
                "{I} {cannot} peek that way. ";
                exit;
            }
        }

        local dest = conn.destination;

        // Exhaust all possible Things that might be connecting
        local scpList = Q.scopeList(gActor).toList();
        for (local i = 1; i <= scpList.length; i++) {
            local obj = scpList[i];
            if (obj.ofKind(TravelConnector) && obj.ofKind(Thing) && !obj.ofKind(Room)) {
                if (obj.destination == dest) {
                    doNested(PeekThrough, obj);
                    return;
                }
            }
        }

        // At this point, it is a simple room connection
        // Make sure we are on the floor
        sneakyCore.performStagingCheck(gActor.getOutermostRoom());

        "{I} carefully peek <<direction.name>>...<.p>";
        conn.destination.getOutermostRoom().peekInto();
    }
;

modify TravelAction {
    execCycle(cmd) {
        actionFailed = nil;
        parkourCore.cacheParkourRunner(gActor);
        local traveler = parkourCore.currentParkourRunner;
        local oldLoc = traveler.location;
        try {
            inherited(cmd);
        } catch(ExitSignal ex) {
            actionFailed = true;
        }
        if (oldLoc == traveler.location) {
            // We didn't move. We failed.
            actionFailed = true;
        }
    }

    execAction(cmd) {
        easeIntoTravel();
        doTravel();
    }

    easeIntoTravel() {
        local getOutAction;

        // Re-interpreting getting out?
        if (!gActor.location.ofKind(Room) && direction == outDir) {
            getOutAction = gActor.location.contType == On ? GetOff : GetOutOf;
            replaceAction(getOutAction, gActor.location);
            return;
        }

        sneakyCore.performStagingCheck(gActor.getOutermostRoom());
    }

    doTravel() {
        local loc = gActor.getOutermostRoom();
        local conn;
        local illum = loc.allowDarkTravel || loc.isIlluminated;
        local traveler = parkourCore.currentParkourRunner;
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);
            if (conn.isConnectorVisible) {
                if (gActor == gPlayerChar) {
                    sneakyCore.doSneakStart(conn, direction);
                    conn.travelVia(traveler);
                    sneakyCore.doSneakEnd(conn);
                }
                else {
                    sneakyCore.disarmSneaking();
                    gActor.travelVia(conn);
                }
            }
            else if (illum && gActor == gPlayerChar) {
                sneakyCore.disarmSneaking();
                loc.cannotGoThatWay(direction);
            }
            else if (gActor == gPlayerChar) {
                sneakyCore.disarmSneaking();
                loc.cannotGoThatWayInDark(direction);
            }
        }
        else {
            sneakyCore.disarmSneaking();
            nonTravel(loc, direction);
        }
    }
}

#define slamAdverbsExpansion 'violently'|'loudly'|'forcefully'

VerbRule(SlamClosed)
    'slam' singleDobj ('close'|'closed'|'shut'|'hard'|slamAdverbsExpansion|) |
    (slamAdverbsExpansion) 'slam' singleDobj ('close'|'closed'|'shut'|'hard'|) |
    (slamAdverbsExpansion) ('slam'|'close'|'shut') singleDobj ('hard'|)
    : VerbProduction
    action = SlamClosed
    verbPhrase = 'slam/slamming (what) closed'
    missingQ = 'what do you want to slam closed'    
;

DefineTAction(SlamClosed)
    turnsTaken = 0
;

#define sneakVerbExpansion ('auto-sneak'|'auto' 'sneak'|'autosneak'|'sneak'|'snk'|'sn'|'tiptoe'|'tip toe'|'tt')

VerbRule(SneakThrough)
    sneakVerbExpansion ('through'|'thru'|'into'|'via'|) singleDobj
    : VerbProduction
    action = SneakThrough
    verbPhrase = 'sneak/sneaking through (what)'
    missingQ = 'what do you want to sneak through'    
;

DefineTAction(SneakThrough)
    execCycle(cmd) {
        inherited(cmd);
        if (actionFailed) {
            sneakyCore.disarmSneaking();
            exit;
        }
    }
;

VerbRule(SneakDirection)
    sneakVerbExpansion singleDir
    : VerbProduction
    action = SneakDirection
    verbPhrase = 'sneak/sneaking (where)'  
;

class SneakDirection: TravelAction {
    execAction(cmd) {
        sneakyCore.trySneaking();
        inherited(cmd);
    }
}

VerbRule(ChangeSneakMode)
    [badness 10] sneakVerbExpansion literalDobj |
    'turn' literalDobj sneakVerbExpansion ('mode'|) |
    ('turn'|'set') sneakVerbExpansion literalDobj |
    literalDobj sneakVerbExpansion ('mode'|)
    : VerbProduction
    action = ChangeSneakMode
    verbPhrase = 'set sneak mode to (what)'
;

DefineLiteralAction(ChangeSneakMode)
    turnsTaken = 0

    execAction(cmd) {
        if (!sneakyCore.allowSneak) {
            sneakyCore.remindNoSneak();
            return;
        }

        local option = gLiteral.trim().toLower();

        if (option.length >= 4) {
            // Sometimes TURN SNEAK MODE BACK ON will capture
            // "mode back on" instead of just "on"
            local hasExtra = nil;
            do {
                hasExtra = nil;
                local head = option.left(4);
                hasExtra = (head == 'back' || head == 'mode');
                if (hasExtra) {
                    option = option.right(option.length-5).trim();
                }
            } while (hasExtra);
        }

        // Check our options
        if (option == 'on' || option == 'enable') {
            if (sneakyCore.sneakSafetyOn) {
                "<.p>Auto-sneak mode is already ON!<.p>";
                return;
            }
            sneakyCore.sneakSafetyOn = true;
            "<.p>Auto-sneak mode is now ON.<.p>";
        }
        else if (option == 'off' || option == 'disable') {
            if (!sneakyCore.sneakSafetyOn) {
                "<.p>Auto-sneak mode is already OFF!<.p>";
                return;
            }
            sneakyCore.sneakSafetyOn = nil;
            "<.p>Auto-sneak mode is now OFF.\n
            If you would like to, you can
            <<gDirectCmdStr('turn sneak back on')>> later!<.p>";
        }
        else {
            "<.p>Unrecognized option: <q><<option>></q>!<.p>";
        }
    }

    turnSequence() { }
;

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

    trySneaking() {
        if (allowSneak) {
            if (sneakSafetyOn) {
                armSneaking = true;
                return;
            }
            "<.p>You have voluntarily disabled auto-sneak for this tutorial!\n
            If you would like to, you can <<gDirectCmdStr('turn sneak on')>>.<.p>";
            exit;
        }
        remindNoSneak();
        exit;
    }

    remindNoSneak() {
        "<.p><i><b>(Auto-sneaking is disabled outside of tutorial modes!)</b></i>";
        if (useVerboseReminder) {
            "\b<b>REMEMBER:</b> If the Predator expects <b>silence</b>, then
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
                '<.p><i>({I} automatically tr{ies/ied}
                the <q><b>' + actionText +
                '</b></q> action.</i>)<.p>';
        }
        return fullLine + '<.p><i>&gt;' + actionText + '</i><.p>';
    }

    beginSneakLine() {
        if (sneakVerbosity >= 2) {
            "<<getSneakLine('{I} {am} <b>SNEAKING</b>, so {i} perform{s/ed}
                the necessary safety precautions, as a reflex...')>>";
        }
        else {
            "<<getSneakLine('Sneaking...!')>>";
        }
    }

    concludeSneakLine() {
        if (sneakVerbosity < 2) return;
        "<<getSneakLine('And thus concludes the art of <b>SNEAKING</b>!')>>";
    }

    doSneakStart(conn, direction) {
        if (armSneaking) {
            sneakVerbosity--;
            armEndSneaking = true;
            armSneaking = nil;
            beginSneakLine();
            "<<getSneakStep(1, '<b>LISTEN</b> for nearby threats!', 'listen')>>";
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

            local peekComm = direction.name;
            if (conn.ofKind(Door)) {
                peekComm = conn.name;
            }
            peekComm = (gFormatForScreenReader ? 'peek ' : 'p ') + peekComm;

            "<<getSneakStep(2, '<b>PEEK</b>, just to be sure!', peekComm)>>";
            local peekPrecache = conn.destination.getOutermostRoom().hasDanger();
            if (direction.ofKind(Door)) {
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
        local expectsOpen = checkOpenExpectationFuse(&skashekCloseExpectationFuse);
        if (expectsOpen) {
            "<<getSneakStep(3, 'Quietly <b>CLOSE</b> the door{dummy} behind {me}!',
                'close ' + closingSide.name)>>";
            nestedAction(Close, closingSide);
        }
        else {
            getSneakLine(
                'Normally, {i} should <b>CLOSE</b> the door behind {myself},
                but {i} did not open this door.
                Therefore, it\'s better to let it <i>close itself</i>,
                according to what <<skashek.theName>> expects!'
            );
        }
    }
}

actorHasPeekAngle: PreCondition {
    checkPreCondition(obj, allowImplicit) {
        if (!obj.requiresPeekAngle) return true;
        local stagingLoc = obj.stagingLocation;
        return actorInStagingLocation.doPathCheck(stagingLoc, allowImplicit);
    }
}

// Modify the normal exit listers, to be courteous of sneaking
modify statuslineExitLister {
    showListItem(obj, options, pov, infoTab) {
        if (highlightUnvisitedExits && (obj.dest_ == nil || !obj.dest_.seen)) {
            htmlSay('<FONT COLOR="<<unvisitedExitColour>>">');
        }

        "<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            AHREF_Plain)>>";

        if (highlightUnvisitedExits && (obj.dest_ == nil || !obj.dest_.seen)) {
            htmlSay('</FONT>');
        }
    }
}

modify lookAroundTerseExitLister {
    showListItem(obj, options, pov, infoTab) {
        htmlSay('<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            0)>>'
        );
    }
}

modify explicitExitLister {
    showListItem(obj, options, pov, infoTab) {
        htmlSay('<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            0)>>'
        );
    }
}

modify Thing {
    requiresPeekAngle = nil

    dobjFor(SneakThrough) {
        verify() {
            illogical('{That dobj} {is} not something to sneak through. ');
        }
    }

    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(PeekInto) asDobjFor(LookIn)

    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle]
    }

    dobjFor(LookIn) {
        preCond = [actorHasPeekAngle]
    }

    dobjFor(SlamClosed) {
        preCond = [touchObj]
        remap = ((!isCloseable && remapIn != nil && remapIn.isCloseable) ? remapIn : self)
        verify() {
            if (!isCloseable) {
                illogical(cannotCloseMsg);
            }
            if (!isOpen) {
                illogicalNow(alreadyClosedMsg);
            }
            logical;
        }
        check() { }
        action() {
            extraReport('({I} {don\'t need} to slam {that dobj}.)\n');
            doNested(Close, self);
        }
        report() { }
    }

    wasRead = nil

    dobjFor(Open) {
        report() {
            if (gActor == cat) {
                "After gingerly whapping {him dobj} with {my} paws,
                {I} finally open{s/ed} <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    dobjFor(Close) {
        report() {
            if (gActor == cat) {
                "After careful taps with {my} paws,
                {I} manage{s/d} to close <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    //TODO: Add limited inventory to cat
    catInventoryMsg = 'Carrying that in your mouth would only slow you down. ';

    dobjFor(Take) {
        verify() {
            if (gActor == cat) {
                illogical(catInventoryMsg);
                return;
            }
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        verify() {
            if (gActor == cat) {
                illogical(catInventoryMsg);
                return;
            }
            inherited();
        }
    }

    dobjFor(Read) {
        action() {
            if (self != catNameTag && gActor == cat) {
                "The strange hairless citizens make odd chants while
                staring at these odd shapes, sometimes for hours
                at a time. {I'm} not sure what <i>this</i> particular
                example would do to them, but {i} resent it anyway.";
            }
            else {
                if (propType(&readDesc) == TypeNil) {
                    say(cannotReadMsg);
                }
                else {
                    display(&readDesc);
                    if (!wasRead) {
                        huntCore.revokeFreeTurn();
                    }
                    wasRead = true;
                }
            }
        }
    }
}

#define catFlapDesc 'At the bottom of this door is a cat flap.'
enum normalClosingSound, slamClosingSound;

modify Door {
    hasCatFlap = nil
    catFlap = nil
    closingFuse = nil
    closingDelay = 3

    primedPlayerAudio = nil

    // One must be on the staging location to peek through me
    requiresPeekAngle = true

    // What turn does the player expect this to close on?
    playerCloseExpectationFuse = nil
    wasPlayerExpectingAClose = nil
    // What turn does skashek expect this to close on?
    skashekCloseExpectationFuse = nil
    wasSkashekExpectingAClose = nil

    preinitThing() {
        inherited();
        if ((hasCatFlap || !isLocked) && catFlap == nil) {
            hasCatFlap = true;
            otherSide.hasCatFlap = true;
            catFlap = new CatFlap(self);
            catFlap.preinitThing();
        }
    }

    getScanName() {
        local direction = getOutermostRoom().getDirection(self);
        if (direction != nil) {
            if (exitLister.enableHyperlinks) {
                return theName + ' (' + aHrefAlt(
                    sneakyCore.getDefaultTravelAction() +
                    ' ' + direction.name, direction.name, direction.name
                ) + ')';
            }
            return theName + ' (' + direction.name + ')';
        }
        if (exitLister.enableHyperlinks) {
            return aHrefAlt(
                sneakyCore.getDefaultDoorTravelAction() +
                ' ' + direction.name, theName, theName
            );
        }
        return theName;
    }

    clearMyClosingFuse(fuseProp) {
        if (self.(fuseProp) != nil) {
            self.(fuseProp).removeEvent();
            self.(fuseProp) = nil;
        }
    }

    clearFuse(fuseProp) {
        clearMyClosingFuse(fuseProp);

        if (otherSide != nil) {
            otherSide.clearMyClosingFuse(fuseProp);
        }
    }

    startFuse() {
        clearFuse(&closingFuse);

        closingFuse = new Fuse(self, &autoClose, closingDelay);
        closingFuse.eventOrder = 97;
        if (canEitherBeSeenBy(gPlayerChar)) {
            clearFuse(&playerCloseExpectationFuse);
            playerCloseExpectationFuse = new Fuse(self, &endPlayerExpectation, closingDelay);
            playerCloseExpectationFuse.eventOrder = 95;
        }
        if (canEitherBeSeenBy(skashek)) {
            clearFuse(&skashekCloseExpectationFuse);
            skashekCloseExpectationFuse = new Fuse(self, &endSkashekExpectation, closingDelay);
            skashekCloseExpectationFuse.eventOrder = 96;
        }
    }

    witnessClosing() {
        clearFuse(&closingFuse);
        if (canEitherBeSeenBy(gPlayerChar)) {
            wasPlayerExpectingAClose = true;
            clearFuse(&playerCloseExpectationFuse);
        }
        if (canEitherBeSeenBy(skashek)) {
            wasSkashekExpectingAClose = true;
            clearFuse(&skashekCloseExpectationFuse);
        }
    }

    getExpectedCloseFuse() {
        local expectedClosingFuse = closingFuse;
        if (expectedClosingFuse == nil && otherSide != nil) {
            expectedClosingFuse = otherSide.closingFuse;
        }
        return expectedClosingFuse;
    }

    getEndExpectationSuspicion(expectingCloseProp, fuseProp) {
        self.(expectingCloseProp) = true;
        local isSuspicious = nil;
        local expectedClosingFuse = getExpectedCloseFuse();
        if (expectedClosingFuse == nil) {
            isSuspicious = true;
        }
        else if (expectedClosingFuse.nextRunTime != self.(fuseProp).nextRunTime) {
            isSuspicious = true;
        }
        clearFuse(fuseProp);

        return isSuspicious;
    }

    checkOpenExpectationFuse(fuseProp) {
        local otherExpectation = nil;
        if (otherSide != nil) otherExpectation = otherSide.(fuseProp);
        return (self.(fuseProp) != nil) || (otherExpectation != nil);
    }

    isStatusSuspiciousTo(contestant, fuseProp) {
        if (!canEitherBeSeenBy(contestant)) return nil;
        return isOpen != checkOpenExpectationFuse(fuseProp);
    }

    endPlayerExpectation() {
        if (getEndExpectationSuspicion(&wasPlayerExpectingAClose, &playerCloseExpectationFuse)) {
            makePlayerSuspicious();
        }
    }

    endSkashekExpectation() {
        if (getEndExpectationSuspicion(&wasSkashekExpectingAClose, &skashekCloseExpectationFuse)) {
            makeSkashekSuspicious();
        }
    }

    checkClosingExpectations() {
        if (!wasPlayerExpectingAClose) {
            makePlayerSuspicious();
        }
        else {
            emitNormalClosingSound();
        }
        wasPlayerExpectingAClose = nil;
        if (!wasSkashekExpectingAClose) {
            makeSkashekSuspicious();
        }
        wasSkashekExpectingAClose = nil;
    }

    normalClosingMsg =
        '{The subj obj} sighs mechanically closed,
        ending with a noisy <i>ka-chunk</i>. '

    slamClosingMsg =
        '{The subj dobj} <i>slams</i> shut! '
    
    randomThoughtOnset =
        '<<one of>>...<<or>><<at random>>'
    
    realizationExclamation =
        '<<randomThoughtOnset>><<
        one of>>Wait<<or>>Wait a moment<<or>>Wait a second<<or>>Wait a sec<<
        or>>Hey<<or>>Hold on<<at random>>'

    suspicionMsgAlt1 =
        '<i><<one of>>supposed<<or>>meant<<at random>></i> to hear
        that<<one of>> happen<<or>> just now<<or>> just then<<or>><<at random>>'

    suspicionMsgAlt2 =
        'the <<one of>>one who<<or>>cause of<<or>>cause for<<or>>reason for<<at random
        >><<one of>>opened<<or>>caused<<at random>>'
    
    suspicionMsgQuestionGrp1 = 'were you
        <<one of>><<suspicionMsgAlt1>><<or>><<suspicionMsgAlt2>>
        that<<at random>>'
    
    suspicionMsgQuestionGrp2 = 'was that
        <<one of>><i>your</i> door<<or>>one of <i>your</i>
        doors<<one of>> from before<<or>> from earlier<<or>><<at random>><<at random>>'
    
    suspicionMsg =
        '<<realizationExclamation>>, <<one of>><<suspicionMsgQuestionGrp1>><<or
        >><<suspicionMsgQuestionGrp2>><<at random>>...?'
    
    suspiciousSilenceMsg =
        '<<realizationExclamation>>,
        <<one of>>isn\'t<<or>>wasn\'t<<at random>> <<theName>>
        <<one of>>supposed<<or>>meant<<or>>scheduled<<at random>>
        to <i><<one of>>close<<or>>shut<<at random>> itself</i>
        <<one of>>by<<or>>right about<<or>>around<<at random>> now...?'

    makePlayerSuspicious() {
        if (canEitherBeHeardBy(gPlayerChar)) {
            if (primedPlayerAudio == normalClosingSound) {
                local obj = self;
                gMessageParams(obj);
                "<.p><<normalClosingMsg>> <<suspicionMsg>> ";
            }
            else if (primedPlayerAudio == slamClosingSound) {
                "<.p><<slamClosingMsg>> <<suspicionMsg>> ";
            }
            else {
                local obj = self;
                gMessageParams(obj);
                "<.p><<suspiciousSilenceMsg>> ";
            }
        }
        else {
            if (primedPlayerAudio == normalClosingSound || primedPlayerAudio == slamClosingSound) {
                // Audible suspicion
                soundBleedCore.createSound(
                    doorSuspiciousCloseNoiseProfile,
                    getSoundSource(),
                    getOutermostRoom(),
                    nil
                );
                if (otherSide != nil) {
                    soundBleedCore.createSound(
                        doorSuspiciousCloseNoiseProfile,
                        getSoundSource(),
                        otherSide.getOutermostRoom(),
                        nil
                    );
                }
            }
            else {
                // Inaudible suspicion
                soundBleedCore.createSound(
                    doorSuspiciousSilenceProfile,
                    getSoundSource(),
                    getOutermostRoom(),
                    nil
                );
                if (otherSide != nil) {
                    soundBleedCore.createSound(
                        doorSuspiciousSilenceProfile,
                        getSoundSource(),
                        otherSide.getOutermostRoom(),
                        nil
                    );
                }
            }
        }
    }

    emitNormalClosingSound() {
        if (canEitherBeHeardBy(gPlayerChar)) {
            if (primedPlayerAudio == normalClosingSound) {
                local obj = self;
                gMessageParams(obj);
                "<.p><<normalClosingMsg>>";
            }
            else if (primedPlayerAudio == slamClosingSound) {
                say(slamClosingMsg);
            }
        }
        else {
            soundBleedCore.createSound(
                doorSlamCloseNoiseProfile,
                getSoundSource(),
                getOutermostRoom(),
                nil
            );
            if (otherSide != nil) {
                soundBleedCore.createSound(
                    doorSlamCloseNoiseProfile,
                    getSoundSource(),
                    otherSide.getOutermostRoom(),
                    nil
                );
            }
        }
    }

    makeSkashekSuspicious() {
        soundBleedCore.createSound(
            doorSlamCloseNoiseProfile,
            getSoundSource(),
            getOutermostRoom(),
            true
        );
        if (otherSide != nil) {
            soundBleedCore.createSound(
                doorSlamCloseNoiseProfile,
                getSoundSource(),
                otherSide.getOutermostRoom(),
                true
            );
        }
    }

    makeOpen(stat) {
        inherited(stat);

        if (stat) {
            startFuse();
        }
        else {
            witnessClosing();
        }
    }

    canEitherBeSeenBy(witness) {
        return witness.canSee(self) || witness.canSee(otherSide);
    }

    canEitherBeHeardBy(listener) {
        return listener.canHear(self) || listener.canHear(otherSide);
    }

    autoClose() {
        primedPlayerAudio = normalClosingSound;
        checkClosingExpectations();
        makeOpen(nil);
        primedPlayerAudio = nil;
    }

    slam() {
        primedPlayerAudio = slamClosingSound;
        checkClosingExpectations();
        makeOpen(nil);
        primedPlayerAudio = nil;
    }

    dobjFor(SneakThrough) {
        verify() {
            logical;
        }
        action() {
            sneakyCore.trySneaking();
            sneakyCore.doSneakStart(self, self);
            doNested(TravelVia, self);
            sneakyCore.doSneakEnd(self);
        }
    }

    dobjFor(Open) {
        verify() {
            if (gActor == cat) {
                illogical('{That subj dobj} {is} too heavy for an old cat to open.<<
                if hasCatFlap>> That\'s probably why the Royal Subject installed a cat
                flap<<first time>> <i>(cut a ragged square hold into the bottom with
                power tools)</i><<only>>.<<end>> ');
                return;
            }
            inherited();
        }
    }

    dobjFor(Close) {
        verify() {
            if (gActor == cat) {
                illogical('{That subj dobj} {is} too heavy for an old cat to close.
                It\'s fortunate that these close on their own, instead. ');
                return;
            }
            inherited();
        }
        action() {
            primedPlayerAudio = nil;
            inherited();
        }
        report() {
            if (gActor == gPlayerChar) {
                "{I} gently close{s/d} the door,
                so that it{dummy} {do} not make a sound. ";
            }
            else {
                inherited();
            }
        }
    }

    dobjFor(SlamClosed) {
        action() {
            slam();
        }
    }

    dobjFor(GoThrough) { // Assume the cat is using the cat flap
        preCond = (gActor == cat ? [travelPermitted, touchObj] :
            [travelPermitted, touchObj, objOpen])
    }

    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        remap = (isOpen ? nil : (hasCatFlap ? catFlap : nil))
        verify() {
            if (!isOpen && !hasCatFlap && !isTransparent) {
                illogical('{I} {cannot} peek through an opaque door. ');
            }
        }
        action() { }
        report() {
            if (isTransparent || isOpen) {
                "{I} peek{s/ed} through <<theName>>...\b";
            }
            else {
                "{I} peek{s/ed} through the cat flap of <<theName>>...\b";
            }
            otherSide.getOutermostRoom().peekInto();
        }
    }

    isActuallyPassable(traveler) {
        if (traveler == cat) {
            return hasCatFlap;
        }
        return isOpen;
    }

    replace checkTravelBarriers(traveler) {
        if(inherited(traveler) == nil) {
            return nil;
        }
        
        if (!isActuallyPassable(traveler)) {
            if (gPlayerChar.isOrIsIn(traveler)) {
                if (tryImplicitAction(Open, self)) {
                    "<<gAction.buildImplicitActionAnnouncement(true)>>";
                }
            }
            else if (tryImplicitActorAction(traveler, Open, self)) { }
            else if (gPlayerChar.canSee(traveler)) {
                local obj = self;
                gMessageParams(obj);

                say(cannotGoThroughClosedDoorMsg);
            }
        }
        
        return isActuallyPassable(traveler);
    }

    replace noteTraversal(actor) {
        if(actor == gPlayerChar && !(gAction.isPushTravelAction && suppressTravelDescForPushTravel)) {
            if (!gOutStream.watchForOutput({:travelDesc}) && actor == cat) {
                local obj = gActor;
                gMessageParams(obj);
                "{The subj obj} carefully climb{s/ed} through the cat flap of <<theName>>.";
            }
            "<.p>";
        }

        local travelers = (actor.location && actor.location.isVehicle)
            ? [actor, actor.location] : [actor];

        traversedBy = traversedBy.appendUnique(travelers);
    }
}

class CatFlap: Decoration {
    construct(door) {
        owner = door;
        ownerNamed = true;
        vocab = 'cat flap;pet kitty;door[weak] catflap petflap';
        inherited();
        lexicalParent = door;
        moveInto(door);
    }

    desc = "A ragged, square hole that has been cut into the bottom of the thick, industrial
    door. It must have required a combination of incredible power tools, <i>lots</i> of
    free time, and a radiant, heartfelt fondness for a certain cat."

    decorationActions = [Examine, GoThrough, Enter, PeekThrough, LookThrough, PeekInto, LookIn]

    canGoThroughMe = true
    requiresPeekAngle = true

    dobjFor(Enter) asDobjFor(GoThrough)
    dobjFor(GoThrough) {
        remap = lexicalParent
    }

    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle]
        verify() {
            logical;
        }
        action() { }
        report() {
            "{I} peek{s/ed} through the cat flap of <<lexicalParent.theName>>...\b";
            lexicalParent.otherSide.getOutermostRoom().peekInto();
        }
    }
}

modify Room {
    hasDanger() {
        return skashek.getOutermostRoom() == self;
    }

    peekInto() {
        if (hasDanger()) {
            "<i>\^<<skashek.globalParamName>> is in there!</i> ";
            //TODO: Peek consequence mechanics
        }
        else {
            "<i>Seems safe!</i> ";
        }
    }

    doorScanFuse = nil

    startDoorScan() {
        doorScanFuse = new Fuse(self, &doDoorScan, 0);
        doorScanFuse.eventOrder = 80;
    }

    travelerEntering(traveler, origin) {
        if (gPlayerChar.isOrIsIn(traveler)) {
            startDoorScan();
        }
    }

    lookAroundWithin() {
        inherited();
        if (doorScanFuse == nil) {
            doDoorScan(true);
        }
    }

    getSuspiciousDoorsForSkashek() {
        local scopeList = Q.scopeList(skashek);
        local suspiciousDoors = new Vector(8);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!gPlayerChar.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            if (obj.isStatusSuspiciousTo(skashek, &skashekCloseExpectationFuse)) {
                suspiciousDoors.appendUnique(obj);
            }
        }

        return suspiciousDoors.toList();
    }

    doDoorScan(fromCommand?) {
        local beVerbose = fromCommand || gameMain.verbose;

        local scopeList = Q.scopeList(gPlayerChar);
        local openExpectedDoors = new Vector(4);
        local closedExpectedDoors = new Vector(4);
        local suspiciousOpenDoors = new Vector(4);
        local suspiciousClosedDoors = new Vector(4);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!gPlayerChar.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            if (obj.isStatusSuspiciousTo(gPlayerChar, &playerCloseExpectationFuse)) {
                if (obj.isOpen) {
                    suspiciousOpenDoors.appendUnique(obj);
                }
                else {
                    suspiciousClosedDoors.appendUnique(obj);
                }
            }
            else if (beVerbose) {
                if (obj.isOpen) {
                    openExpectedDoors.appendUnique(obj);
                }
                else {
                    closedExpectedDoors.appendUnique(obj);
                }
            }
        }

        local expectedCount = openExpectedDoors.length + closedExpectedDoors.length;
        local suspicionCount = suspiciousOpenDoors.length + suspiciousClosedDoors.length;

        if (expectedCount > 0 || suspicionCount > 0) {
            "<.p>";
        }

        if (expectedCount > 0) {
            local firstListing = nil;

            if (closedExpectedDoors.length > 0) {
                "\^<<makeListStr(closedExpectedDoors, &getScanName, 'and')>>
                <<if closedExpectedDoors.length > 1>>are<<else>>is<<end>>
                closed";
                firstListing = true;
            }

            if (openExpectedDoors.length > 0) {
                "<<if firstListing>>, and <<else>>\^<<end>><<
                makeListStr(openExpectedDoors, &getScanName, 'and')>>
                <<if openExpectedDoors.length > 1>>are<<else>>is<<end>>
                currently open, but you
                <<one of>>probably knew<<or>>already know<<or>>were expecting<<at random>>
                that. ";
            }
            else {
                ". ";
            }
        }

        if (suspicionCount > 0) {
            if (expectedCount > 0) {
                "<.p>However...
                <<if suspicionCount > 1>><i>some</i> things are<<else
                >><i>something</i> is<<end>>
                suspicious here...<.p>";
            }

            local firstListing = nil;
            
            if (suspiciousOpenDoors.length > 0) {
                "\^<<makeListStr(suspiciousOpenDoors, &getScanName, 'and')>>
                <<if suspiciousOpenDoors.length > 1>>are<<else>>is<<end>>
                open, ";
                firstListing = true;
            }

            if (suspiciousClosedDoors.length > 0) {
                "<<if firstListing>>while <<else>>\^<<end>><<
                makeListStr(suspiciousClosedDoors, &getScanName, 'and')>>
                <<if suspiciousClosedDoors.length > 1>>are<<else>>is<<end>>
                <<if firstListing>>closed<<else>><i>open</i><<end>>, ";
            }

            "and you don't remember leaving
            <<if suspicionCount > 1>>them<<else>>it<<end>>
            <<one of>>like that<<or>>in that state<<or>>that way<<at random>>!";
        }

        if (openExpectedDoors.length > 0 || suspicionCount > 0) {
            "<.p>";
        }

        if (doorScanFuse != nil) {
            doorScanFuse.removeEvent();
            doorScanFuse = nil;
        }
    }
}
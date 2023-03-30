#define hyperDir(dirName) \
    (exitLister.enableHyperlinks ? \
        aHrefAlt( \
            sneakyCore.getDefaultTravelAction() + \
            ' ' + dirName, \
            dirName, \
            dirName \
        ) : dirName)

#define handleComplexPeekThrough(mcRoom, mcNamePhrase, mcRemoteHeader) \
    say('{I} carefully peek{s/ed} ' + mcNamePhrase + '...<.p>'); \
    mcRoom.observeFrom(gActor, mcRemoteHeader)

#define handleCustomPeekThrough(mcRoom, mcRemoteHeader) \
    handleComplexPeekThrough(mcRoom, mcRemoteHeader, mcRemoteHeader)

#define handlePeekThrough(mcRemoteHeader) \
    handleComplexPeekThrough(otherSide.getOutermostRoom(), mcRemoteHeader, mcRemoteHeader)

#define attachPeakingAbility(mcRemoteHeader) \
    requiresPeekAngle = true \
    canLookThroughMe = true \
    skipInRemoteList = true \
    remoteHeader = mcRemoteHeader \
    remappingLookIn = true \
    dobjFor(PeekThrough) asDobjFor(LookThrough) \
    dobjFor(PeekInto) asDobjFor(LookThrough) \
    dobjFor(LookIn) asDobjFor(LookThrough) \
    dobjFor(LookThrough) { \
        action() { } \
        report() { \
            handlePeekThrough(remoteHeader); \
        } \
    }

doorSlamCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of <<theSourceName>> automatically closing'
    'the echoing <i>ka-chunk</i> of <<theSourceName>> automatically closing'
    'the reverberating <i>thud</i> of a door automatically closing'
    strength = 5

    afterEmission(room) {
        say('<.p>(Emitted door slam in <<room.roomTitle>>.)<.p>');
    }
}

doorSuspiciousCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of <<theSourceName>> automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the echoing <i>ka-chunk</i> of <<theSourceName>> automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    'the reverberating <i>thud</i> of a door automatically closing. <<lastSuspicionTarget.suspicionMsg>>'
    strength = 5
    isSuspicious = true

    afterEmission(room) {
        say('<.p>(Emitted suspicious door slam in <<room.roomTitle>>.)<.p>');
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
        say('<.p>(Emitted suspicious door silence in <<room.roomTitle>>.)<.p>');
    }
}

doorUnlockBuzzProfile: SoundProfile {
    'the muffled, electronic buzz of <<theSourceName>> being unlocked'
    'the echoing, electronic buzz of <<theSourceName>> being unlocked'
    'the reverberating, electronic buzz of a door being unlocked'
    strength = 2

    afterEmission(room) {
        say('<.p>(Emitted unlock door buzz in <<room.roomTitle>>.)<.p>');
    }
}

#define peekExpansion 'peek'|'peer'|'spy'|'check'|'watch'|'p'
#define peekVerb(tail) \
    (peekExpansion) tail | \
    ('pop'|'poke'|'peek') ('my'|) ('head'|'eye') tail | \
    'lean' (('my'|) 'head'|) tail

#define DefinePeekMethod(prodSeg, actionName, verbStr) \
    VerbRule(Peek##actionName) \
        prodSeg \
        : VerbProduction \
        action = Peek##actionName \
        verbPhrase = 'peek/peeking ' + verbStr + ' (what)' \
        missingQ = 'what do you want to peek ' + verbStr \
    ; \
    DefineTAction(Peek##actionName) \
        turnsTaken = 0 \
        implicitAnnouncement(success) { \
            if (success) { \
                return 'peeking ' + verbStr + ' {the dobj}'; \
            } \
            return 'failing to peek ' + verbStr + ' {the dobj}'; \
        } \
    ; \
    modify Thing { \
        dobjFor(Peek##actionName) { \
            remap = remapIn \
            preCond = [actorHasPeekAngle, containerOpen] \
            verify() { \
                inaccessible('{That dobj} {is} not something {i} {can} peek ' + verbStr + '. '); \
            } \
        } \
    }

DefinePeekMethod(
    [badness 50] peekVerb(('through'|'thru'|'down'|) singleDobj),
    Through, 'through'
)
DefinePeekMethod(
    peekVerb(('between') singleDobj),
    Between, 'between'
)
#define bendNouns ('corner'|'curve'|'bend'|'edge'|'ledge')
DefinePeekMethod(
    peekVerb(('around'|'over') (('the'|) bendNouns ('of'|)|) singleDobj) |
    peekVerb(('around'|'over') singleDobj bendNouns),
    Around, 'around'
)
DefinePeekMethod(
    [badness 100] peekVerb(('in'|'inside' ('of'|)|'in' 'to'|'into') singleDobj),
    Into, 'into'
)

#define oldExpandedSearch ('look'|'l'|expandableSearch)

modify VerbRule(LookUnder)
    oldExpandedSearch 'under' singleDobj |
    peekVerb('under' singleDobj) :
    allowAll = nil
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
        parkourCore.cacheParkourRunner(gActor);

        // Re-interpreting getting out?
        //TODO: Pop these changes to TravelAction out, so
        // more modules can use them later.
        if (!gActor.location.ofKind(Room)) {
            local getOutAction = nil;
            if (direction == outDir) {
                getOutAction = GetOutOf;
            }
            else if (direction == downDir) {
                getOutAction = GetOff;
            }
            if (getOutAction != nil) {
                replaceAction(getOutAction, gActor.location);
                return;
            }
        }

        sneakyCore.performStagingCheck(gActor.getOutermostRoom());
    }

    doTravel() {
        local loc = gActor.getOutermostRoom();
        local conn;
        local illum = loc.allowDarkTravel || loc.isIlluminated;
        parkourCore.cacheParkourRunner(gActor);
        local traveler = parkourCore.currentParkourRunner;
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);
            if (conn.isConnectorVisible) {
                if (gActorIsPlayer) {
                    sneakyCore.doSneakStart(conn, direction);
                    conn.travelVia(traveler);
                    sneakyCore.doSneakEnd(conn);
                }
                else {
                    sneakyCore.disarmSneaking();
                    gActor.travelVia(conn);
                }
            }
            else if (illum && gActorIsPlayer) {
                sneakyCore.disarmSneaking();
                loc.cannotGoThatWay(direction);
            }
            else if (gActorIsPlayer) {
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

VerbRule(PeekDirection)
    (peekExpansion|'look'|'x'|'l') singleDir
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

        // See if the room has a special case for this first
        local specialTarget = loc.getSpecialPeekDirectionTarget(direction);
        if (specialTarget != nil) {
            doNested(PeekThrough, specialTarget);
            return;
        }

        // Get destination
        local clear = true;
        if (loc.propType(direction.dirProp) == TypeObject) {
            conn = loc.(direction.dirProp);
            
            if (conn == nil) clear = nil;
            if (conn != nil) {
                if (!conn.isConnectorApparent) {
                    clear = nil;
                }
            }
        }

        if (!clear || conn == nil) {
            if (direction == upDir && loc.ceilingObj != nil) {
                "(examining <<loc.ceilingObj.theName>>)\n";
                doInstead(Examine, loc.ceilingObj);
            }
            else if (direction == downDir) {
                parkourCore.currentParkourRunner.examineSurfaceUnder();
            }
            else {
                "{I} {cannot} peek that way. ";
            }
            exit;
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

        local remoteHeader = 'to the <<direction.name>>';
        if (direction == outDir || direction == inDir ||
            direction == upDir || direction == downDir) {
            remoteHeader = '<<direction.name>> there';
        }

        handleComplexPeekThrough(
            conn.destination.getOutermostRoom(),
            '<<direction.name>>', remoteHeader
        );
    }
;

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
    [badness 60] sneakVerbExpansion ('through'|'thru'|'into'|'via'|) singleDobj
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
    [badness 60] sneakVerbExpansion singleDir
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

VerbRule(VagueSneak) 
    [badness 55] sneakVerbExpansion 
    : VerbProduction
    action = VagueSneak
    verbPhrase = 'sneak/sneaking'
;

DefineIAction(VagueSneak)
    execAction(cmd) {
        sneakyCore.trySneaking();
        "Which way do you want to sneak? ";
    }
;

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
            If you would like to, you can <<gDirectCmdStr('turn sneak on')>>.<.p>";
            exit;
        }
        remindNoSneak();
        exit;
    }

    remindNoSneak() {
        "<.p><i><b>Auto-sneaking is disabled outside of tutorial modes!</b></i>";
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
            "<<getSneakStep(3, 'Quietly <b>CLOSE</b> the door{dummy} behind {me}!',
                'close ' + closingSide.name)>>";
            nestedAction(Close, closingSide);
        }
        else {
            local closeExceptionLine = getSneakLine(
                'Normally, {i} should <b>CLOSE</b> the door behind {myself},
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
    skipHandle = nil

    dobjFor(SneakThrough) {
        verify() {
            illogical('{That dobj} {is} not something to sneak through. ');
        }
    }

    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(PeekInto) asDobjFor(LookIn)

    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle, containerOpen]
    }

    dobjFor(LookIn) {
        preCond = [objVisible, touchObj, actorHasPeekAngle, containerOpen]
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
            if (gActorIsCat) {
                "After gingerly whapping {him dobj} with {my} paws,
                {I} finally open{s/ed} <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    dobjFor(Close) {
        report() {
            if (gActorIsCat) {
                "After careful taps with {my} paws,
                {I} manage{s/d} to close <<gActionListStr>>. ";
                return;
            }
            inherited();
        }
    }

    dobjFor(Read) {
        action() {
            if (self != catNameTag && gActorIsCat) {
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
    catFlap = nil
    airlockDoor = nil
    isVentGrateDoor = nil
    closingFuse = nil
    closingDelay = 3

    primedPlayerAudio = nil
    passActionStr = 'enter'
    canSlamMe = true

    pullHandleSide = (airlockDoor)

    // One must be on the staging location to peek through me
    requiresPeekAngle = true

    // What turn does the player expect this to close on?
    playerCloseExpectationFuse = nil
    wasPlayerExpectingAClose = nil
    // What turn does skashek expect this to close on?
    skashekCloseExpectationFuse = nil
    wasSkashekExpectingAClose = nil

    // Airlock-style doors do not close on their own,
    // so expectations are based on previously-witnessed
    // open states.
    playerExpectsAirlockOpen = nil
    skashekExpectsAirlockOpen = nil

    getSuspicionScore() {
        // Airlock doors can be suspicious, but there's no way to tell
        // how long ago it was visited.
        if (airlockDoor) return 1;
        if (closingFuse == nil) return 1;

        // Otherwise, rank by how much time is left to close.
        return (closingFuse.nextRunTime - gTurns) + 2;
    }

    getScanName() {
        local omr = getOutermostRoom();
        local observerRoom = gPlayerChar.getOutermostRoom();
        local inRoom = omr == observerRoom;

        if (lockability == notLockable) {
            local direction = omr.getDirection(self);
            
            if (direction != nil) {
                local listedLoc = inRoom
                    ? direction.name : omr.inRoomName(gPlayerChar);
                if (exitLister.enableHyperlinks && inRoom) {
                    return theName + ' (' + aHrefAlt(
                        sneakyCore.getDefaultTravelAction() +
                        ' ' + direction.name, direction.name, direction.name
                    ) + ')';
                }
                return theName + ' (' + listedLoc + ')';
            }

            if (exitLister.enableHyperlinks && inRoom) {
                local clickAction = '';
                if (outputManager.htmlMode) {
                    clickAction = ' (' + aHrefAlt(
                        sneakyCore.getDefaultDoorTravelAction() +
                        ' ' + theName, passActionStr, passActionStr
                    ) + ')';
                }
                return theName + clickAction;
            }
        }

        return theName + (inRoom
            ? '' : (' (' + omr.inRoomName(gPlayerChar) + ')'));
    }

    getPreferredBoardingAction() {
        return sneakyCore.getDefaultDoorTravelActionClass();
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

    contestantExpectsAirlockOpen(contestant) {
        if (contestant == skashek) {
            return skashekExpectsAirlockOpen;
        }
        return playerExpectsAirlockOpen;
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
        if (airlockDoor) return nil;
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
        if (airlockDoor) {
            return isOpen != contestantExpectsAirlockOpen(contestant);
        }
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
        '{The subj obj}
        <<one of>>sighs<<or>>hisses<<or>>wheezes<<at random>>
        <<one of>>mechanically<<or>>automatically<<at random>>
        <<one of>>closed<<or>>shut<<at random>>,
        <<one of>>ending<<or>>concluding<<or>><<at random>>
        with a <<one of>>noisy<<or>>loud<<at random>> <i>ka-chunk</i>. '

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
        'the <<one of>>one who<<or>>cause of<<or>>cause for<<or>>reason for<<or
        >>one who <<one of>>opened<<or>>caused<<at random>><<at random>>'
    
    suspicionMsgQuestionGrp1 = '{was} {i}
        <<one of>><<suspicionMsgAlt1>><<or>><<suspicionMsgAlt2>>
        that<<at random>>'
    
    suspicionMsgQuestionGrp2 = 'was that
        <<one of>><i>{my}</i> door<<or>>one of <i>{my}</i>
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
                local obj = getSoundSource();
                gMessageParams(obj);
                "<.p><<normalClosingMsg>> <<suspicionMsg>> ";
            }
            else if (primedPlayerAudio == slamClosingSound) {
                "<.p><<slamClosingMsg>> <<suspicionMsg>> ";
            }
            else {
                local obj = getSoundSource();
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
                local obj = getSoundSource();
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
        if (primedPlayerAudio == normalClosingSound || primedPlayerAudio == slamClosingSound) {
            // Noisy door close
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
        else {
            // Silent door close
            if (silentDoorRealizationFuse != nil) return;
            silentDoorRealizationFuse = new Fuse(
                self,
                &causeSilenceSuspicionForSkashek,
                skashek.getRandomResult(3)
            );
        }
    }

    silentDoorRealizationFuse = nil

    causeSilenceSuspicionForSkashek() {
        silentDoorRealizationFuse = nil;
        soundBleedCore.createSound(
            doorSuspiciousSilenceProfile,
            getSoundSource(),
            getOutermostRoom(),
            true
        );
        if (otherSide != nil) {
            soundBleedCore.createSound(
                doorSuspiciousSilenceProfile,
                getSoundSource(),
                otherSide.getOutermostRoom(),
                true
            );
        }
    }

    makeOpen(stat) {
        inherited(stat);

        if (airlockDoor) {
            if (canEitherBeSeenBy(gPlayerChar)) {
                playerExpectsAirlockOpen = stat;
                if (otherSide != nil) {
                    otherSide.playerExpectsAirlockOpen = stat;
                }
            }
            if (canEitherBeSeenBy(skashek)) {
                skashekExpectsAirlockOpen = stat;
                if (otherSide != nil) {
                    otherSide.skashekExpectsAirlockOpen = stat;
                }
            }
        }
        else {
            if (stat) {
                startFuse();
            }
            else {
                witnessClosing();
            }
        }

        if (!stat && lockability == lockableWithKey) {
            // Doors re-lock when closing
            makeLocked(true);
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
        if (airlockDoor) {
            // Only the player slams airlock doors
            wasPlayerExpectingAClose = true;
            wasSkashekExpectingAClose = nil;
        }
        checkClosingExpectations();
        makeOpen(nil);
        primedPlayerAudio = nil;
    }

    dobjFor(SneakThrough) {
        verify() {
            if ((lockability == lockableWithKey) && !isOpen) {
                illogical('That door is locked. ');
            }
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
            if (gActorIsCat && !isVentGrateDoor) {
                illogical('{That subj dobj} {is} too heavy for an old cat to open.<<
                if hasDistCompCatFlap>> That\'s probably why the Royal Subject installed a cat
                flap<<first time>> <i>(cut a ragged square hold into the bottom with
                power tools)</i><<only>>.<<end>> ');
                return;
            }
            inherited();
        }
        action() {
            if (gActorIsPrey) skashek.highlightDoorChange(self);
            inherited();
        }
    }

    catCloseMsg =
        '{That subj dobj} {is} too heavy for an old cat to close.
        It\'s fortunate that these close on their own, instead. '
    
    closeDoorDeniedMsg =
        '<<gSkashekName>> won\'t let{dummy} {me} do that again,
        at least while he controls {the dobj}. '
    
    cannotSlamClosedDoorMsg =
        '{I} cannot slam a closed door. '

    dobjFor(Close) {
        verify() {
            if (gActorIsCat) {
                illogical(catCloseMsg);
                return;
            }
            if (qualifiesForCloseTrick()) {
                if (!isOpen) {
                    illogical(cannotSlamClosedDoorMsg);
                    return;
                }
                if (huntCore.pollTrick(&closeDoorCount) == noTricksRemaining) {
                    illogical(closeDoorDeniedMsg);
                    return;
                }
            }
            inherited();
        }
        action() {
            if (qualifiesForCloseTrick()) {
                extraReport('<.p>(with a bit more urgency)\n');
                doInstead(SlamClosed, self);
                return;
            }
            if (gActorIsPrey) skashek.highlightDoorChange(self);
            primedPlayerAudio = nil;
            inherited();
        }
        report() {
            if (gActorIsPlayer && !airlockDoor) {
                "{I} gently close{s/d} the door,
                so that it{dummy} {do} not make a sound. ";
            }
            else {
                inherited();
            }
        }
    }

    dobjFor(SlamClosed) {
        verify() {
            if (gActorIsCat) {
                illogical(catCloseMsg);
                return;
            }
            if (!isOpen) {
                illogicalNow(cannotSlamClosedDoorMsg);
            }
            if (qualifiesForCloseTrick()) {
                if (huntCore.pollTrick(&closeDoorCount) == noTricksRemaining) {
                    illogical(closeDoorDeniedMsg);
                    return;
                }
            }
            inherited();
        }
        action() {
            if (gActorIsPrey) skashek.highlightDoorChange(self);
            local qualifies = qualifiesForCloseTrick();
            if (canSlamMe || qualifies) {
                if (gActorIsPrey) {
                    wasPlayerExpectingAClose = true;
                }
                else {
                    wasSkashekExpectingAClose = true;
                }
                slam();
                if (qualifies) {
                    //huntCore.spendTrick(&closeDoorCount);
                    spendCloseTrick();
                }
            }
            else {
                extraReport('<.p>(simply closing, as {that dobj} cannot be slammed)\n');
                doInstead(Close, self);
            }
        }
    }

    qualifiesForCloseTrick() {
        if (!gActorIsPrey) return nil;
        if (!isTrapped) return nil;
        local skashekOnOtherSide =
            (otherSide.getOutermostRoom() == skashek.getOutermostRoom());
        if (!skashekOnOtherSide) return nil;
        return true;
    }

    spendCloseTrick() {
        "<.p>";
        local poll = huntCore.spendTrick(&closeDoorCount);
        skashek.receiveDoorSlam();
        local shoutVerb =
            '<<one of>>bellows<<or>>yells<<or>>screams<<or>>shouts<<at random>>
            from behind the door';
        switch (poll) {
            default:
                "<q>Ach! Fuck you, Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
            case oneTrickRemaining:
                "<q>Fuck! I'm getting tired of your shit, Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
            case noTricksRemaining:
                "<q>That's <i>it!</i>
                That's the <i>last</i> time that will work, Prey!!</q>
                <<gSkashekName>> <<shoutVerb>>. ";
                return;
        }
    }

    getCatAccessibility() {
        if (!hasDistCompCatFlap) {
            return [travelPermitted, actorInStagingLocation, objOpen];
        }
        if (gActorIsCat) {
            return [travelPermitted, actorInStagingLocation];
        }
        return [travelPermitted, actorInStagingLocation, objOpen];
    }

    dobjFor(GoThrough) { // Assume the cat is using the cat flap
        preCond = (getCatAccessibility())
    }

    allowPeek = (isOpen || hasDistCompCatFlap || isTransparent)

    remappingSearch = true
    remappingLookIn = true
    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(PeekAround) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        remap = (isOpen ? nil : (hasDistCompCatFlap ? catFlap : nil))
        verify() {
            if (!allowPeek) {
                illogical('{I} {cannot} peek through an opaque door. ');
            }
        }
        action() { }
        report() {
            handlePeekThrough('through {the dobj}');
        }
    }

    isActuallyPassable(traveler) {
        if (traveler == cat) {
            return hasDistCompCatFlap || isVentGrateDoor;
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
        if (gPlayerChar.isOrIsIn(actor) && !(gAction.isPushTravelAction && suppressTravelDescForPushTravel)) {
            if (!gOutStream.watchForOutput({:travelDesc}) &&
                actor == cat && hasDistCompCatFlap &&
                catFlapNotificationCounter.count > 0) {
                local obj = gActor;
                gMessageParams(obj);
                if (catFlapNotificationCounter.count > 2) {
                    "{The subj obj} carefully climb{s/ed} through the cat flap of <<theName>>.";
                }
                else {
                    "(using the cat flap of <<theName>>...)";
                }
                catFlapNotificationCounter.count--;
            }
            "<.p>";
        }

        local travelers = (actor.location && actor.location.isVehicle)
            ? [actor, actor.location] : [actor];

        traversedBy = traversedBy.appendUnique(travelers);
    }
}

catFlapNotificationCounter: object {
    count = 4
}

DefineDistComponentFor(CatFlap, Door)
    vocab = 'cat flap;pet kitty;door[weak] catflap petflap catdoor kittydoor'

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && (obj.lockability == notLockable) && !obj.airlockDoor;
    }

    subReferenceProp = &catFlap

    desc = "A ragged, square hole that has been cut into the bottom of the thick, industrial
    door. It must have required a combination of incredible power tools, <i>lots</i> of
    free time, and a radiant, heartfelt fondness for a certain cat."

    isDecoration = true
    decorationActions = [Examine, GoThrough, Enter, PeekThrough, LookThrough, PeekInto, LookIn, Search]

    canGoThroughMe = true
    requiresPeekAngle = true

    dobjFor(Enter) {
        remap = lexicalParent
    }
    dobjFor(GoThrough) {
        remap = lexicalParent
    }

    remappingSearch = true
    remappingLookIn = true
    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        preCond = [actorHasPeekAngle]
        verify() {
            logical;
        }
        action() { }
        report() {
            handleCustomPeekThrough(
                lexicalParent.otherSide.getOutermostRoom(),
                'through the cat flap of <<lexicalParent.theName>>'
            );
        }
    }

    locType() {
        return Outside;
    }
;

class MaintenanceDoor: PrefabDoor {
    keyList = [maintenanceKey]
}

DefineDistComponentFor(ProximityScanner, MaintenanceDoor)
    vocab = 'proximity lock;RFID[weak];scanner'

    desc = "A small, metal box. If someone with the right keycard approaches,
    it unlocks, but only for a moment. "

    isDecoration = true
;

modify Room {
    hasDanger() {
        local res = nil;
        reachGhostTest_.moveInto(self);

        // Are we peeking him where he is now?
        local canSeeCurrentPosition =
            (skashek.getOutermostRoom() == self) ||
                reachGhostTest_.canSee(skashek);
        
        // Are we peeking him entering?
        local canSeeNextPosition = nil;
        local nextStop = skashek.getWalkInRoom();
        if (nextStop != nil) {
            canSeeNextPosition = 
                (nextStop == self) || reachGhostTest_.canSee(nextStop);
        }

        if (canSeeCurrentPosition || canSeeNextPosition) {
            res = skashek.showsDuringPeek();
        }
        reachGhostTest_.moveInto(nil);
        return res;
    }

    peekInto() {
        if (hasDanger()) {
            local distantRoom = nil;
            local skashekRoom = skashek.getOutermostRoom();
            if (skashekRoom != self) {
                distantRoom = skashekRoom;
            }
            else {
                // Player cannot be caught peeking from a distance
                skashek.doPlayerPeek();
            }
            // Move our peek POV into place, and mark it
            _peekSkashekPOV.moveInto(self);
            skashek.peekPOV = _peekSkashekPOV;
            if (distantRoom != nil) {
                // Make sure we can actually see the room...
                if (!_peekSkashekPOV.canSee(distantRoom)) {
                    distantRoom = nil;
                }
            }
            // Do peek
            skashek.describePeekedAction(distantRoom);
            // Pack up our peek POV
            _peekSkashekPOV.moveInto(nil);
            skashek.peekPOV = nil;
        }
        else {
            "<.p><i>Seems safe!</i> ";
        }
    }

    doorScanFuse = nil

    startDoorScan() {
        if (doorScanFuse != nil) return;
        doorScanFuse = new Fuse(self, &doDoorScan, 0);
        doorScanFuse.eventOrder = 80;
    }

    haltScheduledDoorScan() {
        if (doorScanFuse != nil) {
            doorScanFuse.removeEvent();
            doorScanFuse = nil;
        }
    }

    travelerEntering(traveler, origin) {
        inherited(traveler, origin);
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

    getMainDoorsInSight(actor, scopeVector) {
        local om = actor.getOutermostRoom();
        local omRegions = valToList(om.allRegions);
        for (local i = 1; i <= omRegions.length; i++) {
            local reg = omRegions[i];
            if (!reg.canSeeAcross) continue;
            local regRooms = valToList(reg.roomList);
            for (local j = 1; j <= regRooms.length; j++) {
                local room = regRooms[j];
                if (!om.canSeeOutTo(room)) continue;
                getMainDoorsInRoom(actor, room, scopeVector);
            }
        }
        if (omRegions.length == 0) {
            getMainDoorsInRoom(actor, om, scopeVector);
        }
    }

    getMainDoorsInRoom(actor, room, scopeVector) {
        local roomScope = valToList(room.contents);
        for (local i = 1; i <= roomScope.length; i++) {
            local obj = roomScope[i];
            if (!actor.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            scopeVector.appendUnique(obj);
        }
    }

    getSuspiciousDoorsForSkashek() {
        local scopeList = new Vector(16);
        getMainDoorsInSight(skashek, scopeList);

        local suspiciousDoors = new Vector(8);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!skashek.doesDoorGoToValidDest(obj)) continue;
            if (obj.isStatusSuspiciousTo(skashek, &skashekCloseExpectationFuse)) {
                suspiciousDoors.appendUnique(obj);
            }
        }

        if (suspiciousDoors.length == 0) return [];

        suspiciousDoors.sort(true,
            { a, b: a.getSuspicionScore() - b.getSuspicionScore() }
        );

        return suspiciousDoors.toList();
    }

    doDoorScan(fromCommand?) {
        if (gPlayerChar.getOutermostRoom() != self) return; // Oops
        local beVerbose = fromCommand || gameMain.verbose;

        local totalRoomList = new Vector(8);
        local totalRegions = valToList(allRegions);
        for (local i = 1; i <= totalRegions.length; i++) {
            local currentRoomList = valToList(totalRegions[i].roomList);
            for (local j = 1; j <= currentRoomList.length; j++) {
                local currentRoom = currentRoomList[j];
                if (currentRoom == self) continue;
                if (!canSeeOutTo(currentRoom)) continue;
                totalRoomList.appendUnique(currentRoom);
            }
        }

        local scopeList = [];
        scopeList += Q.scopeList(gPlayerChar);

        for (local i = 1; i <= totalRoomList.length; i++) {
            local currentRoom = totalRoomList[i];
            scopeList += currentRoom.getWindowList(gPlayerChar);
        }

        local openExpectedDoors = new Vector(4);
        local closedExpectedDoors = new Vector(4);
        local suspiciousOpenDoors = new Vector(4);
        local suspiciousClosedDoors = new Vector(4);

        for (local i = 1; i <= scopeList.length; i++) {
            local obj = scopeList[i];
            if (!gPlayerChar.canSee(obj)) continue;
            if (!obj.ofKind(Door)) continue;
            if (!obj.isConnectorListed) continue;
            if (obj.isVentGrateDoor) continue;
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
                currently open, but {i}
                <<one of>>probably knew<<or>>already knew<<or>>were expecting<<at random>>
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

            "and {i} don't remember leaving
            <<if suspicionCount > 1>>them<<else>>it<<end>>
            <<one of>>like that<<or>>in that state<<or>>that way<<at random>>!";
        }

        if (openExpectedDoors.length > 0 || suspicionCount > 0) {
            "<.p>";
        }

        haltScheduledDoorScan();
    }

    getSpecialPeekDirectionTarget(dirObj) {
        return nil;
    }
}
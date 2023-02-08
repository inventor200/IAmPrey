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
;

VerbRule(PeekInto)
    [badness 100] peekExpansion ('in'|'into'|'inside' 'of') singleDobj
    : VerbProduction
    action = PeekInto
    verbPhrase = 'peek/peeking into (what)'
    missingQ = 'what do you want to peek into'    
;

DefineTAction(PeekInto)
;

VerbRule(PeekDirection)
    peekExpansion singleDir
    : VerbProduction
    action = PeekDirection
    verbPhrase = 'peek/peeking {where)'  
;

DefineTAction(PeekDirection)
    turnsTaken = 0
    direction = nil

    execCycle(cmd) {
        direction = cmd.verbProd.dirMatch.dir; 
        
        IfDebug(actions, "[Executing PeekDirection <<direction.name>>]\n");
        
        inherited(cmd);
    }

    execAction(cmd) {
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
                abort;
            }
        }

        local dest = conn.destination;

        // Exhaust all possible Things that might be connecting
        local scpList = Q.scopeList(gActor).toList();
        for (local i = 1; i <= scpList.length; i++) {
            local obj = scpList[i];
            if (obj.ofKind(TravelConnector) && obj.ofKind(Thing)) {
                if (obj.destination == dest) {
                    doNested(PeekThrough, obj);
                    return;
                }
            }
        }

        // At this point, it is a simple room connection
        if (!parkourCore.currentParkourRunner.location.ofKind(Room)) {
            local terraFirmaName = 'the floor';
            if (loc != nil) {
                if (loc.floorObj != nil) {
                    terraFirmaName = loc.floorObj.theName;
                }
            }
            "{I} need{s/ed} to be on <<terraFirmaName>> to do that. ";
            abort;
        }

        "{I} carefully peek <<direction.name>>...\b";
        conn.destination.getOutermostRoom().peekInto();
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
;

modify Thing {
    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(PeekInto) asDobjFor(LookIn)
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
            clearFuse(&playerCloseExpectationFuse);
        }
        if (canEitherBeSeenBy(skashek)) {
            clearFuse(&skashekCloseExpectationFuse);
        }
    }

    endPlayerExpectation() {
        wasPlayerExpectingAClose = true;
        local isSuspicious = nil;
        local expectedClosingFuse = closingFuse;
        if (expectedClosingFuse == nil && otherSide != nil) {
            expectedClosingFuse = otherSide.closingFuse;
        }
        if (expectedClosingFuse == nil) {
            isSuspicious = true;
        }
        else if (expectedClosingFuse.nextRunTime != playerCloseExpectationFuse.nextRunTime) {
            isSuspicious = true;
        }
        clearFuse(&playerCloseExpectationFuse);
        if (isSuspicious) {
            makePlayerSuspicious();
        }
    }

    endSkashekExpectation() {
        wasSkashekExpectingAClose = true;
        local isSuspicious = nil;
        local expectedClosingFuse = closingFuse;
        if (expectedClosingFuse == nil && otherSide != nil) {
            expectedClosingFuse = otherSide.closingFuse;
        }
        if (expectedClosingFuse == nil) {
            isSuspicious = true;
        }
        else if (expectedClosingFuse.nextRunTime != skashekCloseExpectationFuse.nextRunTime) {
            isSuspicious = true;
        }
        clearFuse(&skashekCloseExpectationFuse);
        if (isSuspicious) {
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
    
    suspicionMsg =
        '...Wait, were you <i>supposed</i> to hear that...?'
    
    suspiciousSilenceMsg =
        'Hey, isn\'t <<theName>> supposed to <i>close itself</i> by now...?'

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
        //primedPlayerAudio = nil;
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
        //primedPlayerAudio = nil;
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
        /*report() {
            say(slamClosingMsg);
        }*/
    }

    dobjFor(GoThrough) { // Assume the cat is using the cat flap
        preCond = (gActor == cat ? [travelPermitted, touchObj] :
            [travelPermitted, touchObj, objOpen])
    }

    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        preCond = [touchObj]
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
            lexicalParent.otherSide.getOutermostRoom().peekInto();
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

    dobjFor(Enter) asDobjFor(GoThrough)
    dobjFor(GoThrough) {
        remap = lexicalParent
    }

    dobjFor(PeekInto) asDobjFor(LookThrough)
    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) {
        preCond = [touchObj]
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
    peekInto() {
        if (skashek.getOutermostRoom() == self) {
            "<i>\^<<skashek.globalParamName>> is in there!</i> ";
            //TODO: Peek consequence mechanics
        }
        else {
            "<i>Seems safe!</i> ";
        }
    }
}
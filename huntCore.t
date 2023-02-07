enum basicTutorial, preyTutorial, easyMode, mediumMode, hardMode, nightmareMode;
#define gCatMode huntCore.inCatMode

huntCore: InitObject {
    revokedFreeTurn = nil
    inMapMode = nil
    inCatMode = (difficulty == basicTutorial)
    wasBathTimeAnnounced = nil
    #if __IS_CAT_GAME
    difficulty = basicTutorial
    #else
    difficulty = mediumMode
    #endif

    execBeforeMe = [prologueCore]
    bathTimeFuse = nil
    #if __DEBUG
    apologyGivenToPG = nil
    apologyFuse = nil
    #endif

    execute() {
        if (inCatMode) {
            bathTimeFuse = new Fuse(self, &startBathTime, 9);
        }
    }

    startBathTime() {
        wasBathTimeAnnounced = true;
        "<.p>The voice of your Royal Subject is heard over the facility's
        intercom:\n
        <q><<gCatName>>...! It's bath time! I can smell you from the other
        side of the hunting zone!</q>\b
        Oh no. You fucking <i>hate</i> bath time...!! Time to make
        the Royal Subject <i>work for it!!</i>";
        bathTimeFuse = nil;
    }

    printApologyNoteForPG() {
        #if __DEBUG
        if (!apologyGivenToPG) {
            apologyFuse = new Fuse(self, &apologyMethod, 0);
            apologyGivenToPG = true;
        }
        #endif
        return cat.actualName;
    }

    #if __DEBUG
    apologyMethod() {
        "<.p><i>(<b>Note for the real Piergiorgio:</b>
        Don't worry; I will change the cat's name to something else before I
        upload this anywhere! This silly joke was for testers only!)</i><.p>";
        apologyFuse = nil;
    }
    #endif

    // Generically handle free action
    handleFreeTurn() {
        if (gAction.freeTurnAlertsRemaining > 0) {
            if (gAction.freeTurnAlertsRemaining > 1) {
                "<.p><i>(You used this turn for FREE!)</i><.p>";
            }
            else {
                "<.p><i>(From now-on, you will only be alerted if
                this action </i>wasn't<i> a FREE turn!)</i><.p>";
            }
            gAction.freeTurnAlertsRemaining--;
        }
    }

    // Generically handle turn-based action
    advanceTurns() {
        if (revokedFreeTurn) {
            "<.p><i>(These particular consequences have cost you a turn!
                Normally, you would have gotten this for FREE!)</i>";
        }
        handleSoundPropagation();
    }

    // If a trick action is available, offer a choice here
    offerTrickAction() {
        //
    }

    // Shashek's actions go here
    handleSkashekAction() {
        //
        handleSoundPropagation();
    }

    // Perform any considerations for sound propagation
    handleSoundPropagation() {
        soundBleedCore.doPropagation();
    }

    // If an action that normally is free suddenly has a cost,
    // then this will be called, to treat a normally-free action
    // as costly.
    revokeFreeTurn() {
        revokedFreeTurn = true;
    }
}

doorSlamCloseNoiseProfile: SoundProfile {
    'the muffled <i>ka-thud</i> of a door automatically closing'
    'the echoing <i>ka-chunk</i> of a door automatically closing'
    'the reverberating <i>thud</i> of a door automatically closing'
    strength = 5

    afterEmission(room) {
        //say('\b(Emitted door slam in <<room.roomTitle>>.)');
    }
}

#define peekExpansion ('peek'|'peer'|'spy'|'check'|'watch')

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

modify Thing {
    dobjFor(PeekThrough) asDobjFor(LookThrough)
    dobjFor(PeekInto) asDobjFor(LookIn)
}

#define catFlapDesc 'At the bottom of this door is a cat flap.'

modify Door {
    hasCatFlap = nil
    catFlap = nil
    closingFuse = nil
    lastToTouch = nil

    preinitThing() {
        inherited();
        if ((hasCatFlap || !isLocked) && catFlap == nil) {
            hasCatFlap = true;
            otherSide.hasCatFlap = true;
            catFlap = new CatFlap(self);
            catFlap.preinitThing();
        }
    }

    makeOpen(stat) {
        inherited(stat);

        if (closingFuse != nil) {
            closingFuse.removeEvent();
            closingFuse = nil;
        }

        if (otherSide != nil) {
            if (otherSide.closingFuse != nil) {
                otherSide.closingFuse.removeEvent();
                otherSide.closingFuse = nil;
            }
        }

        if (stat) {
            closingFuse = new Fuse(self, &autoClose, 3);
        }
    }

    autoClose() {
        makeOpen(nil);
        if (gPlayerChar.canSee(self) || gPlayerChar.canSee(otherSide)) {
            local obj = self;
            gMessageParams(obj);
            "<.p>{The subj obj} sighs mechanically closed,
            ending with a noisy <i>ka-chunk</i>. ";
        }

        // Be NOISY!!! :D
        if (lastToTouch == gPlayerChar) {
            soundBleedCore.createSound(
                doorSlamCloseNoiseProfile,
                getOutermostRoom(),
                true
            );
            if (otherSide != nil) {
                soundBleedCore.createSound(
                    doorSlamCloseNoiseProfile,
                    otherSide.getOutermostRoom(),
                    true
                );
            }
        }

        // Always listen to consequences
        soundBleedCore.createSound(
            doorSlamCloseNoiseProfile,
            getOutermostRoom(),
            nil
        );
        if (otherSide != nil) {
            soundBleedCore.createSound(
                doorSlamCloseNoiseProfile,
                otherSide.getOutermostRoom(),
                nil
            );
        }

        lastToTouch = nil;
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
        action() {
            lastToTouch = gActor;
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
            lastToTouch = nil;
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
            //TODO: Roll for catching!
        }
        else {
            "<i>Seems safe!</i> ";
        }
    }
}

//TODO: When Skashek follows you into a room, you get one turn to act, and he will be
//      reaching out for you by the next turn, and you will die if you are still in the
//      same room by the third turn. (the "short-streak")
//      If you spend that first turn going into a different room, he will immediately
//      follow you. If he can either follow you for 5(?) turns in a row
//      (the "long-streak"), he catches you.
//      Every time he moves into another room, the short-streak resets.
//      Each turn spent climbing on a non-floor object contributes to the long-streak
//      AND short-streak, BUT it will not FINISH the short-steak, as long as you do not
//      touch the floor! (He is waiting to snatch you!)
//      If he fails to follow you into a room, he tries to re-acquire, but every turn
//      without you decrements the long-streak.
//TODO: Passing through a door while being chased asks the player for an evasion action.

#define gHadRevokedFreeAction (turnsTaken == 0 && huntCore.revokedFreeTurn)
#define gActionWasCostly (turnsTaken > 0 || gHadRevokedFreeAction)

modify Action {
    freeTurnAlertsRemaining = 2

    turnSequence() {
        // Map mode is done with everything frozen in time
        if (huntCore.inMapMode) {
            revokedFreeTurn = nil;
            return;
        }

        inherited();
        
        if (gActionWasCostly) {
            huntCore.advanceTurns();
            huntCore.offerTrickAction();
            huntCore.handleSkashekAction();
        }
        else {
            huntCore.handleFreeTurn();
            huntCore.offerTrickAction();
        }

        if (gHadRevokedFreeAction) libGlobal.totalTurns++;

        huntCore.revokedFreeTurn = nil;
    }
}

modify Inventory {
    turnsTaken = 0
}

modify Examine {
    turnsTaken = 0
}

modify LookThrough {
    turnsTaken = 0
}

modify Look {
    turnsTaken = 0
}

modify Read {
    turnsTaken = 0
}

modify Thing {
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
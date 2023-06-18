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

        if (direction != nil) {
            "\b
            <<direction.name>>
            \b";
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

        // Peek out of container
        local peekerImmediateLoc = parkourCore.currentParkourRunner.location;
        if (
            !peekerImmediateLoc.ofKind(Room) &&
            peekerImmediateLoc.contType == In
        ) {
            if (direction == outDir) {
                if (peekerImmediateLoc.canSeeOut) {
                    doNested(Look);
                }
                else {
                    "There is no way to peek outside of
                    <<peekerImmediateLoc.theName>>. ";
                    exit;
                }
                return;
            }
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
    [badness 55] sneakVerbExpansion singleDir
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
    [badness 50] sneakVerbExpansion 
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
    [badness 65] sneakVerbExpansion literalDobj |
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
            <<formatCommand('turn sneak back on', longCmd)>> later!<.p>";
        }
        else {
            "<.p>Unrecognized option: <q><<option>></q>!<.p>";
        }
    }

    turnSequence() { }
;
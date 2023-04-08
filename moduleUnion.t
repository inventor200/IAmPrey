/*
 * This is where I do some extra configuration to make my parkour.t and soundBleed.t work with this specific project,
 * with the goal of keeping them modular and reusable.
 */

climbingNoiseProfile: SoundProfile {
    'the muffled racket of something clambering'
    'the nearby racket of something clambering'
    'the distant reverberations of clambering'
    strength = 2

    afterEmission(room) {
        //say('\b(Emitted climbing noise in <<room.roomTitle>>.)');
    }
}

impactNoiseProfile: SoundProfile {
    'the muffled <i>thud</i> of something landing on the floor'
    'the echoing <i>thud</i> of something landing on the floor'
    'the distant <i>wump</i> of something landing on the floor'
    strength = 3

    afterEmission(room) {
        //say('\b(Emitted impact noise in <<room.roomTitle>>.)');
    }
}

hardImpactNoiseProfile: SoundProfile {
    'the muffled <i>crack</i> of something hitting the floor'
    'the echoing <i>ka-thump</i> of something hitting the floor'
    'the reverberating <i>wump</i> of something hitting the floor'
    strength = 4

    afterEmission(room) {
        //say('\b(Emitted hard impact noise in <<room.roomTitle>>.)');
    }
}

/*modify parkourCore {
    certifyDiscovery(actor, path) {
        if (gActor != gPlayerChar) return;
        if (gAction.turnsTaken > 0) return;
        huntCore.revokeFreeTurn();
    }
}*/

modify actorInStagingLocation {
    spendImplicitTurn() {
        if (gActor != gPlayerChar) return;
        if (gAction.turnsTaken > 0) return;
        huntCore.revokeFreeTurn();
    }
}

#define holdActorStorage 100

VerbRule(HideOn)
    'hide' ('on'|'atop'|'on' 'top' ('of'|)) singleDobj
    : VerbProduction
    action = HideOn
    verbPhrase = 'hide/hiding on (what)'
    missingQ = 'what do you want to hide on'
;

DefineTAction(HideOn)
    execAction(cmd) {
        doInstead(Board, gDobj);
    }
;

VerbRule(HideIn)
    'hide' ('in'|'within'|'inside' ('of'|)) singleDobj
    : VerbProduction
    action = HideIn
    verbPhrase = 'hide/hiding in (what)'
    missingQ = 'what do you want to hide in'
;

DefineTAction(HideIn)
    execAction(cmd) {
        local targ = gDobj;
        if (targ.remapIn != nil) targ = targ.remapIn;
        doNested(Enter, targ);
        if (targ.isOpenable && gActor.isIn(targ)) {
            "<.p>(closing <<targ.theName>>)\n";
            doNested(Close, targ);
        }
    }
;

VerbRule(HideUnder)
    'hide' ('under'|'underneath') singleDobj
    : VerbProduction
    action = HideUnder
    verbPhrase = 'hide/hiding under (what)'
    missingQ = 'what do you want to hide under'
;

DefineTAction(HideUnder)
    execAction(cmd) {
        doInstead(SlideUnder, gDobj);
    }
;

VerbRule(Lick)
    ('lick'|'mlem') singleDobj
    : VerbProduction
    action = Lick
    verbPhrase = 'lick/licking (what)'
    missingQ = 'what do you want to lick'
;

DefineTAction(Lick)
    turnsTaken = (Taste.turnsTaken)
;

modify VerbRule(Attack)
    ('attack'|'kill'|'hit'|'kick'|'punch'|'strike'|'punish'|'swat' ('at'|)|
    ('lunge'|'dive') (('down'|) 'at'|)|'pounce' ('at'|'on'|'upon')|
    'tackle'|'ambush') singleDobj :
;

modify VerbRule(Inventory)
    'i' | 'inv' | 'inventory' | ('take'|'check') 'inventory' | 'check' 'pockets':
;

modify ParkourModule {
    canStandOnMe = true
}

modify Thing {
    canStandOnMe = (isBoardable)
    bulk = ((isEnterable || isBoardable) ? 2 : (isDecoration ? 0 : 1))
    bulkCapacity = ((isEnterable || isBoardable) ? holdActorStorage : actorCapacity)
    maxSingleBulk = ((isEnterable || isBoardable) ? holdActorStorage : actorCapacity)

    sightSize = (bulk > 1 ? medium : small)
    soundSize = large
    smellSize = small

    isSafeParkourPlatform = nil
    isHidingSpot = nil

    canAttackWithMe = (isTakeable && gDobj == skashek)
    cannotAttackMsg = (gCatMode ?
        '{I} like to think that {i} {am} a <i>merciful</i> ruler. '
        :
        'Maybe a human would do that,
        but {i} do not see the tactical benefit. '
    )

    cannotEnterMsg = (gCatMode ?
        '{I} {was} once able to squeeze into remarkable places,
        but {i} suppose {i} won\'t try it here. '
        :
        '{The subj dobj} {is} not something {i} {can} enter. '
    )

    doClimbPunishment(actor, traveler, path) {
        actor.addExhaustion(1);
    }

    doJumpPunishment(actor, traveler, path) {
        actor.addExhaustion(1);

        if (gActorIsCat) return; // Cats are silent!
        if (path.direction == parkourDownDir) {
            soundBleedCore.createSound(
                impactNoiseProfile,
                getSoundSource(),
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
        else {
            soundBleedCore.createSound(
                climbingNoiseProfile,
                getSoundSource(),
                traveler.getOutermostRoom(),
                actor == gPlayerChar
            );
        }
    }

    doHarmfulPunishment(actor, traveler, path) {
        actor.addExhaustion(1);

        if (gCatMode && actor == gPlayerChar) return; // Cats are silent!
        soundBleedCore.createSound(
            hardImpactNoiseProfile,
            getSoundSource(),
            traveler.getOutermostRoom(),
            actor == gPlayerChar
        );

        extraReport('\n<i>(That{dummy} will cost {me} a moment to recover...)</i>\n');
        huntCore.addBonusSkashekTurn(
            huntCore.difficultySettingObj.turnsSkipsForFalling
        );
    }

    dobjFor(Lick) asDobjFor(Taste)

    verifyAttackBasically() {
        if (gActor == gDobj) {
            illogical('{I} deserve better treatment than that.
            <<if gCatMode>>{I} {am} a wonderful king, after all!<<else
            >>{I} {am} already surviving longer than the vast majority
            of previous prey clones!<<end>> &lt;3 ');
        } 
        else if (gActorIsPrey) {
            illogical(cannotAttackMsg);
        }
    }

    dobjFor(Attack) {
        verify() {
            verifyAttackBasically();
        }
        check() { }
        action() {
            doInstead(Move, gDobj);
        }
        report() { }
    }

    dobjFor(AttackWith) {
        verify() {
            verifyAttackBasically();
        }
        check() { }
        action() {
            doInstead(MoveWith, gDobj, gIobj);
        }
        report() { }
    }

    selfPropulsionMsg = 'There{plural} {is} better ways{dummy} to move {myself} around. '
    catCannotMoveMsg = '{That dobj} {is} too heavy for an old king to move. '
    pawsCannotPullMsg = '{My} paws{dummy} will not let {me} pull anything. '

    verifyPushBasically() {
        if (gActor.isOrIsIn(self)) {
            inaccessible(selfPropulsionMsg);
            return true;
        }
        if (isFixed) {
            illogical(cannotTakeMsg);
            return true;
        }
        if (gActorIsCat && bulk > 1) {
            illogical(catCannotMoveMsg);
            return true;
        }
        return nil;
    }

    dobjFor(Pull) {
        preCond = [touchObj]
        verify() {
            if (verifyPushBasically()) { }
            else if (gActorIsCat) {
                inaccessible(pawsCannotPullMsg);
            }
            else {
                inaccessible(cannotPullMsg);
            }
        }
    }

    iobjFor(MoveTo) {
        preCond = [objVisible]
        verify() {
            if (!gActorIsCat) {
                illogical(cannotPushMsg);
            }
            else if (gDobj.location == getStandardOn()) {
                logical;
            }
            else {
                local currentContainer = gDobj.location;
                local nextContainer = nil;
                while (currentContainer.exitLocation != nil) {
                    nextContainer = currentContainer;

                    if (nextContainer.contType != In) {
                        if (nextContainer.ofKind(SubComponent)) {
                            do {
                                nextContainer = nextContainer.lexicalParent;
                                if (nextContainer.contType == In) break;
                            } while (nextContainer.ofKind(SubComponent));
                        }

                        currentContainer = nextContainer;
                    }

                    if (currentContainer.contType != In) {
                        if (currentContainer.exitLocation != nil) {
                            currentContainer = currentContainer.exitLocation;
                        }
                    }

                    if (currentContainer == getStandardOn()) {
                        break;
                    }

                    if (currentContainer.contType == In) {
                        illogical(noBounceRouteMsg);
                    }
                }
                if (currentContainer == getStandardOn()) {
                    logical;
                }
                else {
                    illogical(noBounceRouteMsg);
                }
            }
        }
    }

    noBounceRouteMsg = '{I} do not think {that dobj} will bounce all the way down there. '

    dobjFor(Move) asDobjFor(Push)
    dobjFor(MoveTo) asDobjFor(Push)
    dobjFor(MoveWith) asDobjFor(Push)
    dobjFor(Push) {
        preCond = [touchObj]
        verify() {
            if (verifyPushBasically()) { }
            else if (gActorIsCat) {
                if (location.contType == In) {
                    catPushFailure(location, true);
                }
            }
            else {
                inaccessible(cannotPushMsg);
            }
        }
        check() { }
        action() {
            if (location.exitLocation == nil) {
                "{I} push {the dobj} around
                <<location.objInPrep>> <<location.theName>>.
                It seems to satisfy some urge in {my} mind. ";
            }
            else {
                local currentContainer = location;
                local nextContainer = nil;
                local firstPush = nil;
                while (currentContainer.exitLocation != nil) {
                    nextContainer = currentContainer;

                    if (nextContainer.contType != In) {
                        if (nextContainer.ofKind(SubComponent)) {
                            do {
                                nextContainer = nextContainer.lexicalParent;
                                if (nextContainer.contType == In) {
                                    break;
                                }
                            } while (nextContainer.ofKind(SubComponent));
                        }

                        currentContainer = nextContainer;
                    }

                    if (currentContainer.contType != In) {
                        if (currentContainer.exitLocation != nil) {
                            currentContainer = currentContainer.exitLocation;
                            if (!firstPush) {
                                firstPush = true;
                                "{I} push {the dobj}, and it falls to
                                <<currentContainer.theName>>. ";
                            }
                            else {
                                "\b(bounce!)\b{The dobj} falls to
                                <<currentContainer.theName>>. ";
                            }
                        }
                        else {
                            "\b<<bouncedAsFarAsPossibleMsg>>";
                            break;
                        }
                    }

                    if (currentContainer.contType == In) {
                        if (!firstPush) {
                            catPushFailure(currentContainer);
                        }
                        else {
                            "\b<<bouncedAsFarAsPossibleMsg>>";
                            break;
                        }
                    }
                }
                "\b{I} glare at {the dobj}. <<one of>>
                {I} work so hard to make this house a home!<<or>>
                {I} <i>know</i> that wasn't where {i} left {that dobj} yesterday...<<or>>
                {I} decide {that dobj} <i>definitely</i> looks better there!<<or>>
                {I} hate it when <<gSkashekName>> picks stuff up...
                <<at random>> ";
            }
        }
    }

    bouncedAsFarAsPossibleMsg = '{The dobj} has fallen as far as it can go. '

    catCannotPushOutMsg(currentContainer) {
        return '{That dobj} {is} being contained by
            <<currentContainer.theName>>, and {i} cannot push it out! ';
    }

    catPushFailure(currentContainer, isVerify?) {
        if (isVerify) {
            inaccessible(catCannotPushOutMsg(currentContainer));
        }
        else {
            say(catCannotPushOutMsg(currentContainer));
            exit;
        }
    }

    cannotPushTravelMsg() {
        if (gActorIsCat) {
            return '{I} have no wish to push things anywhere,
                but to the <i>floor!</i> ';
        }
        return cannotPushMsg;
    }

    verifyPushTravel(via) {
        viaMode = via;
        
        if (!canPushTravel && !canPullTravel) {
            illogical(cannotPushTravelMsg);
        }      
        
        verifyPushBasically();
        if (!gActorIsCat) {
            inaccessible(cannotPushMsg);
        }
        
        if (gIobj == self) {
            illogicalSelf(cannotPushViaSelfMsg);
        }
    }

    findSurfaceUnder() {
        local surface = location;

        if (surface.ofKind(Room)) {
            return surface.floorObj;
        }

        if (surface.contType == In && surface.enclosing) {
            return surface;
        }

        local masterSurface = surface;
        while (masterSurface.ofKind(SubComponent)) {
            masterSurface = masterSurface.lexicalParent;
        }

        if (surface.contType == On) {
            return masterSurface;
        }

        return masterSurface.findSurfaceUnder();
    }

    examineSurfaceUnder() {
        local xTarget = findSurfaceUnder();
        if (xTarget != nil) {
            "(examining <<xTarget.theName>>)\n";
            doInstead(Examine, xTarget);
            searchCore.reportedSuccess = true;
        }
        else {
            "{I} {see} nothing under {the dobj}. ";
            searchCore.reportedFailure = true;
        }
    }
}

modify Actor {
    remappingSearch = true
    remappingLookIn = true
    dobjFor(PeekInto) asDobjFor(Search)
    dobjFor(PeekThrough) asDobjFor(Search)
    dobjFor(LookIn) asDobjFor(Search)
    dobjFor(Search) {
        verify() {
            if (gPlayerChar != self) {
                inaccessible('{The dobj}{dummy} will not let {me} search {him dobj}. ');
            }
            else {
                logical;
            }
        }
        check() { }
        action() {
            doInstead(Inventory);
        }
        report() { }
    }

    dobjFor(LookUnder) {
        verify() { }
        check() { }
        action() {
            examineSurfaceUnder();
        }
        report() { }
    }
}

// killRoom = 1 exit
// escapeRoom = 1 travel exit, 1+ parkour exits
// chaseRoom = 2+ travel exits
// bigRoom = resets the long-streak and allows reuse of exit
enum killRoom, escapeRoom, chaseRoom, bigRoom;

#define roomCapacity 100000
modify Room {
    bulkCapacity = roomCapacity
    maxSingleBulk = roomCapacity
    roomNavigationType = chaseRoom
}

modify Floor {
    floorActions = [Examine, Search, SearchClose, SearchDistant, LookUnder, TakeFrom, MoveTo]

    cannotLookUnderFloorMsg = 'It is impossible to look under <<theName>>. '

    dobjFor(LookUnder) {
        verify() {
            illogical(cannotLookUnderFloorMsg);
        }
    }

    dobjFor(MoveTo) {
        verify() {
            illogical(cannotTakeMsg);
        }
    }

    iobjFor(MoveTo) {
        remap = (gPlayerChar.outermostVisibleParent())
    }
}

#define betterStorageHeader \
    bulkCapacity = holdActorStorage \
    maxSingleBulk = holdActorStorage

modify Surface {
    bulk = 2
    bulkCapacity = actorCapacity
    maxSingleBulk = actorCapacity
}

modify Platform {
    bulk = 2
    betterStorageHeader
    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify Booth {
    bulk = 2
    betterStorageHeader
    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify Door {
    sightSize = large
}

class FixedPlatform: Platform {
    betterStorageHeader
    isFixed = true
}

class FixedBooth: Booth {
    betterStorageHeader
    isFixed = true
}

HomeHaver template 'vocab' @location? "basicDesc"?;
class HomeHaver: Thing {
    desc() {
        if (isHome()) {
            homeDesc();
            return;
        }
        basicDesc();
    }
    basicDesc = "(Missing description!) "
    homeDesc() { basicDesc(); }
    home = nil
    backHomeMsg = '{I} {put} {the dobj} back where it belongs. '

    setHome() {
        home = location;
    }

    isHome() {
        if (isHeldBy(gPlayerChar)) return nil;
        if (home == nil) return true;
        return location == home;
    }

    dobjFor(Take) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(Drop) {
        report() {
            if (location == home) {
                say(backHomeMsg);
            }
            else {
                inherited();
            }
        }
    }

    hideFromAll(action) {
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }
        return true;
    }
}

modify remoteRoomContentsLister {
    showListSuffix(lst, pl, irName) { 
        " (visible in <<lst[1].getOutermostRoom().roomTitle>>). ";
    }
}

modify remoteSubContentsLister {
    showListSuffix(lst, pl, irName) { 
        " (visible in <<lst[1].getOutermostRoom().roomTitle>>). ";
    }
}

#include "prefabs/prefabs.t"

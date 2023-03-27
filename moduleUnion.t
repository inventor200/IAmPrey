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

#define roomCapacity 100000
modify Room {
    bulkCapacity = roomCapacity
    maxSingleBulk = roomCapacity
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
    basicDesc = "TODO: Add description. "
    homeDesc = basicDesc
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

class Chair: HomeHaver, Platform {
    //bulk = 2
    canSitOnMe = true

    dobjFor(SitIn) asDobjFor(SitOn)
}

class Mirror: Decoration {
    vocab = 'mirror'
    desc = "<<gActor.seeReflection(self)>>"
    smashedVocab = 'smashed mirror;broken shattered'
    isSmashed = nil
    decorationActions = [Examine, LookIn]
    isBreakable = true

    confirmSmashed() { }

    remappingLookIn = true
    dobjFor(LookIn) asDobjFor(Examine)

    dobjFor(Break) {
        verify() {
            if (isSmashed) illogical('It\'s already broken. ');
            if (gActorIsCat) {
                illogical('{My} great wisdom advises against breaking the
                    mirror. It\'s best to maintain the <i>illusion</i> of power in
                    {my} old age, and save {my} energy for more urgent matters. ');
            }
            inherited();
        }
        action() {
            //TODO: Smash mirror
        }
        report() {
            //TODO: Smash mirror
        }
    }
}

class SmashedMirror: Mirror {
    vocab = 'mirror;smashed broken shattered'
    desc = "<<gActor.seeShatteredVanity()
        >>The mirror is smashed, though most of it still remains.
        <<gActor.seeReflection(self)>><<
        gActor.seeShatteredVanity()>>"
    smashedVocab = 'smashed mirror;broken shattered'
    isSmashed = true
    seenSmashed = nil

    confirmSmashed() {
        if (isSmashed && !seenSmashed) {
            seenSmashed = true;
            replaceVocab(smashedVocab);
        }
    }
}

mirrorShards: MultiLoc, Decoration {
    vocab = 'shard;partial shattered sharp piece[n] of[prep] mirror[weak];shard chunk'
    desc = "A jagged piece of the smashed mirror, still attached to the frame. "
    ambiguouslyPlural = true

    initialLocationClass = SmashedMirror
    isTakeable = true
    decorationActions = [Examine, Take, TakeFrom]

    takeWarning = '{My} manufactured (but enhanced) instincts kick in.\b
        There are missing chunks already, many of which look like they could have
        been viable knives. From this, {i} conclude that {i} {am} not the first clone
        to think of this idea.\b
        However, <i>he</i> is still alive, which means the previous knife-wielders
        died in their attempts. From this, {i} deduce that <<gSkashekName>> is
        combat-trained, and/or has prepared defenses against this sort of attack.
        If he{dummy} sees {me} with a weapon, then all <q>rules of the game</q>
        will be quickly discarded. <i>Many</i> of {my} instincts{dummy}
        refuse to let {me} walk so blatantly into this deathtrap.\b
        It\'s more tactical to take advantage of his <q>rules</q>. '

    dobjFor(TakeFrom) asDobjFor(Take)
    dobjFor(Take) {
        verify() {
            if (gActorIsPlayer) {
                if (gCatMode) {
                    illogical('{I}\'ll cut {my} mouth! ');
                }
                else if (!mirrorShard.gaveWarning && huntCore.difficulty != nightmareMode) {
                    mirrorShard.armWarning = true;
                }
            }
            if (mirrorShard.isDirectlyIn(gActor)) {
                illogicalNow('{I} already {hold} a piece of the mirror. ');
            }
            inherited();
        }
        action() {
            if (mirrorShard.armWarning) {
                say(takeWarning);
                mirrorShard.gaveWarning = true;
                mirrorShard.armWarning = nil;
                gAction.actionFailed = true;
                exit;
            }
            mirrorShard.actionMoveInto(gActor);
        }
        report() {
            if (gActorIsPrey) {
                if (huntCore.difficulty == nightmareMode) {
                    "Might as well. He can't get any <i>more</i> angry.\b";
                }
                else {
                    "<i>Better not get caught,</i> {i} think to {myself}.\b";
                }
            }
            inherited();
        }
    }
}

//TODO: If you are seen with the shard, the game switches to nightmare mode
mirrorShard: Thing { 'shard;partial shattered sharp piece[n] of[prep] mirror[weak];shard chunk'
    "A jagged, reflective piece of a smashed mirror. Mind the sharp edges. "

    gaveWarning = nil
    armWarning = nil
    canCutWithMe = true

    dobjFor(Break) {
        verify() {
            illogical('It\'s already broken. ');
        }
    }
}

// Filing cabinets
class FilingCabinet: Fixture {
    vocab = 'filing cabinet;office paper papers metal'
    desc = "A standard, metal filing cabinet. It has a top, middle, and bottom
    drawer for storage. "
    
    betterStorageHeader
    IncludeDistComponent(TinyDoorTopDrawerHandle)
    IncludeDistComponent(TinyDoorMiddleDrawerHandle)
    IncludeDistComponent(TinyDoorBottomDrawerHandle)

    getDrawer(index) {
        switch(index) {
            default:
                return topDrawer;
            case 2:
                return middleDrawer;
            case 3:
                return bottomDrawer;
        }
    }

    doMultiSearch() {
        "(searching the top of <<theName>>)\n";
        searchCore.clearHistory();
        doNested(SearchClose, remapOn);
        doubleCheckGenericSearch(remapOn);

        "\b(searching in the drawers of <<theName>>)\n";
        searchCore.clearHistory();
        doNested(LookIn, remapIn);
        doubleCheckGenericSearch(remapIn);
    }

    dobjFor(Open) {
        remap = remapIn
    }

    dobjFor(Close) {
        remap = remapIn
    }

    iobjFor(TakeFrom) {
        remap = (gTentativeDobj.overlapsWith(remapOn.contents) ? remapOn : remapIn)
    }

    notionalContents() {
        return inherited() + remapIn.notionalContents();
    }
}

DefineDistSubComponentFor(FilingCabinetRemapOn, FilingCabinet, remapOn)
    isBoardable = true
    betterStorageHeader
;

DefineDistSubComponentFor(FilingCabinetRemapIn, FilingCabinet, remapIn)
    isOpenable = nil
    isOpen = true
    bulkCapacity = 0
    maxSingleBulk = 0

    getDrawer(index) {
        return lexicalParent.getDrawer(index);
    }

    dobjFor(Open) {
        verify() { }
        check() { }
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (!drawer.isOpen) tryImplicitAction(Open, drawer);
            }
            "<.p>Done. ";
        }
        report() { }
    }

    dobjFor(Close) {
        verify() { }
        check() { }
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (drawer.isOpen) tryImplicitAction(Close, drawer);
            }
            "<.p>Done. ";
        }
        report() { }
    }

    dobjFor(LookIn) {
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                tryImplicitAction(Open, drawer);
                if (i > 1) "\b";
                "(searching in <<drawer.theName>>)\n";
                searchCore.clearHistory();
                doNested(LookIn, drawer);
            }
        }
    }

    iobjFor(PutIn) {
        verify() { }
        check() { }
        action() {
            local chosenDrawer = nil;
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                chosenDrawer = drawer;
                if (i > 1) "\b";
                else "\n";
                extraReport('(perhaps in <<drawer.theName>>?)\n');
                if (!drawer.isOpen) {
                    extraReport('(first opening <<drawer.theName>>)\n');
                    drawer.makeOpen(true);
                }
                if (gOutStream.watchForOutput({: drawer.checkIobjPutIn() }) != nil) {
                    chosenDrawer = nil;
                }
                if (chosenDrawer != nil) break;
            }
            if (chosenDrawer == nil) {
                "<.p>It{dummy} seem{s/ed} like none of the drawers{plural}
                {is} suitable for {that dobj}. ";
                exit;
            }
            doNested(PutIn, gDobj, chosenDrawer);
        }
        report() { }
    }

    iobjFor(TakeFrom) {
        action() {
            for (local i = 1; i <= 3; i++) {
                local drawer = getDrawer(i);
                if (gDobj.isIn(drawer)) {
                    extraReport('\n(taking from <<drawer.theName>>)\n');
                    doNested(TakeFrom, gDobj, drawer);
                    return;
                }
            }
        }
        report() { }
    }

    notionalContents() {
        local nc = [];
        
        for (local i = 1; i <= 3; i++) {
            local drawer = getDrawer(i);
            if (drawer.isOpen || drawer.isTransparent) {
                nc = nc + drawer.contents;
            }
        }
        
        return nc;
    }
;

#define CabinetDrawerProperties \
    desc = "A metal drawer of a filing cabinet. " \
    subLocation = &remapIn \
    contType = In \
    bulkCapacity = actorCapacity \
    maxSingleBulk = 1 \
    isOpenable = true \
    distOrder = 1 \
    /* Stuff to acknowledge attempts to climb drawers */ \
    getParkourModule() { return nil; } \
    parkourModule = nil \
    cannotBoardMsg = \
        '{The dobj} {is} too unstable to use for climbing. '

DefineDistSubComponentFor(TopCabinetDrawer, FilingCabinet, topDrawer)
    vocab = 'top drawer;upper first'
    nameAs(parent) {
        name = 'top drawer';
    }
    CabinetDrawerProperties
;

DefineDistSubComponentFor(MiddleCabinetDrawer, FilingCabinet, middleDrawer)
    vocab = 'middle drawer;mid second center'
    nameAs(parent) {
        name = 'middle drawer';
    }
    CabinetDrawerProperties
;

DefineDistSubComponentFor(BottomCabinetDrawer, FilingCabinet, bottomDrawer)
    vocab = 'bottom drawer;lower lowest third'
    nameAs(parent) {
        name = 'bottom drawer';
    }
    CabinetDrawerProperties
;

// Fridge
class Fridge: Fixture {
    vocab = 'refrigerator;snack;fridge'
    desc = "A normal refrigerator, painted white. "

    betterStorageHeader
    IncludeDistComponent(TinyDoorHandle)
}

DefineDistSubComponentFor(FridgeRemapOn, Fridge, remapOn)
    isBoardable = true
    betterStorageHeader
;

DefineDistSubComponentFor(FridgeRemapIn, Fridge, remapIn)
    isOpenable = true
    bulkCapacity = actorCapacity
    maxSingleBulk = 1
;

// Handles and other details
#define basicHandleProperties \
    distOrder = 2 \
    isDecoration = true \
    decorationActions = [Examine, Push, Pull, Taste, Lick] \
    matchPhrases = ['handle', 'bar', 'latch'] \
    addParentVocab(_lexParent) { \
        if (_lexParent != nil) { \
            local lexParentWords = _lexParent.name.split(' '); \
            local startIndex = 1; \
            if (lexParentWords[1] == 'the' || lexParentWords[1] == 'a') { \
                startIndex = 2; \
            } \
            local weakLexParentWords = lexParentWords[startIndex] + '[weak]'; \
            for (local i = startIndex + 1; i <= lexParentWords.length; i++) { \
                weakLexParentWords += ' ' + lexParentWords[i] + '[weak]'; \
            } \
            addVocab(';' + weakLexParentWords + ';'); \
        } \
    } \
    dobjFor(Taste) { \
        verify() { } \
        check() { } \
        action() { } \
        report() { \
            if (gameMain.lickedHandle) { \
                "Tastes like it's been well-used. "; \
            } \
            else { \
                gameMain.lickedHandle = true; \
                "As {my} tongue leaves its surface, subtle flashbacks of someone \
                else's memories pass through {my} mind, like muffled echoes.\b \
                {I} think {i} remember a name, reaching out from the whispers:\b \
                <center><i><q>Rovarsson...</q></i></center>\b \
                {I}{'m} not really sure what to make of that. Probably should not \
                lick random handles anymore, though. "; \
            } \
        } \
    }

#define handleActions(targetAction, actionTarget) \
    dobjFor(Push) { \
        verify() { \
            if (!isPushable) illogical(cannotPushMsg); \
        } \
        check() { } \
        action() { \
            doInstead(targetAction, actionTarget); \
        } \
        report() { } \
    } \
    dobjFor(Pull) { \
        verify() { \
            if (!isPullable) illogical(cannotPullMsg); \
            if (gActorIsCat) inaccessible(pawsCannotPullMsg); \
        } \
        check() { } \
        action() { \
            doInstead(targetAction, actionTarget); \
        } \
        report() { } \
    }

#define pushPullHandleProperties \
    basicHandleProperties \
    postCreate(_lexParent) { \
        addParentVocab(_lexParent); \
    } \
    cannotPushMsg = '{That dobj} {is} not a push door. ' \
    cannotPullMsg = '{That dobj} {is} not a pull door. ' \
    handleActions(Open, lexicalParent)

DefineDistComponentFor(PushDoorHandle, Door)
    vocab = 'handle;door[weak] push[weak] pull[weak];bar'
    desc = "A push bar spans the width of the door. "

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && !obj.skipHandle && !obj.pullHandleSide;
    }

    isPushable = true

    pushPullHandleProperties
;

DefineDistComponentFor(PullDoorHandle, Door)
    vocab = 'handle;door[weak] push[weak] pull[weak] metal[weak];bar loop'
    desc = "A large, metal loop sits in a track, which spans half the width
        of the door. "

    getMiscInclusionCheck(obj, normalInclusionCheck) {
        return normalInclusionCheck && !obj.skipHandle && obj.pullHandleSide;
    }

    isPullable = true

    pushPullHandleProperties
;

#define tinyDoorHandleProperties \
    vocab = 'handle;metal[weak] pull[weak];latch' \
    desc = "A tiny pull latch, which can open \
        <<hatch == nil ? 'containers' : hatch.theName>>. " \
    basicHandleProperties \
    cannotPushMsg = '{That dobj} {is} not a push latch. ' \
    cannotPullMsg = '{That dobj} {is} not a pull latch. ' \
    isPullable = true \
    hatch = nil \
    getMiscInclusionCheck(obj, normalInclusionCheck) { \
        return normalInclusionCheck && !obj.ofKind(Door) && (getLikelyHatch(obj) != nil); \
    } \
    preCreate(_lexParent) { \
        hatch = getLikelyHatch(_lexParent); \
        if (hatch != nil) { \
            owner = hatch; \
            ownerNamed = true; \
        } \
    } \
    postCreate(_lexParent) { \
        addParentVocab(hatch); \
    } \
    remapReach(action) { \
        return hatch; \
    } \
    handleActions(Open, hatch)

DefineDistComponent(TinyDoorHandle)
    getLikelyHatch(obj) {
        if (obj.remapIn != nil) {
            if (obj.remapIn.contType == In && obj.remapIn.isOpenable) {
                return obj.remapIn;
            }
        }
        if (obj.remapOn != nil) {
            if (obj.remapOn.contType == In && obj.remapOn.isOpenable) {
                return obj.remapOn;
            }
        }
        return nil;
    }

    tinyDoorHandleProperties
;

DefineDistComponent(TinyDoorTopDrawerHandle)
    getLikelyHatch(obj) {
        return obj.topDrawer;
    }

    tinyDoorHandleProperties
;

DefineDistComponent(TinyDoorMiddleDrawerHandle)
    getLikelyHatch(obj) {
        return obj.middleDrawer;
    }

    tinyDoorHandleProperties
;

DefineDistComponent(TinyDoorBottomDrawerHandle)
    getLikelyHatch(obj) {
        return obj.bottomDrawer;
    }

    tinyDoorHandleProperties
;
#define expandedOnto ('onto'|'on' 'to')
#define expandedInto ('in'|'into'|'in' 'to'|'through')
#define expandedUpSideOf (('the'|) 'side' 'of'|'to'|)
#define genericOnTopOfPrep ('on'|expandedOnto|'on' 'top' 'of'|expandedOnto 'the' 'top' 'of'|'atop')
#define genericAcrossPrep ('over'|'across'|'over' 'to'|'across' 'to'|'to'|'onto'|'on' 'to') (('the'|)'top' 'of'|)

VerbRule(ParkourClimbOverTo)
    ('climb'|'cl'|'get'|'step') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourClimbOverTo
    verbPhrase = 'climb over to (what)'
    missingQ = 'what do you want to climb over to'
;

DefineTAction(ParkourClimbOverTo)
;

VerbRule(ParkourClimbOverInto)
    ('climb'|'cl'|'get'|'step') expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbOverInto
    verbPhrase = 'climb through (what)'
    missingQ = 'what do you want to climb through'
;

DefineTAction(ParkourClimbOverInto)
;

VerbRule(ParkourJumpOverTo)
    ('jump'|'hop'|'leap') genericAcrossPrep singleDobj
    : VerbProduction
    action = ParkourJumpOverTo
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpOverTo)
;

VerbRule(ParkourJumpOverInto)
    ('jump'|'hop'|'leap') expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpOverInto
    verbPhrase = 'jump through (what)'
    missingQ = 'what do you want to jump through'
;

DefineTAction(ParkourJumpOverInto)
;

VerbRule(ParkourJumpUpTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' expandedUpSideOf singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUpTo
    verbPhrase = 'jump up (what)'
    missingQ = 'what do you want to jump up'
;

DefineTAction(ParkourJumpUpTo)
;

VerbRule(ParkourJumpUpInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'wall' 'run'|'wallrun') 'up' expandedInto singleDobj |
    'clamber' singleDobj
    : VerbProduction
    action = ParkourJumpUpInto
    verbPhrase = 'jump up into (what)'
    missingQ = 'what do you want to jump up into'
;

DefineTAction(ParkourJumpUpInto)
;

VerbRule(ParkourJumpDownTo)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourJumpDownTo
    verbPhrase = 'jump down to (what)'
    missingQ = 'what do you want to jump down to'
;

DefineTAction(ParkourJumpDownTo)
;

VerbRule(ParkourJumpDownInto)
    ('jump'|'hop'|'leap'|'clamber'|'scramble'|'drop'|'fall') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourJumpDownInto
    verbPhrase = 'jump down into (what)'
    missingQ = 'what do you want to jump down into'
;

DefineTAction(ParkourJumpDownInto)
;

VerbRule(ParkourClimbDownTo)
    ('climb'|'cl'|'get'|'step') 'down' 'to' singleDobj
    : VerbProduction
    action = ParkourClimbDownTo
    verbPhrase = 'climb down to (what)'
    missingQ = 'what do you want to climb down to'
;

DefineTAction(ParkourClimbDownTo)
;

VerbRule(ParkourClimbDownInto)
    ('climb'|'cl'|'get'|'step') 'down' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbDownInto
    verbPhrase = 'climb down into (what)'
    missingQ = 'what do you want to climb down into'
;

DefineTAction(ParkourClimbDownInto)
;

VerbRule(ParkourClimbUpInto)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedInto singleDobj
    : VerbProduction
    action = ParkourClimbUpInto
    verbPhrase = 'climb up into (what)'
    missingQ = 'what do you want to climb up into'
;

DefineTAction(ParkourClimbUpInto)
;

VerbRule(ParkourClimbUpTo)
    ('climb'|'cl'|'mantel'|'mantle'|'go'|'walk'|'run'|'sprint') 'up' expandedUpSideOf singleDobj
    : VerbProduction
    action = ParkourClimbUpTo
    verbPhrase = 'climb up to (what)'
    missingQ = 'what do you want to climb up to'
;

DefineTAction(ParkourClimbUpTo)
;

VerbRule(ParkourJumpGeneric)
    ('jump'|'hop'|'leap'|'jm') singleDobj
    : VerbProduction
    action = ParkourJumpGeneric
    verbPhrase = 'jump to (what)'
    missingQ = 'what do you want to jump to'
;

DefineTAction(ParkourJumpGeneric)
;

VerbRule(ParkourClimbGeneric)
    ('climb'|'cl'|'mantel'|'mantle'|'mount'|'board') singleDobj |
    ('climb'|'cl'|'mantel'|'mantle'|'get'|'go') genericOnTopOfPrep singleDobj |
    'parkour' ('to'|'on'|) singleDobj
    : VerbProduction
    action = ParkourClimbGeneric
    verbPhrase = 'parkour to (what)'
    missingQ = 'what do you want to parkour to'
;

DefineTAction(ParkourClimbGeneric)
;

VerbRule(ParkourSlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither') 'under' singleDobj
    : VerbProduction
    action = ParkourSlideUnder
    verbPhrase = 'slide under (what)'
    missingQ = 'what do you want to slide under'
;

DefineTAction(ParkourSlideUnder)
;

VerbRule(ParkourJumpOver)
    ('jump'|'hop'|'leap'|'vault') ('over'|) singleDobj
    : VerbProduction
    action = ParkourJumpOver
    verbPhrase = 'jump over (what)'
    missingQ = 'what do you want to jump over'
;

DefineTAction(ParkourJumpOver)
;

VerbRule(ParkourRunAcross)
    ('run'|'sprint'|'hop'|'go'|'walk') 'across' singleDobj
    : VerbProduction
    action = ParkourRunAcross
    verbPhrase = 'run across (what)'
    missingQ = 'what do you want to run across'
;

DefineTAction(ParkourRunAcross)
;

VerbRule(ParkourSwingOn)
    'swing' ('on'|'under'|'with'|'using'|'via'|'across') singleDobj
    : VerbProduction
    action = ParkourSwingOn
    verbPhrase = 'swing on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(ParkourSwingOn)
;

VerbRule(SlideUnder)
    ('slide'|'dive'|'roll'|'go'|'crawl'|'scramble'|'slither') 'under' singleDobj
    : VerbProduction
    action = SlideUnder
    verbPhrase = 'slide under (what)'
    missingQ = 'what do you want to slide under'
;

DefineTAction(SlideUnder)
;

VerbRule(RunAcross)
    ('run'|'sprint'|'hop'|'go'|'walk') 'across' singleDobj
    : VerbProduction
    action = RunAcross
    verbPhrase = 'run across (what)'
    missingQ = 'what do you want to run across'
;

DefineTAction(RunAcross)
;

VerbRule(SwingOn)
    'swing' ('on'|'under'|'with'|'using'|'via'|'across') singleDobj
    : VerbProduction
    action = SwingOn
    verbPhrase = 'swing on (what)'
    missingQ = 'what do you want to swing on'
;

DefineTAction(SwingOn)
;

VerbRule(ParkourClimbOffOf)
    ('get'|'climb'|'cl'|'parkour') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourClimbOffOf
    verbPhrase = 'get off of (what)'
    missingQ = 'what do you want to get off of'
;

DefineTAction(ParkourClimbOffOf)
;

VerbRule(ParkourClimbOffIntransitive)
    ('get'|'climb'|'cl'|'parkour') ('off'|'down')
    : VerbProduction
    action = ParkourClimbOffIntransitive
    verbPhrase = 'climb/climbing off'        
;

DefineIAction(ParkourClimbOffIntransitive)
    allowAll = nil

    execAction(cmd) {
        doInstead(ParkourClimbOffOf, gActor.location);
    }
;

VerbRule(ParkourJumpOffOf)
    ('jump'|'hop'|'leap'|'fall'|'drop') ('off'|'off' 'of'|'down' 'from') singleDobj
    : VerbProduction
    action = ParkourJumpOffOf
    verbPhrase = 'jump off of (what)'
    missingQ = 'what do you want to jump off of'
;

DefineTAction(ParkourJumpOffOf)
;

VerbRule(ParkourJumpOffIntransitive)
    ('jump'|'hop'|'leap'|'fall'|'drop') ('off'|'down')
    : VerbProduction
    action = ParkourJumpOffIntransitive
    verbPhrase = 'jump/jumping off'        
;

DefineIAction(ParkourJumpOffIntransitive)
    allowAll = nil

    execAction(cmd) {
        doInstead(ParkourJumpOffOf, gActor.location);
    }
;

VerbRule(ShowParkourRoutes)
    ((('show'|'list'|'remember'|'review'|'ponder'|'study'|'find'|'search') ('all'|'available'|'known'|'familiar'|'traveled'|'travelled'|)|)
    (
        (('climbing'|'parkour') ('paths'|'pathways'|'options'|'routes')) |
        (('climbable'|'jumpable') ('paths'|'pathways'|'options'|'routes'|'platforms'|'surfaces'|'fixtures'|'things'|'spots'|'stuff'|'objects'|'furniture'|'ledges'|'places'))
    )) |
    ('parkour'|'prkr'|'pkr'|'pk'|'routes'|'paths'|'pathways')
    : VerbProduction
    action = ShowParkourRoutes
    verbPhrase = 'show/showing parkour routes'        
;

DefineIAction(ShowParkourRoutes)
    allowAll = nil

    execAction(cmd) {
        local closestParkourMod = gActor.getParkourModule();
        if (closestParkourMod != nil) {
            if (closestParkourMod.pathVector.length > 0) {
                local strBfr = new StringBuffer(6*closestParkourMod.pathVector.length);
                for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
                    local path = closestParkourMod.pathVector[i];

                    strBfr.append('{I} {can} ');
                    if (path.requiresJump) {
                        strBfr.append('JUMP ');
                    }
                    else {
                        strBfr.append('CLIMB ');
                    }
                    switch (path.direction) {
                        case parkourUpDir:
                            strBfr.append('up ');
                            break;
                        case parkourOverDir:
                            strBfr.append('over ');
                            break;
                        case parkourDownDir:
                            strBfr.append('down ');
                            break;
                    }
                    strBfr.append('to ');
                    strBfr.append(path.destination.parkourModule.theName);
                    strBfr.append('. ');
                }
                "<<toString(strBfr)>>";
                return;
            }
        }
        "<<parkourCache.noKnownRoutesMsg>>";
    }
;

#define gParkourLastPath parkourCache.lastPath

parkourCache: object {
    requireRouteRecon = true
    formatForScreenReader = nil

    lastPath = nil
    noKnownRoutesMsg =
        '{I} {do} not {know} any routes from here. '
}

#define dobjParkourRemap(parkourAction, remapAction) \
    dobjFor(parkourAction) { \
        preCond = [touchObj] \
        remap = (parkourModule) \
        verify() { } \
        check() { } \
        action() { \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

#define dobjParkourIntoRemap(parkourIntoAction, remapAction) \
    dobjFor(parkourIntoAction) { \
        preCond = [touchObj] \
        verify() { } \
        check() { } \
        action() { \
            if (gActor.location != stagingLocation) { \
                if (stagingLocation.parkourModule == nil) { \
                    tryImplicitAction(stagingLocation.climbOnAlternative, stagingLocation); \
                } \
                else { \
                    tryImplicitAction(ParkourJumpGeneric, stagingLocation.parkourModule); \
                } \
            } \
            doInstead(remapAction, self); \
        } \
        report() { } \
    }

modify Thing {
    parkourModule = nil
    prepForParkour() {
        // Check if we already handle parkour
        if (parkourModule != nil) return;

        parkourModule = new ParkourModule(self);

        // Make absolutely certain that everything is done
        // through parkour now:
        remapDobjBoard = parkourModule;
        remapDobjGetOff = parkourModule;
        remapDobjJumpOff = parkourModule;
        remapDobjPutOn = parkourModule;
        remapDobjClimb = parkourModule;
        remapDobjClimbUp = parkourModule;
        remapDobjClimbDown = parkourModule;
        remapDobjJumpOver = parkourModule;
        remapDobjSlideUnder = parkourModule;
        remapDobjRunAcross = parkourModule;
        remapDobjSwingOn = parkourModule;
        remapDobjPutIn = parkourModule;
    }

    isShortContainer = nil // Allows reaching to top from inside or under

    getParkourModule() {
        if (parkourModule != nil) return parkourModule;
        if (lexicalParent != nil) {
            if (lexicalParent.parkourModule != nil) {
                if (lexicalParent.remapOn == self || isShortContainer) {
                    return lexicalParent.parkourModule;
                }
                return nil;
            }
        }
        if (!isLikelyContainer()) { // Likely an actor or item
            if (location != nil) {
                if (location.parkourModule != nil) {
                    return location.parkourModule;
                }
            }
        }
        return nil;
    }

    isLikelyContainer() {
        if (ofKind(Actor)) return nil; // Obvious
        if (contType != nil) return true;
        if (remapOn != nil) return true;
        if (remapIn != nil) return true;
        if (remapUnder != nil) return true;
        if (remapBehind != nil) return true;
        return nil;
    }

    climbOnAlternative = (isClimbable ? Climb : (canClimbUpMe ? ClimbUp : Board))
    climbOffAlternative = (canClimbDownMe ? ClimbDown : GetOff)
    enterAlternative = (canGoThroughMe ? GoThrough : Enter)
    jumpOffAlternative = JumpOff

    dobjParkourRemap(ParkourClimbGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourJumpGeneric, climbOnAlternative)
    dobjParkourRemap(ParkourClimbOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpOverTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpUpTo, climbOnAlternative)
    dobjParkourRemap(ParkourClimbDownTo, climbOnAlternative)
    dobjParkourRemap(ParkourJumpDownTo, climbOnAlternative)

    //TODO: We are handling "into" differently.
    //      This time, we are chaining a parkour and gothrough action.
    dobjParkourIntoRemap(ParkourClimbOverInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpOverInto, enterAlternative)
    dobjParkourIntoRemap(ParkourClimbUpInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpUpInto, enterAlternative)
    dobjParkourIntoRemap(ParkourClimbDownInto, enterAlternative)
    dobjParkourIntoRemap(ParkourJumpDownInto, enterAlternative)

    dobjParkourRemap(ParkourJumpOver, JumpOver)
    dobjParkourRemap(ParkourSlideUnder, SlideUnder)
    dobjParkourRemap(ParkourRunAcross, RunAcross)
    dobjParkourRemap(ParkourSwingOn, SwingOn)

    dobjParkourRemap(ParkourClimbOffOf, climbOffAlternative)
    dobjParkourRemap(ParkourJumpOffOf, jumpOffAlternative)

    canSlideUnderMe = nil

    dobjFor(SlideUnder) {
        preCond = [touchObj]

        remap = remapUnder

        verify() { 
            if(!canSlideUnderMe) {
                illogical(cannotSlideUnderMsg);
            }
        }
        action() { }
        report() {
            "{I} {slide} under {the subj dobj}. ";
        }
    }

    canRunAcrossMe = nil

    dobjFor(RunAcross) {
        preCond = [touchObj]

        remap = remapOn

        verify() { 
            if(!canRunAcrossMe) {
                illogical(cannotRunAcrossMsg);
            }
        }
        action() { }
        report() {
            "{I} {run} across {the subj dobj}. ";
        }
    }

    canSwingOnMe = nil

    dobjFor(SwingOn) {
        preCond = [touchObj]

        remap = remapUnder

        verify() { 
            if(!canSwingOnMe) {
                illogical(cannotSwingOnMsg);
            }
        }
        action() { }
        report() {
            "{I} {swing} on {the subj dobj}, and {let} go. ";
        }
    }

    cannotSlideUnderMsg =
        '{The subj dobj} {is} not something {i} {can} slide under. '
    cannotRunAcrossMsg =
        '{The subj dobj} {is} not something {i} {can} run across. '
    cannotSwingOnMsg =
        '{The subj dobj} {is} not something {i} {can} swing on. '
    noParkourPathFromHereMsg =
        '{I} {have} no path to get there. '
    parkourNeedsJumpMsg =
        '{I} need{s/ed} to JUMP instead, if {i} want{s/ed} to get there. '
    parkourUnnecessaryJumpMsg =
        '({I} {can} get there easily, so {i} decide{s/d} against jumping.) '
}

modify Room {
    parkourModule = perInstance(new ParkourModule(self))
}

modify SubComponent {
    parkourModule = (lexicalParent == nil ? nil : lexicalParent.parkourModule)
}

#define verifyClimbPathFromActor(actor, canBeUnknown) \
    verifyJumpPathFromActor(actor, canBeUnknown) \
    if (gParkourLastPath.requiresJump) { \
        illogical(parkourNeedsJumpMsg); \
    }

#define verifyJumpPathFromActor(actor, canBeUnknown) \
    gParkourLastPath = getPathFrom(actor, canBeUnknown); \
    if (gParkourLastPath == nil) { \
        illogical(noParkourPathFromHereMsg); \
        return; \
    }

#define tryClimbInstead(climbAction) \
    if (!gParkourLastPath.requiresJump) { \
        extraReport(parkourUnnecessaryJumpMsg + '\n'); \
        doInstead(climbAction, self); \
    }

class ParkourModule: SubComponent {
    construct(prkrParent?) {
        if (prkrParent != nil) {
            lexicalParent = prkrParent;
            parent = prkrParent;
        }
        //say('\bConstructed!\b');
        inherited();
        preinitThing();
    }

    // Stuff for vocab
    // It seems like the init status of a room is not always
    // timed well for the init status of a ParkourModule,
    // so just require it to take the current info.
    aName = (getVocabFromParent(&aName))
    theName = (getVocabFromParent(&theName))
    theObjName = (getVocabFromParent(&theObjName))
    objName = (getVocabFromParent(&objName))
    possAdj = (getVocabFromParent(&possAdj))
    possNoun = (getVocabFromParent(&possNoun))
    name = (getVocabFromParent(&name))
    proper = (getVocabFromParent(&proper))
    qualified = (getVocabFromParent(&qualified))
    person = (getVocabFromParent(&person))
    plural = (getVocabFromParent(&plural))
    massNoun = (getVocabFromParent(&massNoun))
    isHim = (getVocabFromParent(&isHim))
    isHer = (getVocabFromParent(&isHer))
    isIt = (getVocabFromParent(&isIt))
    getVocabFromParent(vProp) {
        if (parent == nil) return '(oops)';
        if (parent.ofKind(Room)) {
            if (parent.floorObj != nil) {
                return parent.floorObj.(vProp);
            }
        }
        return parent.(vProp);
    }
    // End stuff for vocab

    parkourModule = self

    pathVector = perInstance(new Vector())
    preInitDone = nil

    preinitThing() { // Safety check
        if (preInitDone) return;
        inherited();
        //say('\bPreinit!\b');
        preInitDone = true;
    }

    // Mostly follows default SubComponent functionality
    initializeSubComponent(parent) {
        if(parent == nil) return;
        location = parent;
       
        // Parkour is typically "On", arbitrarily
        contType = On;
        listOrder = contType.listOrder;
    }

    getParkourModule() {
        return self;
    }

    addPath(parkourPath) {
        for (local i = 1; i <= pathVector.length; i++) {
            if (pathVector[i].destination == parkourPath.destination) {
                if (pathVector[i].provider == parkourPath.provider) {
                    throw new Exception(
                        'Attempted duplicate path from ' +
                        theName + ' to ' +
                        parkourPath.destination.theName + '!'
                    );
                }
            }
        }
        pathVector.append(parkourPath);
    }

    provideMoveFor(actor) {
        local plat = parent;
        if (plat.remapOn != nil) {
            plat = plat.remapOn;
        }
        actor.actionMoveInto(plat);
    }

    getPathFrom(source, canBeUnknown?) {
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) return nil;
        if (closestParkourMod == self) return nil;
        local jumpPath = nil;
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            if (path.isKnown || canBeUnknown) {
                if (path.requiresJump) {
                    jumpPath = path;
                }
                else {
                    return path; // Prioritize climbing
                }
            }
        }

        return jumpPath;
    }

    hasPathFrom(source, canBeUnknown?) {
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) return nil;
        if (closestParkourMod == self) return nil;
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            if (path.isKnown || canBeUnknown) {
                return true;
            }
        }
        return nil;
    }

    isInReachFrom(source, canBeUnknown?) { //TODO: Handle Q check
        local closestParkourMod = source.getParkourModule();
        if (closestParkourMod == nil) {
            // Last ditch ideas for related non-parkour containers!
            // If the source left its current container,
            // would it be on us?
            if (isLikelyContainer()) {
                if (source.exitLocation == self.lexicalParent) return true;
                if (source.stagingLocation == self.lexicalParent) return true;
            }
            else if (source.location != nil) { // Likely an actor or item
                if (source.location.exitLocation == self.lexicalParent) return true;
                if (source.location.stagingLocation == self.lexicalParent) return true;
            }
            return nil;
        }
        if (closestParkourMod == self) return true;
        for (local i = 1; i <= closestParkourMod.pathVector.length; i++) {
            local path = closestParkourMod.pathVector[i];
            if (path.destination != self.lexicalParent) continue;
            if (path.provider != nil) continue;
            if (path.requiresJump) continue;
            if (path.isKnown || canBeUnknown) {
                return true;
            }
        }
        return nil;
    }

    // Generic conversions
    dobjFor(Board) asDobjFor(ParkourClimbGeneric)
    dobjFor(Climb) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbUp) asDobjFor(ParkourClimbGeneric)
    dobjFor(ClimbDown) asDobjFor(ParkourClimbOffOf)
    dobjFor(GetOff) asDobjFor(ParkourClimbOffOf)
    dobjFor(JumpOff) asDobjFor(ParkourJumpOffOf)
    dobjFor(JumpOver) asDobjFor(ParkourJumpOver)
    dobjFor(SlideUnder) asDobjFor(ParkourSlideUnder)
    dobjFor(RunAcross) asDobjFor(ParkourRunAcross)
    dobjFor(SwingOn) asDobjFor(ParkourSwingOn)

    //TODO: Actions
    dobjFor(ParkourClimbGeneric) {
        preCond = [touchObj]
        remap = nil
        verify() {
            verifyClimbPathFromActor(gActor, nil);
        }
        check() { checkInsert(gActor); }
        action() {
            //
        }
    }

    dobjFor(ParkourJumpGeneric) {
        preCond = [touchObj]
        remap = nil
        verify() {
            verifyJumpPathFromActor(gActor, nil);
        }
        check() { checkInsert(gActor); }
        action() {
            tryClimbInstead(ParkourClimbGeneric);
            //
        }
    }
}

enum parkourUpDir, parkourOverDir, parkourDownDir;

class ParkourPath: object {
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir
    isTrulyKnown = nil

    isKnown = (isTrulyKnown || !parkourCache.requireRouteRecon)
}

class ParkourPathMaker: PreinitObject {
    location = nil
    destination = nil
    provider = nil
    requiresJump = nil
    isHarmful = nil
    direction = parkourOverDir

    execute() {
        location.prepForParkour();
        destination.prepForParkour();
        createForwardPath();
        createBackwardPath();
    }

    createForwardPath() {
        location.parkourModule.addPath(getNewPathObject());
    }

    createBackwardPath() { }

    getNewPathObject() {
        local path = new ParkourPath();
        path.destination = destination;
        path.provider = provider;
        path.requiresJump = requiresJump;
        path.isHarmful = isHarmful;
        path.direction = direction;
        return path;
    }
}

/*
 * PATH TYPES
 */

// Climb paths
ClimbUpPath template ->destination;
class ClimbUpPath: ParkourPathMaker {
    direction = parkourUpDir
}

ClimbOverPath template ->destination;
class ClimbOverPath: ParkourPathMaker {
    direction = parkourOverDir
}

ClimbDownPath template ->destination;
class ClimbDownPath: ParkourPathMaker {
    direction = parkourDownDir
}

// Jump paths
JumpUpPath template ->destination;
class JumpUpPath: ParkourPathMaker {
    direction = parkourUpDir
    requiresJump = true
}

JumpOverPath template ->destination;
class JumpOverPath: ParkourPathMaker {
    direction = parkourOverDir
    requiresJump = true
}

JumpDownPath template ->destination;
class JumpDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
}

FallDownPath template ->destination;
class FallDownPath: ParkourPathMaker {
    direction = parkourDownDir
    requiresJump = true
    isHarmful = true
}

// Two-way
class ParkourLinkMaker: ParkourPathMaker {
    requiresJumpBack = (requiresJump)
    isHarmfulBack = (isHarmful)

    createBackwardPath() {
        local backPath = getNewPathObject();
        backPath.destination = location;
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        switch (backPath.direction) {
            case parkourUpDir:
                backPath.direction = parkourDownDir;
                break;
            case parkourDownDir:
                backPath.direction = parkourUpDir;
                break;
        }
        destination.parkourModule.addPath(backPath);
    }
}

// Two-way climb paths
ClimbUpLink template ->destination;
class ClimbUpLink: ParkourLinkMaker {
    direction = parkourUpDir
}

ClimbOverLink template ->destination;
class ClimbOverLink: ParkourLinkMaker {
    direction = parkourOverDir
}

ClimbDownLink template ->destination;
class ClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
}

// Two-way jump paths
JumpUpLink template ->destination;
class JumpUpLink: ParkourLinkMaker {
    direction = parkourUpDir
    requiresJump = true
    requiresJumpBack = nil
}

JumpOverLink template ->destination;
class JumpOverLink: ParkourLinkMaker {
    direction = parkourOverDir
    requiresJump = true
}

AwkwardClimbDownLink template ->destination;
class AwkwardClimbDownLink: ParkourLinkMaker {
    direction = parkourDownDir
    requiresJump = nil
    requiresJumpBack = true
}

// Floor heights
class FloorHeight: ParkourLinkMaker {
    destination = (location.stagingLocation)
    requiresJump = nil
    isHarmful = nil
    requiresJumpBack = nil
    isHarmfulBack = nil
    direction = parkourDownDir

    createBackwardPath() {
        local backPath = getNewPathObject();
        backPath.destination = location;
        backPath.direction = parkourUpDir;
        backPath.requiresJump = requiresJumpBack;
        backPath.isHarmful = isHarmfulBack;
        destination.parkourModule.addPath(backPath);
    }
}

class LowFloorHeight: FloorHeight {
    //
}

class AwkwardFloorHeight: FloorHeight {
    requiresJumpBack = true
}

class HighFloorHeight: FloorHeight {
    requiresJump = true

    createBackwardPath() { } // No way up
}

class DangerousFloorHeight: FloorHeight {
    requiresJump = true
    isHarmful = true

    createBackwardPath() { } // No way up
}
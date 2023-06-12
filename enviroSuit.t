suitTracker: object {
    missingPieces = static new Vector([
        enviroHelmet,
        enviroTorso,
        enviroPants,
        enviroLeftGlove,
        enviroRightGlove,
        enviroLeftBoot,
        enviroRightBoot
    ])
    gatheredPieces = static new Vector(8)
    discoveredPieces = static new Vector(8)

    getCount() {
        return gatheredPieces.length;
    }

    markPiece(piece) {
        local oldCount = getCount();
        gatheredPieces.appendUnique(piece);
        local newCount = getCount();
        if (oldCount != newCount) {
            discoveredPieces.append(piece);
            if (announceDaemon != nil) return;
            announceDaemon = new OneTimePromptDaemon(self, &announcePieces);
        }
    }

    announceDaemon = nil

    announcePieces() {
        if (discoveredPieces.length == 0) {
            clearAnnounceEvent();
            return;
        }
        local strList = 'the ' + makeListStr(valToList(discoveredPieces), &shortName, 'and');
        local numLeft = getNumberLeft();
        local toGoPhrase = 'That\'s all of them! {I} must enter the Emergency Airlock!!
            {I} cannot allow <<gSkashekName>> to stop me now! {My} victory is so close!\b
            <i>(Set your compass by typing in
            <<formatCommand('go to emergency airlock', longCmd)>>,
            and find the next step in the route with
            <<formatTheCommand('compass', shortCmd)>>!)</i>';
        if (numLeft > 0) {
            local pieceNoun = 'piece';
            if (numLeft != 1) pieceNoun += 's';
            toGoPhrase = 'Only ' + spellNumber(7 - getCount()) +
                ' more envirosuit ' + pieceNoun + ' to go!';
        }
        say('<.p><b>{I} found ' + strList + '!</b>\b' + toGoPhrase + '<.p>');
        clearAnnounceEvent();
    }

    clearAnnounceEvent() {
        if (announceDaemon != nil) announceDaemon.removeEvent();
        announceDaemon = nil;
    }

    getNumberLeft() {
        return 7 - getCount();
    }

    getProgressLists() {
        local strBfr = new StringBuffer(18);
        local inventory = valToList(gPlayerChar.contents);

        local carriedParts = [];
        local partsFound = [];
        local partsRemaining = [];
        local indexRem = 0;
        
        for (local i = 1; i <= inventory.length; i++) {
            local obj = inventory[i];
            if (!obj.ofKind(EnviroSuitPart)) continue;
            carriedParts += obj;
        }
        for (local i = 1; i <= gatheredPieces.length; i++) {
            local obj = gatheredPieces[i];
            indexRem = carriedParts.indexOf(obj);
            if (indexRem != nil) continue;
            partsFound += obj;
        }
        for (local i = 1; i <= missingPieces.length; i++) {
            local obj = missingPieces[i];
            indexRem = carriedParts.indexOf(obj);
            if (indexRem != nil) continue;
            indexRem = partsFound.indexOf(obj);
            if (indexRem != nil) continue;
            partsRemaining += obj;
        }

        if (carriedParts.length > 0) {
            strBfr.append('{I} {am} currently carrying the ');
            strBfr.append(makeListStr(carriedParts, &shortName, 'and'));
            strBfr.append('. ');
        }
        if (partsFound.length > 0) {
            strBfr.append('\b{I} have found (but {am} not carrying) the ');
            strBfr.append(makeListStr(partsFound, &getLocationString, 'and'));
            strBfr.append('. ');
        }
        if (partsRemaining.length > 0) {
            strBfr.append('\b{I} still have to find the ');
            strBfr.append(makeListStr(partsRemaining, &shortName, 'and'));
            strBfr.append('. ');
        }

        strBfr.append('<.p>');
        return toString(strBfr);
    }
}

VerbRule(SlingOverShoulder)
    (
        'sling' singleDobj 'over' |
        ('put'|'carry'|'drape') singleDobj ('on'|'over'|'across') |
        'hang' singleDobj ('on'|'over'|'across'|'from')
    )
    ('my'|'the'|'prey\'s'|'preys'|'your'|) 'shoulder'
    : VerbProduction
    action = SlingOverShoulder
    verbPhrase = 'sling/slinging (what) over the shoulder'
    missingQ = 'what do you want to carry over the shoulder'
;

DefineTAction(SlingOverShoulder)
;

VerbRule(StrapOn)
    'strap' 'on' singleDobj |
    'strap' singleDobj 'on'
    : VerbProduction
    action = StrapOn
    verbPhrase = 'strap/strapping on (what)'
    missingQ = 'what do you want to strap on'
;

DefineTAction(StrapOn)
;

VerbRule(Unstrap)
    'unstrap' singleDobj
    : VerbProduction
    action = Unstrap
    verbPhrase = 'unstrap/unstrapping (what)'
    missingQ = 'what do you want to unstrap'
;

DefineTAction(Unstrap)
;

VerbRule(Zip)
    'zip' singleDobj |
    'zip' ('up'|'closed'|'shut') singleDobj |
    'zip' singleDobj ('up'|'closed'|'shut')
    : VerbProduction
    action = Zip
    verbPhrase = 'zip/zipping up (what)'
    missingQ = 'what do you want to zip up'
;

DefineTAction(Zip)
;

VerbRule(Unzip)
    'unzip' singleDobj |
    'zip' ('open') singleDobj |
    'zip' singleDobj ('open') |
    'unzip' ('open') singleDobj |
    'unzip' singleDobj ('open')
    : VerbProduction
    action = Unzip
    verbPhrase = 'unzip/unzipping up (what)'
    missingQ = 'what do you want to unzip'
;

DefineTAction(Unzip)
;

modify Thing {
    canSlingOverShoulder = nil
    canStrapOn = nil
    canZipMe = nil
    shouldZipMe = (isOpenable && canZipMe)

    cannotZipMsg =
        '{I} {cannot} zip {that dobj}. '

    shouldNotZipMsg =
        '{I} {have} no reason to zip {that dobj}. '

    cannotUnzipMsg =
        '{I} {cannot} unzip {that dobj}. '

    shouldNotUnzipMsg =
        '{I} {have} no reason to unzip {that dobj}. '

    dobjFor(SlingOverShoulder) {
        verify() {
            if (!canSlingOverShoulder) {
                illogical('{That subj dobj} {is} not carried over a shoulder. ');
            }
        }
        action() {
            doInstead(Take, self);
        }
    }

    dobjFor(StrapOn) {
        verify() {
            if (!canStrapOn) {
                illogical('{I} {cannot} strap {that dobj} on. ');
            }
        }
        action() {
            doInstead(Wear, self);
        }
    }

    dobjFor(Unstrap) {
        verify() {
            if (!canStrapOn) {
                illogical('{I} {cannot} unstrap {that dobj}. ');
            }
        }
        action() {
            doInstead(Doff, self);
        }
    }

    dobjFor(Zip) {
        remap() {
            if (!canZipMe && remapIn != nil && remapIn.canZipMe) {
                return remapIn;
            }
            return self;
        }
        verify() {
            if (!canZipMe) {
                inaccessible(cannotZipMsg);
            }
            if (!isOpenable) {
                illogical(
                    '{That subj dobj} {is} already zipped up. '
                );
            }
            else if (!shouldZipMe) {
                illogical(shouldNotZipMsg);
            }
        }
        action() {
            doInstead(Close, self);
        }
    }

    dobjFor(Unzip) {
        remap() {
            if (!canZipMe && remapIn != nil && remapIn.canZipMe) {
                return remapIn;
            }
            return self;
        }
        verify() {
            if (!canZipMe) {
                inaccessible(cannotUnzipMsg);
            }
            if (isOpenable && isOpen) {
                illogical(
                    '{That subj dobj} {is} already unzipped. '
                );
            }
            else if (!shouldZipMe) {
                illogical(shouldNotUnzipMsg);
            }
        }
        action() {
            doInstead(Open, self);
        }
    }

    okayOpenMsg = (canZipMe ?
        'Unzipped. |{I} unzip{s/?ed} <<gActionListStr>>. ' :
        'Opened. |{I} open{s/ed} <<gActionListStr>>. '
    )
    okayClosedMsg = (canZipMe ?
        'Zipped. |{I} zip{s/?ed} up <<gActionListStr>>. ' :
        'Done. |{I} close{s/d} <<gActionListStr>>. '
    )

    dobjFor(Close) {
        report() {
            say(okayClosedMsg);
        }
    }
}

class Zippable: Thing {
    startUnzipped = nil

    IncludeDistComponent(Zipper)
}

DefineDistSubComponentFor(ZippableInternals, Zippable, remapIn)
    isOpen = nil
    isOpenable = true
    canZipMe = true
    distOrder = 1

    postCreate(_lexParent) {
        bulkCapacity = _lexParent.bulkCapacity;
        maxSingleBulk = _lexParent.maxSingleBulk;
        isOpen = _lexParent.startUnzipped;
    }
;

DefineDistComponent(Zipper)
    vocab = 'zipper;;fly tab'
    desc = "A small, metal zipper tab. "
    basicHandleTabProperties
    decorationActions = [Examine, Pull, Open, Close, Zip, Unzip]
    matchPhrases = ['zipper', 'fly', 'tab']

    hatchHandlerProperties

    getLikelyHatch(obj) {
        return obj.remapIn;
    }

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        if (obj.originalPrototype == prototypeFakeZipper) return true;
        return obj.originalPrototype == originalPrototype;
    }

    dobjFor(Open) { remap = (hatch) }
    dobjFor(Close) { remap = (hatch) }
    dobjFor(Zip) { remap = (hatch) }
    dobjFor(Unzip) { remap = (hatch) }
    dobjFor(Pull) {
        remap = nil
        preCond = [touchObj]
        verify() { }
        check() { }
        action() {
            if (hatch.isOpen) {
                doInstead(Zip, hatch);
            }
            else {
                doInstead(Unzip, hatch);
            }
        }
    }
;

class FakeZippable: Thing {
    startUnzipped = nil
    canZipMe = true
    shouldZipMe = nil

    IncludeDistComponent(FakeZipper)
}

DefineDistComponent(FakeZipper)
    vocab = 'zipper;;fly tab'
    desc() { prototypeZipper.desc(); }
    basicHandleTabProperties
    decorationActions = [Examine, Pull, Open, Close, Zip, Unzip]
    matchPhrases = ['zipper', 'fly', 'tab']

    postCreate(_lexParent) {
        addParentVocab(_lexParent);
    }

    remapReach(action) {
        return lexicalParent;
    }

    getLikelyHatch(obj) {
        return obj.remapIn;
    }

    hasPrefabMatchWith(obj) {
        if (!obj.ofKind(AbstractDistributedComponent)) return nil;
        if (obj.originalPrototype == prototypeZipper) return true;
        return obj.originalPrototype == originalPrototype;
    }

    dobjFor(Open) { remap = (lexicalParent) }
    dobjFor(Close) { remap = (lexicalParent) }
    dobjFor(Zip) { remap = (lexicalParent) }
    dobjFor(Unzip) { remap = (lexicalParent) }
    dobjFor(Pull) {
        remap = nil
        preCond = [touchObj]
        verify() { }
        check() { }
        action() {
            if (hatch.isOpen) {
                doInstead(Zip, lexicalParent);
            }
            else {
                doInstead(Unzip, lexicalParent);
            }
        }
    }
;

enviroSuitBag: BagOfHolding, Wearable, Zippable {
    'envirosuit bag;enviro environment suit carryall[weak] duffel;kit carryall'
    "A large duffel bag, which is designed to carry all the pieces of the envirosuit.
    The full suit normally arrives packaged in this, if {i} had to take a guess. "

    bulk = 2
    bulkCapacity = actorCapacity
    maxSingleBulk = 2
    canSlingOverShoulder = true
    canStrapOn = true
    startUnzipped = true

    hideFromAll(action) {
        return wornBy != nil;
    }

    dobjFor(Take) {
        action() {
            inherited();
            nestedAction(Wear, self);
        }
        report() { }
    }
    dobjFor(TakeFrom) {
        action() {
            inherited();
            nestedAction(Wear, self);
        }
        report() { }
    }

    dobjFor(Wear) {
        report() {
            """
            <<first time>>
            <i>Excellent,</i> {i} think to {myself}, as {i} examine
            the bag. Of course it's <i>empty</i>, but {i} won't
            need to carry everything in my hands anymore.\b
            There is a small victory in this.\b
            <<only>>
            {I} sling the envirosuit bag over my shoulder.
            """;
        }
    }

    dobjFor(Doff) {
        report() {
            "{I} slip off the envirosuit bag's strap. ";
        }
    }

    affinityFor(obj) {
        if (obj == fakeHelmet) return 0;
        if (obj.ofKind(Outfit)) return 0;
        if (obj.ofKind(EnviroSuitPart)) return 100;
        return 50;
    }
}
+Fixture { 'strap'
    "A long loop of synthetic fiber, to be put over the wearer's shoulder. "
    owner = [enviroSuitBag]
    ownerNamed = true
    canSlingOverShoulder = true
    canStrapOn = true
    //subLocation = &remapOn

    dobjFor(Take) { remap = enviroSuitBag }
    dobjFor(TakeFrom) { remap = enviroSuitBag }
    dobjFor(Wear) { remap = enviroSuitBag }
    dobjFor(Doff) { remap = enviroSuitBag }
    dobjFor(SlingOverShoulder) { remap = enviroSuitBag }
    dobjFor(StrapOn) { remap = enviroSuitBag }
    dobjFor(Unstrap) { remap = enviroSuitBag }
}

class EnviroSuitPart: Wearable {
    shortName = 'piece'
    piecesLabel = '<b>This is one of the pieces for the environment suit!</b>'
    wearingAll = (!gCatMode && gCommand.matchedAll)

    dobjFor(Wear) {
        preCond = (wearingAll ? nil : [objHeld])
        verify() {
            if (wearingAll) {
                logical;
            }
            else if (!gActor.isIn(emergencyAirlock)) {
                illogical(
                    '{I} do not need to wear the suit right now,
                    as it would only slow me down.
                    {I} just need to have all the pieces{dummy} in {my} inventory,
                    before heading into the Emergency Airlock. {I} can put the suit
                    pieces on <i>after</i> the inner Airlock door is shut! '
                );
            }
        }
        check() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
        action() {
            if (wearingAll) {
                doInstead(Take, self);
                return;
            }
            inherited();
        }
        report() {
            if (wearingAll) {
                return;
            }
            inherited();
        }
    }

    dobjFor(Take) {
        action() {
            inherited();
            suitTracker.markPiece(self);
            if (!isIn(enviroSuitBag) && (
                enviroSuitBag.isIn(gActor) || gActor.canReach(enviroSuitBag)
            )) {
                nestedAction(PutIn, self, enviroSuitBag);
            }
        }
    }

    getLocationString() {
        local str = shortName + ' <b>(';
        if (location.ofKind(Room)) {
            str += location.objInPrep + ' ' + location.roomTitle;
        }
        else {
            str += location.objInPrep + ' ' + location.theName +
                ', in ' + getOutermostRoom().roomTitle;
        }
        return str + ')</b>';
    }

    #if __DEBUG_SUIT
    location = hangar
    #endif
}

enviroHelmet: EnviroSuitPart { 'envirosuit helmet;enviro environment suit;visor piece part'
    "A sealed helmet with a transparent visor. <<piecesLabel>> "
    bulk = 2
    shortName = 'helmet'
}

fakeHelmet: Thing {
    vocab = enviroHelmet.vocab
    desc() {
        if (isRevealedFake) {
            "A <<paperMache>> version of the real envirosuit helmet.
            This will <i>not</i> keep{dummy} {me} safe! ";
        }
        else {
            enviroHelmet.desc();
        }
    }
    bulk = 2
    trueVocab = 'fake helmet;envirosuit enviro environment suit;visor piece part'
    isRevealedFake = nil

    paperMache = 'paper-m\u00E2ch\u00E9'

    itsAFakeMsg =
        '{I} realized the helmet is made of <<paperMache>>. It\'s a fake.
        Truly, <<gSkashekName>>\'s tricks are more plentiful than {my} own. '

    dobjFor(Wear) {
        verify() {
            if (isRevealedFake) {
                illogical('{I} cannot wear this without damaging it.
                    It\'s only made of <<paperMache>>. ');
            }
        }
        check() { }
        action() {
            revealFake();
        }
        report() { }
    }

    dobjFor(Take) {
        action() {
            revealFake();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            revealFake();
            inherited();
        }
    }

    revealFake() {
        isRevealedFake = true;
        replaceVocab(trueVocab);
        say(itsAFakeMsg);
    }
}

enviroTorso: EnviroSuitPart, FakeZippable { 'envirosuit torso;enviro environment suit chest;chestpiece chestplate piece part top shirt'
    "An extra-long-sleeved, insulated, and sealed torso protector.
    A compact life support module is on the back. <<piecesLabel>> "
    bulk = 2
    shortName = 'torso'
}
+Decoration { 'life support;compact;back module'
    "A small box, containing compact filters, pumps, and an air supply. "
}

enviroPants: EnviroSuitPart, FakeZippable { 'envirosuit bottoms;enviro environment suit pair[n] of[prep];bottom trousers pants leggings piece part'
    "Thick, insulated pants, sealed for protection of the wearer. <<piecesLabel>> "
    bulk = 2
    plural = true
    ambiguouslyPlural = true
    qualified = true
    shortName = 'bottoms'
}

enviroLeftGlove: EnviroSuitPart { 'envirosuit left glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left glove'
}

enviroRightGlove: EnviroSuitPart { 'envirosuit right glove;enviro environment suit;mitten mit mitt piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right glove'
}

enviroLeftBoot: EnviroSuitPart { 'envirosuit left boot;enviro environment suit;shoe piece part'
    "A protective glove for the left hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'left boot'
}

enviroRightBoot: EnviroSuitPart { 'envirosuit right boot;enviro environment suit;shoe piece part'
    "A protective glove for the right hand, modified to fit longer fingers. <<piecesLabel>> "
    bulk = 1
    shortName = 'right boot'
}
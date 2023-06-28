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

modify Thing {
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

    okayOpenMsg = (canZipMe ?
        'Unzipped. |{I} unzip{s/?ed} <<gActionListStr>>. ' :
        'Opened. |{I} open{s/ed} <<gActionListStr>>. '
    )
    okayClosedMsg = (canZipMe ?
        'Zipped. |{I} zip{s/?ed} up <<gActionListStr>>. ' :
        'Done. |{I} close{s/d} <<gActionListStr>>. '
    )

    dobjFor(Zip) {
        preCond = [touchObj]
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
        preCond = [touchObj]
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

    dobjFor(Close) {
        report() {
            say(okayClosedMsg);
        }
    }
}
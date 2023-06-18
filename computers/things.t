TerminalComputer template 'deviceName';
class TerminalComputer: Thing {
    currentDock = nil

    // A score that makes it more likely to type on this.
    // Can be from 0 to 15
    valueBiasScore = 0

    vocab = handheldVocab

    desktopVocab = 'desktop terminal;docked;screen computer laptop <<deviceName>>'
    handheldVocab = 'tablet terminal;smart handheld;screen computer tablet <<deviceName>>'

    desc = "A rectangular touch screen computer.<<if !gCatMode>>
    The device's name seems to be <q><tt><<deviceName>></tt></q><<end>> "

    isReadable = true

    preinitThing() {
        inherited();
        fileSystem = new TerminalFileSystem();
        fileSystem.homeTerminal = self;
        fileSystem.addFolder('downloads');
        fileSystem.addFolder('users');
        fileSystem.addFolder('home');
        fileSystem.traversePath('home', nil).isHome = true;
        currentFolder = fileSystem;
    }

    takeFocus() {
        libGlobal.lastTypedOnObj = self;
    }

    dock(dockObj) {
        currentDock = dockObj;
        replaceVocab(desktopVocab);
        isListed = nil;
        fileSystem.add(currentDock.fileSystem);
        takeFocus();
    }

    undock() {
        if (currentDock != nil) {
            fileSystem.remove(currentDock.fileSystem);
            currentDock.unmountTerminal();
            currentDock = nil;
            replaceVocab(handheldVocab);
            isListed = true;
            currentFolder = fileSystem;
        }
        takeFocus();
    }

    dobjFor(PutIn) {
        report() {
            if (!gIobj.ofKind(TerminalDock)) {
                inherited();
            }
        }
    }

    dobjFor(Take) {
        action() {
            undock();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            undock();
            inherited();
        }
    }

    getNearestDockFor(actor) {
        local scope = Q.scopeList(actor);
        for (local i = 1; i <= scope.length; i++) {
            local item = scope[i];
            if (!actor.canReach(item)) continue;
            if (!item.ofKind(TerminalDock)) continue;
            return item;
        }
        return nil;
    }

    dobjFor(PlugIn) {
        verify() {
            if (getNearestDockFor(gActor) == nil) {
                inaccessible('{I} cannot find a terminal dock to plug that into. ');
            }
        }
        check() { }
        action() {
            nestedAction(PutIn, self, getNearestDockFor(gActor));
        }
        report() { }
    }
    dobjFor(Dock) asDobjFor(PlugIn)
    dobjFor(PlugInto) asDobjFor(PutIn)
    dobjFor(Unplug) asDobjFor(Take)
    dobjFor(UnplugFrom) asDobjFor(TakeFrom)

    catNotTechnoMsg = '{I} do not waste my time on such peasant devices. '
    technoHelpMsg =
        'If {i} want to use this terminal, {i} should type something specific into it.
        Perhaps a sensible starting point is to <<formatCommand('type help', shortCmd)>>. '

    dobjFor(SwitchOn) asDobjFor(LogInto)
    dobjFor(SwitchOff) asDobjFor(LogInto)
    dobjFor(SwitchVague) asDobjFor(LogInto)
    dobjFor(LogInto) {
        preCond = [touchObj]
        verify() {
            if (gCatMode) {
                inaccessible(catNotTechnoMsg);
                return;
            }
            takeFocus();
            illogical(technoHelpMsg);
        }
    }

    canTypeOnMe = true

    dobjFor(TypeOnVague) {
        verify() {
            if (gCatMode) {
                inaccessible(catNotTechnoMsg);
                return;
            }
            takeFocus();
            illogical(technoHelpMsg);
        }
    }
    dobjFor(EnterOn) asDobjFor(TypeOn)
    dobjFor(TypeOn) {
        verify() {
            if (gCatMode) {
                inaccessible(catNotTechnoMsg);
                return;
            }
            inherited();
        }
        action() {
            local commandRoot = gLiteral;
            local pa = gAction.parentAction;

            // In case the literal didn't carry over, our parent action might have it
            if (pa != nil && commandRoot == nil) {
                if (pa.ofKind(Type)) {
                    commandRoot = pa.literal;
                }
            }

            handleCommand(filterCommand(commandRoot));
        }
        report() {
            printCommand();
        }
    }
}

TerminalDock template @location;
class TerminalDock: Thing {
    vocab = unmountedVocab
    desc =
    "A dock for a terminal to plug into.
    In addition to onboard storage and security keys,
    it also offers a comfortable keyboard. "

    mountedVocab = 'terminal dock;computer[weak] laptop[weak];tower'
    unmountedVocab = 'empty terminal dock;computer[weak] laptop[weak];tower'

    contType = In
    isFixed = true
    isListed = true
    enclosing = nil
    isTransparent = true

    currentTerminal = nil

    fileSystem = nil

    specialDesc() {
        if (currentTerminal == nil) {
            "A terminal dock sits empty <<stagingLocation.objInPrep>> <<stagingLocation.theName>>. ";
        }
        else {
            "A terminal sits in its dock <<stagingLocation.objInPrep>> <<stagingLocation.theName>>. ";
        }
    }

    preinitDock() {
        fileSystem = new TerminalFolder();
        fileSystem.name = 'dock';

        local possibleTerminal = nil;
        for (local i = 1; i <= contents.length; i++) {
            local item = contents[i];
            if (item.ofKind(TerminalComputer)) {
                possibleTerminal = item;
                break;
            }
        }
        
        if (possibleTerminal != nil) {
            mountTerminal(possibleTerminal);
            possibleTerminal.dock(self);
        }
    }

    iobjFor(PutIn) {
        verify() {
            if (!gVerifyDobj.ofKind(TerminalComputer)) {
                local obj = gVerifyDobj;
                gMessageParams(obj);
                illogicalSelf('{That subj obj} {is} not something {i} can plug into the dock. ');
            }
            else if (currentTerminal != nil) {
                illogicalSelf('There is already a terminal plugged into the dock. ');
            }
            inherited();
        }
        action() {
            inherited();
            mountTerminal(gDobj);
            gDobj.dock(self);
        }
        report() {
            "{I} plug the terminal into the dock <<stagingLocation.objInPrep>> <<stagingLocation.theName>>. ";
        }
    }

    iobjFor(PlugInto) asIobjFor(PutIn)
    iobjFor(PutOn) asIobjFor(PutIn)
    iobjFor(UnplugFrom) asIobjFor(TakeFrom)

    mountTerminal(terminalObj) {
        currentTerminal = terminalObj;
        replaceVocab(mountedVocab);
    }

    unmountTerminal() {
        currentTerminal = nil;
        replaceVocab(unmountedVocab);
    }

    dobjFor(SwitchOn) asDobjFor(LogInto)
    dobjFor(SwitchOff) asDobjFor(LogInto)
    dobjFor(SwitchVague) asDobjFor(LogInto)
    dobjFor(LogInto) {
        remap = (currentTerminal)
    }
}

class DockKeyboard: Fixture {
    vocab = 'keyboard;dock terminal computer table attachable;keys key'
    desc =
    "A computer keyboard, attached to a terminal dock.
    When a terminal is docked, this keyboard serves as a superior typing surface. "

    cannotTakeMsg = 'The keyboard is permanently attached to the dock. '

    myDock = nil

    dobjFor(EnterOn) {
        remap = (myDock.currentTerminal)
    }

    dobjFor(TypeOn) {
        remap = (myDock.currentTerminal)
    }

    dobjFor(TypeOnVague) {
        remap = (myDock.currentTerminal)
    }
}

computerLinker: PreinitObject {
    execBeforeMe = [distributedComponentDistributor]

    execute() {
        for (local cur = firstObj(TerminalDock);
            cur != nil ; cur = nextObj(cur, TerminalDock)) {
            cur.preinitDock();
            local keyboard = DockKeyboard.createInstance();
            keyboard.myDock = cur;
            keyboard.location = cur.location;
            keyboard.preinitThing();
        }
        for (local cur = firstObj(TerminalFileSystemElement);
            cur != nil ; cur = nextObj(cur, TerminalFileSystemElement)) {
            cur.preinitElement();
        }
    }
}
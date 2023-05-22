VerbRule(Dock)
    'dock' singleDobj  
    : VerbProduction
    action = Dock
    verbPhrase = 'dock/docking (what)'
    missingQ = 'what do you want to dock'
;

DefineTAction(Dock)
;

VerbRule(LogInto)
    ('log' ('in'|'into') | 'login' ('to'|)) singleDobj  
    : VerbProduction
    action = LogInto
    verbPhrase = 'log/logging in to (what)'
    missingQ = 'what do you want to log in to'
;

DefineTAction(LogInto)
;

modify VerbRule(TypeOn)
    'type' ('on'|'in'|'into') singleDobj :
;

modify VerbRule(TypeLiteralOn)
    'type' ('in'|) literalDobj 'on' singleIobj |
    'type' literalDobj ('in'|'into') singleIobj :
;

modify VerbRule(TypeLiteralOnWhat)
    [badness 500] 'type' ('in'|) literalDobj :
;

modify Type
    execAction(cmd) {
        local scope = Q.scopeList(gActor);
        for (local i = 1; i <= scope.length; i++) {
            local item = scope[i];
            if (!gActor.canReach(item)) continue;
            if (!item.ofKind(TerminalComputer)) continue;
            extraReport('<.p>(typing on <<item.theName>>...)<.p>');
            nestedAction(TypeOn, item, gLiteral);
            return;
        }
        askForIobj(TypeOn);
    }
;

modify Thing {
    dobjFor(Dock) {
        verify() {
            illogical('{That subj dobj} {is} not something {i} can dock. ');
        }
    }

    dobjFor(LogInto) {
        verify() {
            illogical('{That subj dobj} {is} not something {i} can log into. ');
        }
    }
}

class TerminalFileSystemElement: object {
    location = nil
    name = 'untitled'
    accessibleName = (name)

    getPathString() {
        if (location != nil) {
            local parentPathString = location.getPathString();
            local divider = '/';
            if (parentPathString.endsWith('/')) divider = '';
            return parentPathString + divider + name;
        }
        return '/' + name;
    }

    getRedirect() {
        return self;
    }

    needsAdding(element) {
        return nil;
    }

    getMainDestination(terminal) {
        return terminal.fileSystem;
    }

    preinitElement() {
        name = name.findReplace('.', '$');
        if (location == nil) return;

        if (location.ofKind(TerminalComputer)) {
            location = getMainDestination(location);
        }
        else if (location.ofKind(TerminalDock)) {
            location = location.fileSystem;
        }

        local pathSteps = breakPath(name);
        if (pathSteps.length > 1) {
            location = location.traverseVector(pathSteps, nil);
        }

        // Path invalid
        if (location == nil) return;
        // Duplicate file
        if (pathSteps.length == 0) return;

        name = pathSteps[1];

        if (location.needsAdding(self)) {
            "\bAdded <<name>> to <<location.name>>\b";
            location.add(self);
        }
        else {
            "\b<<name>> not needed in <<location.name>>\b";
        }
    }

    breakPath(pathStr) {
        if (pathStr.startsWith('/')) {
            // We are not worrying about the root directory,
            // but I might still accidentally add it.
            pathStr = pathStr.substr(2);
        }
        return new Vector(pathStr.split('/'));
    }

    traverseVector(vec, isFile) {
        return self;
    }
}

// Necessary quirk... files use "$" instead of "."
// For example: test$txt
TerminalFile template 'name' 'contents';
class TerminalFile: TerminalFileSystemElement {
    isUserFile = nil
    contents = 'The file appears to be empty.'
}

UserFile template 'name' @userFolder;
class UserFile: TerminalFile {
    isUserFile = true
    userFolder = nil
    contents =
        'This is a user credentials file for the
        username <q><<userFolder.username>></q>.
        Login is possible if {i} <<gDirectCmdStr('type login ' + name)>>.'

    getMainDestination(terminal) {
        return terminal.fileSystem.traversePath('users', nil);
    }
}

TerminalFolder template 'name';
class TerminalFolder: TerminalFileSystemElement {
    contents = perInstance(new Vector())
    isHome = nil

    getRedirect() {
        if (isHome) {
            local fs = self;
            while (fs.location != nil) {
                fs = fs.location;
            }
            if (fs.ofKind(TerminalFileSystem)) {
                local user = fs.currentUser;
                if (user != nil) return user;
            }
        }

        return self;
    }

    needsAdding(element) {
        return (contents.indexOf(element) == nil);
    }

    add(element) {
        if (contents.indexOf(element) == nil) {
            contents.append(element);
            element.location = self;
            contents.sort(nil, { a, b: a.name.compareTo(b.name) });
        }
    }

    remove(element) {
        local index = contents.indexOf(element);
        if (index != nil) {
            contents.removeElementAt(index);
            element.location = nil;
        }
    }

    addFolder(folderName) {
        if (namePresent(folderName)) return;

        local folder = new TerminalFolder();
        folder.name = folderName;
        add(folder);
    }

    namePresent(elementName) {
        for (local i = 1; i <= contents.length; i++) {
            if (contents[i].name == elementName) {
                return true;
            }
        }
        return nil;
    }

    getElementByName(elementName) {
        for (local i = 1; i <= contents.length; i++) {
            if (contents[i].name == elementName) {
                return contents[i];
            }
        }
        return nil;
    }

    traversePath(pathStr, isFile) {
        return traverseVector(breakPath(pathStr), isFile);
    }

    traverseVector(vec, isFile) {
        if (vec.length == 0) {
            return getRedirect(); // Found
        }

        if (vec.length == 1) {
            local searchName = vec[1];
            if (searchName == '$$') {
                return location.getRedirect();
            }
            else if (isFile) {
                // Locate the file
                for (local i = 1; i <= contents.length; i++) {
                    local item = contents[i];
                    if (item.ofKind(TerminalFolder)) continue;
                    local frontName = item.name.split('$')[1];
                    if ((item.name != searchName) && (frontName != searchName)) continue;
                    vec.removeElementAt(1);
                    return item;
                }
            }
            else if (!namePresent(searchName)) {
                return getRedirect(); // Might be a new element
            }
        }

        local nextName = vec[1];

        // Check for full-stop jumps
        local jump = self;
        while ((nextName == '$' || nextName == '$$') && vec.length > 0) {
            vec.removeElementAt(1);
            if (nextName == '$$') {
                if (jump.location != nil) {
                    jump = location;
                }
            }
            if (vec.length > 0) nextName = vec[1];
        }

        if (vec.length == 0) {
            return jump.getRedirect(); // Found
        }

        if (jump != self) {
            return jump.traverseVector(vec, isFile);
        }

        // No full-stop jumps

        for (local i = 1; i <= contents.length; i++) {
            local item = contents[i];
            if (item.name == nextName) {
                vec.removeElementAt(1);
                return item.traverseVector(vec, isFile);
            }
        }

        // No valid path
        return nil;
    }
}

class TerminalFileSystem: TerminalFolder {
    currentUser = nil
    name = '/'
    accessibleName = 'root'

    /*needsAdding(element) {
        return nil;
    }*/

    getPathString() {
        return name;
    }
}

TerminalUserFolder template 'username';
class TerminalUserFolder: TerminalFileSystem {
    currentUser = (self)
    lastTerminalAccessed = nil
    name = 'home'
    username = 'anonymous'

    location = (
        lastTerminalAccessed == nil ?
        nil :
        lastTerminalAccessed.fileSystem
    )

    getPathString() {
        return '/' + name;
    }
}

TerminalComputer template 'deviceName';
class TerminalComputer: Thing {
    vocab = handheldVocab

    desktopVocab = 'desktop terminal;docked;screen computer laptop'
    handheldVocab = 'tablet terminal;smart handheld;screen computer tablet'

    contType = On

    currentDock = nil

    maxScreenItems = 6
    screenBuffer = perInstance(new Vector())
    lastBufferTurn = -1
    isReadable = true

    // The home folder will be associated with a user.
    // To enter a home folder, a user must be logged in.
    // Users can log in through $user files.
    // When entering the home folder while logged in,
    // the terminal will redirect to the user's home folder
    // on the network.
    // The "add <user>" command will add the $user file to
    // the "users" folder, allowing the player to collect and
    // swap between users on one device.
    deviceName = 'anonDev'
    fileSystem = nil
    currentFolder = nil
    currentUser = (fileSystem.currentUser)

    addToScreenBuffer(content, cutoff?) {
        // Make sure it's not blank
        if (content == nil) return;
        local contentStr = toString(content);
        local afterTrim = contentStr.trim();
        if (afterTrim == '' || afterTrim == nil) return;

        wasRead = nil;

        if (lastBufferTurn >= gTurns && screenBuffer.length > 0 && !cutoff) {
            lastBufferTurn = gTurns;
            local oldContent = screenBuffer[screenBuffer.length];
            screenBuffer[screenBuffer.length] = oldContent + contentStr;
            return;
        }

        while (screenBuffer.length >= maxScreenItems) {
            screenBuffer.removeElementAt(1);
        }
        screenBuffer.append(contentStr);
        lastBufferTurn = gTurns;
        if (cutoff) lastBufferTurn--;
    }

    readDesc() {
        if (screenBuffer.length == 0) {
            "The screen is empty. ";
            return;
        }

        "The screen displays the following:\b";
        printScreen();
    }

    printScreen() {
        say('<tt>');
        for (local i = 1; i <= screenBuffer.length; i++) {
            say('\n' + screenBuffer[i]);
        }
        say('</tt>');
        wasRead = true;
    }

    preinitThing() {
        inherited();
        fileSystem = new TerminalFileSystem();
        fileSystem.addFolder('downloads');
        fileSystem.addFolder('users');
        fileSystem.addFolder('home');
        fileSystem.traversePath('home', nil).isHome = true;
        currentFolder = fileSystem;
    }

    dock(dockObj) {
        currentDock = dockObj;
        replaceVocab(desktopVocab);
        isListed = nil;
        fileSystem.add(currentDock.fileSystem);
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
        Perhaps a sensible starting point is to <<gDirectCmdStr('type help')>>. '

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

    filterCommand(cmdObj) {
        local filteredCommand = toString(cmdObj).trim();
        if (gFormatForScreenReader) {
            filteredCommand = filteredCommand.toUpper();
        }
        else {
            filteredCommand = filteredCommand.toLower();
        }
        return filteredCommand.findReplace('&', '&amp;').findReplace('<', '&lt;').findReplace('>', '&gt;');
    }

    refreshUserConnection() {
        if (currentUser != nil) {
            currentUser.lastTerminalAccessed = self;
        }
    }

    getUsername() {
        if (currentUser == nil) return 'offline';
        return currentUser.username;
    }

    formatCommandPrefix() {
        if (gFormatForScreenReader) {
            return
                'Command from username <q><<getUsername()>></q>,
                from device name <q><<deviceName>></q>.\n
                Command executed in <q><<currentFolder.accessibleName>></q> directory.
                Command was the following:\n';
        }
        return '<b><<getUsername()>>@<<deviceName>></b>:<b><<currentFolder.getPathString()>> &gt;</b> ';
    }

    printCommand() {
        """
        <.p>{I} type the following:\b
        <tt><<screenBuffer[screenBuffer.length - 1]>></tt>\b
        The screen reads:\b
        <tt><<screenBuffer[screenBuffer.length]>></tt>
        """;
        wasRead = true;
    }

    handleCommand(cmdStr) {
        refreshUserConnection();
        addToScreenBuffer(formatCommandPrefix() + cmdStr, true);
        local args = cmdStr.split(' ', 2);
        local cmd = args[1];
        local arg = '';
        if (args.length > 1) arg = args[2].trim();
        local takeArg = (arg != '');
        local chosenCommand = nil;

        for (local i = 1; i <= terminalCommandLocker.list.length; i++) {
            local item = terminalCommandLocker.list[i];
            if (item.takesArg != takeArg) continue;
            if (!item.matches(cmd)) continue;
            chosenCommand = item;
            break;
        }

        if (chosenCommand == nil) {
            addToScreenBuffer(
                'ERROR! Unrecognized command: <q><<cmd>></q>\n
                Type in <q><b>help</b></q> for a list of commands, or
                <q><b>help&nbsp;&lt;command&gt;</b></q> to learn about a specific
                command.'
            );
            return;
        }

        chosenCommand.exec(self, arg);
        refreshUserConnection();
    }

    printElementLocationError(isFile) {
        addToScreenBuffer('ERROR! <<isFile ? 'File' : 'Directory'>> not found.');
    }

    locateElement(path, isFile?, skipError?) {
        local startFolder = currentFolder;
        if (path.startsWith('/')) {
            startFolder = fileSystem;
            path = path.substr(2);
        }
        local dest = startFolder.traversePath(path, isFile);

        if (dest == nil) {
            if (!skipError) printElementLocationError(isFile);
            return nil;
        }

        if (dest.ofKind(TerminalFolder)) {
            if (isFile) {
                if (!skipError) printElementLocationError(isFile);
                return nil;
            }
            currentFolder = dest;
            return dest;
        }

        if (isFile) {
            currentFolder = dest.location;
            return dest;
        }

        if (!skipError) printElementLocationError(isFile);
        return nil;
    }
}

class TerminalCommand: object {
    keyword = 'cmd'
    aliases = []
    takesArg = nil
    argName = 'nil'
    helpText = 'Good luck.'

    exec(terminal, arg?) {
        //
    }

    matches(cmdStr) {
        if (cmdStr == keyword) return true;
        return aliases.indexOf(cmdStr);
    }
}

tcmd_ls: TerminalCommand {
    keyword = 'ls'
    aliases = ['list']
    helpText =
        'Lists the contents of the current directory.\b
        Folders are listed using <q><b>name</b></q> notation,
        while files are listed using <q>name$type</q> notation.'

    exec(terminal, arg?) {
        local fileCount = 0;
        local folderCount = 0;

        for (local i = 1; i <= terminal.currentFolder.contents.length; i++) {
            local item = terminal.currentFolder.contents[i];
            if (item.ofKind(TerminalFolder)) {
                folderCount++;
            }
            else {
                fileCount++;
            }
        }

        if (folderCount > 0) {
            if (gFormatForScreenReader) {
                terminal.addToScreenBuffer(
                    'Current directory contains the following subdirectories:'
                );
            }
            for (local i = 1; i <= terminal.currentFolder.contents.length; i++) {
                local item = terminal.currentFolder.contents[i];
                if (item.ofKind(TerminalFolder)) {
                    if (gFormatForScreenReader) {
                        terminal.addToScreenBuffer(
                            '\n\t' + item.accessibleName
                        );
                    }
                    else {
                        terminal.addToScreenBuffer(
                            '\n\t<b>' + item.name + '</b>'
                        );
                    }
                }
            }
        }

        if (fileCount > 0) {
            if (gFormatForScreenReader) {
                terminal.addToScreenBuffer(
                    'Current directory contains the following files:'
                );
            }
            for (local i = 1; i <= terminal.currentFolder.contents.length; i++) {
                local item = terminal.currentFolder.contents[i];
                if (!item.ofKind(TerminalFolder)) {
                    terminal.addToScreenBuffer(
                        '\n\t' + item.name
                    );
                }
            }
        }

        if (folderCount == 0 && fileCount == 0) {
            terminal.addToScreenBuffer(
                'Current directory is empty.'
            );
        }
    }
}

tcmd_path: TerminalCommand {
    keyword = 'path'
    aliases = ['$']
    helpText =
        'Prints the current directory path.'

    exec(terminal, arg?) {
        if (gFormatForScreenReader) {
            local folder = terminal.currentFolder;
            local res = 'Current directory is ' + folder.accessibleName;
            while (folder.location != nil) {
                folder = folder.location;
                res += ', which is in ' + folder.accessibleName;
            }
            terminal.addToScreenBuffer(res);
            return;
        }
        terminal.addToScreenBuffer(terminal.currentFolder.getPathString());
    }
}

tcmd_cd: TerminalCommand {
    keyword = 'cd'
    aliases = ['dir']
    takesArg = true
    argName = ['directory', 'path/to/directory']
    helpText =
        'Changes the current directory.\b
        The <q>$$</q> symbol indicates the containing directory
        (also known as <q>up one level</q>).'

    exec(terminal, arg?) {
        local dest = terminal.locateElement(arg);
        if (dest == nil) return;

        report(terminal);
    }

    report(terminal) {
        if (!gFormatForScreenReader) terminal.addToScreenBuffer('<b>');
        tcmd_path.exec(terminal);
        if (!gFormatForScreenReader) terminal.addToScreenBuffer(' ...</b>\n');
        tcmd_ls.exec(terminal);
    }
}

tcmd_helpPlain: TerminalCommand {
    keyword = 'help'
    aliases = ['?']
    helpText =
        'Shows a list of commands.'

    exec(terminal, arg?) {
        local res =
            'Use <b>help &lt;command&gt;</b> to see how a command is used.\b
            <b>Available commands are the following:</b>';
        for (local i = 1; i <= terminalCommandLocker.list.length; i++) {
            local item = terminalCommandLocker.list[i];
            res += '\n\t' + item.keyword;
            if (item.takesArg) {
                res += ' &lt;' + valToList(item.argName)[1] + '&gt;';
            }
        }
        terminal.addToScreenBuffer(res);
    }
}

tcmd_helpCommand: TerminalCommand {
    keyword = 'help'
    aliases = ['?']
    takesArg = true
    argName = ['command']
    helpText =
        'Shows how to use a specific command.'

    exec(terminal, arg?) {
        local selectedCommands = [];
        for (local i = 1; i <= terminalCommandLocker.list.length; i++) {
            local item = terminalCommandLocker.list[i];
            if (item.matches(arg)) {
                selectedCommands += item;
            }
        }
        if (selectedCommands.length == 0) {
            terminal.addToScreenBuffer(
                'Unrecognized command: <q><<arg>></q>'
            );
            return;
        }
        for (local i = 1; i <= selectedCommands.length; i++) {
            local item = selectedCommands[i];
            if (i > 1) terminal.addToScreenBuffer('\b');
            local argNames = valToList(item.argName);
            for (local j = 1; j <= argNames.length; j++) {
                terminal.addToScreenBuffer(
                    '\n(main)&nbsp;<b>&gt; <<item.keyword>> &lt;<<argNames[j]>>&gt;</b>'
                );
            }
            for (local j = 1; j <= item.aliases.length; j++) {
                terminal.addToScreenBuffer(
                    '\n(alt)&nbsp;&nbsp;<b>&gt; <<item.aliases[j]>> &lt;<<argNames[1]>>&gt;</b>'
                );
            }
            terminal.addToScreenBuffer('\n' + item.helpText);
        }
    }
}

tcmd_read: TerminalCommand {
    keyword = 'read'
    aliases = ['cat', 'nano', 'show']
    takesArg = true
    argName = 'file$type'
    helpText =
        'Shows the contents of a file.'

    exec(terminal, arg?) {
        local oldFolder = terminal.currentFolder;
        local dest = terminal.locateElement(arg, true);
        if (dest == nil) return;

        handle(terminal, dest, oldFolder);
    }

    handle(terminal, dest, oldFolder) {
        if (terminal.currentFolder != oldFolder) {
            if (!gFormatForScreenReader) terminal.addToScreenBuffer('<b>');
            tcmd_path.exec(terminal);
            if (!gFormatForScreenReader) terminal.addToScreenBuffer(
                '/' + dest.name + '</b>\n'
            );
        }
        if (gFormatForScreenReader) {
            terminal.addToScreenBuffer(
                'The contents of ' + dest.accessibleName + ' are the following...\n'
            );
        }
        else {
            terminal.addToScreenBuffer(
                'The contents of ' + dest.name + ' are the following...\n'
            );
        }
        terminal.addToScreenBuffer('\b' + dest.contents);
    }
}

tcmd_login: TerminalCommand {
    keyword = 'login'
    aliases = ['ssh', 'user']
    takesArg = true
    argName = 'name$user'
    helpText =
        'Gains access to a user\'s home folder on the network.'

    exec(terminal, arg?) {
        local oldFolder = terminal.currentFolder;
        local dest = terminal.locateElement(arg, true);
        if (dest == nil) return;

        if (terminal.currentFolder != oldFolder) {
            if (!gFormatForScreenReader) terminal.addToScreenBuffer('<b>');
            tcmd_path.exec(terminal);
            if (!gFormatForScreenReader) terminal.addToScreenBuffer(
                '/' + dest.name + '</b>\n'
            );
        }
        if (dest.isUserFile) {
            terminal.fileSystem.currentUser = dest.userFolder;
            terminal.currentFolder = dest.userFolder;
            dest.userFolder.lastTerminalAccessed = terminal;
            terminal.addToScreenBuffer(
                'Logging in as ' + dest.userFolder.username + '... Done.'
            );
            local usersFolder = terminal.fileSystem.traversePath('users', nil);
            if (!usersFolder.namePresent(dest.name)) {
                terminal.addToScreenBuffer(
                    '\nDownloading credentials... Done.'
                );
                local copyUser = new UserFile();
                copyUser.userFolder = dest.userFolder;
                copyUser.name = dest.name;
                usersFolder.add(copyUser);
            }
            terminal.addToScreenBuffer('\b');
            tcmd_path.exec(terminal);
            tcmd_ls.exec(terminal);
        }
        else {
            terminal.addToScreenBuffer(
                'ERROR! File does not contain user credentials!'
            );
        }
    }
}

tcmd_logout: TerminalCommand {
    keyword = 'logout'
    aliases = []
    helpText =
        'Logs out of the current network user.'

    exec(terminal, arg?) {
        if (terminal.fileSystem.currentUser == nil) {
            terminal.addToScreenBuffer(
                'ERROR! Not logged into network!'
            );
            return;
        }
        terminal.fileSystem.currentUser = nil;
        terminal.currentFolder = terminal.fileSystem;
        terminal.addToScreenBuffer(
            'Logging out... Done.'
        );
        tcmd_ls.exec(terminal);
    }
}

tcmd_open: TerminalCommand {
    keyword = 'open'
    aliases = []
    takesArg = true
    argName = ['file$type', 'directory']
    helpText =
        'A shorthand command that either reads a
        file, or changes directory.'

    exec(terminal, arg?) {
        local oldFolder = terminal.currentFolder;
        local foundFolder = terminal.locateElement(arg, nil, true);
        local foundFile = terminal.locateElement(arg, true, true);

        local focus = foundFile;
        if (focus == nil) focus = foundFolder;

        if (focus == nil) terminal.printElementLocationError(true);

        if (focus.ofKind(TerminalFolder)) {
            tcmd_cd.report(terminal);
        }
        else {
            tcmd_read.handle(terminal, focus, oldFolder);
        }
    }
}

terminalCommandLocker: object {
    list = static new Vector([
        tcmd_cd,
        tcmd_helpPlain,
        tcmd_helpCommand,
        tcmd_login,
        tcmd_logout,
        tcmd_ls,
        tcmd_open,
        tcmd_path,
        tcmd_read
    ])
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
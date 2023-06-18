modify TerminalComputer {
    maxScreenItems = 6
    screenBuffer = perInstance(new Vector())
    lastBufferTurn = -1

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

    filterCommand(cmdObj) {
        local filteredCommand = toString(cmdObj).trim();
        if (gFormatForScreenReader) {
            filteredCommand = filteredCommand.toUpper();
        }
        else {
            filteredCommand = filteredCommand.toLower();
        }
        return filteredCommand.htmlify();
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
                from device named <q><<deviceName>></q>.\n
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
                <<formatCommand('Type help')>> for a list of commands, or
                <<formatCommand('type help : command name')>> to learn about a specific
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
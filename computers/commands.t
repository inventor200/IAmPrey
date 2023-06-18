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
        local encryptedCount = 0;

        for (local i = 1; i <= terminal.currentFolder.contents.length; i++) {
            local item = terminal.currentFolder.contents[i];
            if (item.isEncrypted()) {
                encryptedCount++;
            }
            else if (item.ofKind(TerminalFolder)) {
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
                if (item.isEncrypted()) continue;
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
                if (item.isEncrypted()) continue;
                if (!item.ofKind(TerminalFolder)) {
                    terminal.addToScreenBuffer(
                        '\n\t' + item.name
                    );
                }
            }
        } 

        if (encryptedCount > 0) {
            terminal.addToScreenBuffer(
                '\nCurrent directory contains ' +
                encryptedCount +
                ' encrypted <<encryptedCount == 1 ? 'entry' : 'entries'>>.'
            );
        }

        if (folderCount == 0 && fileCount == 0 && encryptedCount == 0) {
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
            '\^' + formatTheCommand('type help : command name') +
            ' to see how a command is used.\b
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
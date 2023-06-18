#ifdef __DEBUG
#define __DEBUG_TERMINALS nil
#else
#define __DEBUG_TERMINALS nil
#endif

class TerminalFileSystemElement: object {
    location = nil
    name = 'untitled'
    accessibleName = (name)

    getHomeTerminal() {
        local cur = self;
        while (cur.location != nil) {
            cur = cur.location;
        }
        if (cur.ofKind(TerminalFileSystem)) {
            return cur.homeTerminal;
        }
        return nil;
    }

    isEncrypted() {
        return nil;
    }

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
        if (isEncrypted()) return nil;
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
            #if __DEBUG_TERMINALS
            "\bAdded <<name>> to <<location.name>>\b";
            #endif
            location.add(self);
        }
        #if __DEBUG_TERMINALS
        else {
            "\b<<name>> not needed in <<location.name>>\b";
        }
        #endif
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
        if (isEncrypted()) return nil;
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
        Login is possible if {i} <<formatCommand('type login ' + name, longCmd)>>.'

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

        if (isEncrypted()) return nil;

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
        if (isEncrypted()) {
            clearVector(vec);
            return nil;
        }

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
                    if (item.isEncrypted()) {
                        return nil;
                    }
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
    homeTerminal = nil

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
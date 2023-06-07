formatTitle(str) {
    if (gFormatForScreenReader) {
        return
            '<.p>\^' +
            str.toLower() +
            '.<.p>';
    }
    return
        '<.p><center><b><tt>' +
        str.toUpper().findReplace('&NBSP;', '&nbsp;') +
        '</tt></b></center><.p>';
}

formatAlert(str) {
    if (gFormatForScreenReader) {
        return
            '<.p>\^' +
            str.toLower() +
            '<.p>';
    }
    return
        '<.p><b><tt>' +
        str +
        '</tt></b><.p>';
}

commandFormatter: object {
    frontEnd =
        (transScreenReader.encapVec[transScreenReader.encapVecIndexPreference]
        .frontEnd)
    backEnd =
        (transScreenReader.encapVec[transScreenReader.encapVecIndexPreference]
        .backEnd)

    _longFormat(str, tooLong) {
        local comStr = str.toUpper();
        if (!tooLong && !gFormatForScreenReader) {
            comStr = comStr.findReplace('&NBSP;', '&nbsp;').findReplace(' ', '&nbsp;');
        }
        return comStr;
    }

    _encapsulate(str, fr, bk, encapComma) {
        local ecstr = (encapComma ? ', ' : ' ');
        return fr + ecstr + str + ecstr + bk;
    }

    _screenReaderFormat(str, definiteName) {
        if (!gFormatForScreenReader || definiteName) return str;
        return _encapsulate(str, frontEnd, backEnd, transScreenReader.encapPreferCommas);
    }

    _simpleCommand(str, commandEnum, definiteName) {
        local parts = str.split(':', 2);
        str = parts[1].trim();
        local arg = '';
        if (parts.length > 1) {
            arg = '&nbsp;' + formatCommandArg(parts[2].trim());
        }

        local tooLong;
        local isFake;

        switch (commandEnum) {
            default:
            case shortFakeCmd:
                tooLong = nil;
                isFake = true;
                break;
            case shortCmd:
                tooLong = nil;
                isFake = nil;
                break;
            case longFakeCmd:
                tooLong = true;
                isFake = true;
                break;
            case longCmd:
                tooLong = true;
                isFake = nil;
                break;
        }

        local baseRes = _longFormat(str, tooLong);
        local res = baseRes + arg;

        if (gFormatForScreenReader) {
            return _screenReaderFormat(res, definiteName);
        }

        local isClickable = !isFake && !gFormatForScreenReader && outputManager.htmlMode;

        local styledRes = '<b><u>' + baseRes + '</u></b>' + arg;

        if (isClickable) {
            res = aHrefAlt(
                str.toLower(),
                baseRes,
                styledRes
            );

            return res;
        }

        return styledRes;
    }
}

enum shortCmd, longCmd, shortFakeCmd, longFakeCmd;

formatCommand(str, commandEnum?) {
    return commandFormatter._simpleCommand(str, commandEnum, nil);
}

formatTheCommand(str, commandEnum?) {
    return 'the ' + commandFormatter._simpleCommand(str, commandEnum, true) + ' command';
}

formatCommandArg(str) {
    return '<i>(' + str.toLower().findReplace(' ', '&nbsp;') + ')</i>';
}

titleCommand(str) {
    str = commandFormatter._longFormat(str, nil);
    if (gFormatForScreenReader) {
        return commandFormatter._screenReaderFormat(str, nil);
    }
    return '<u>' + str + '</u>';
}

theTitleCommand(str) {
    str = commandFormatter._longFormat(str, nil);
    if (gFormatForScreenReader) {
        str = commandFormatter._screenReaderFormat(str, true);
    }
    else {
        str = '<u>' + str + '</u>';
    }
    return 'the ' + str + ' command';
}

formatInput(str) {
    if (gFormatForScreenReader) {
        return '<i>' + str.toLower().findReplace(' ', '&nbsp;') + '</i>';
    }
    return '<i>&gt;' + str.toLower().findReplace(' ', '&nbsp;') + '</i>';
}

abbr(str) {
    return '<tt><b><u>' + str.toUpper().findReplace('&NBSP;', '&nbsp;') + '</u></b></tt>';
}

getStandardBulletPoint() {
    if (gFormatForScreenReader) return 'Bullet point. ';
    return '<b><tt>[&gt;&gt;]</tt></b>';
}

createOrderedList(items) {
    local lst = valToList(items);
    local strBfr = new StringBuffer(lst.length * 5);

    for (local i = 1; i <= lst.length; i++) {
        createListItem(strBfr, '<b><tt>' + toString(i) + '.</tt></b>', lst[i]);
    }

    return '<.p>' + toString(strBfr) + '<.p>';
}

createUnorderedList(items) {
    local lst = valToList(items);
    local strBfr = new StringBuffer(lst.length * 5);

    for (local i = 1; i <= lst.length; i++) {
        createListItem(strBfr, getStandardBulletPoint(), lst[i]);
    }

    return '<.p>' + toString(strBfr) + '<.p>';
}

createFlowingList(items, conj?) {
    local lst = valToList(items);
    local strBfr = new StringBuffer(lst.length * 5);

    if (conj == nil) conj = 'or';

    if (gFormatForScreenReader) {
        strBfr.append('\^');
    }

    for (local i = 1; i <= lst.length; i++) {
        if (gFormatForScreenReader) {
            strBfr.append(toString(lst[i]));
            if (lst.length > 2 && i < lst.length) {
                strBfr.append(', ');
            }
            if (i == lst.length - 1) {
                strBfr.append(' ');
                strBfr.append(conj);
                strBfr.append(' ');
            }
        }
        else {
            createBasicListItem(
                strBfr, getStandardBulletPoint(),
                '\^' + toString(lst[i])
            );
        }
    }

    if (gFormatForScreenReader) {
        strBfr.append('.');
    }

    return '<.p>' + toString(strBfr) + '<.p>';
}

createListItem(strBfr, marker, str) {
    local markerStr = toString(marker);
    if (gFormatForScreenReader) {
        strBfr.append(markerStr);
        strBfr.append(' ');
        strBfr.append(toString(str));
        strBfr.append('<.p>');
    }
    else {
        createBasicListItem(strBfr, markerStr, toString(str));
    }
}

createBasicListItem(strBfr, markerStr, str) {
    strBfr.append('\t');
    strBfr.append(markerStr);
    strBfr.append(' ');
    strBfr.append(str);
    strBfr.append('\n');
}

freeAction() {
    if (gFormatForScreenReader) return 'free action';
    return '<b><i>FREE</i> action</b>';
}

freeActions() {
    if (gFormatForScreenReader) return 'free actions';
    return '<b><i>FREE</i> actions</b>';
}

waitForPlayer() {
    "\b";
    if (transScreenReader.includeWaitForPlayerPrompt) {
        if (gFormatForScreenReader) {
            "<.p>Press any key to continue.<.p>";
        }
        else {
            "<.p><center><b><tt>Press any key to continue...</tt></b></center><.p>";
        }
    }
    inputManager.pauseForMore();
    "\b";
}

formatRemember() {
    "<<formatAlert('Remember:')>>"; 
}

formatNote() {
    "<<formatAlert('Note:')>>"; 
}

formatWarning() {
    "<<formatAlert('Warning!')>>"; 
}

class InstructionsChapter: Cutscene {
    name = 'Untitled Chapter'
    indented = nil

    play() {
        say(formatTitle(name));
        local len = script.length;
        for (local i = 1; i <= len; i++) {
            "<.p>";
            if (gFormatForScreenReader) {
                "<b><tt>(page <<i>> of <<len>>)</tt></b><.p>";
            }
            script[i].page();
            if (!gFormatForScreenReader) {
                "<.p><b><tt>(pg <<i>> of <<len>>)</tt></b>\n";
            }
            if (i >= len) {
                instructionsCore.offerNavigation(self);
            }
            else {
                waitForPlayer();
            }
        }
    }
}

class InstructionsPage: object {
    page() { }
}

instructionsCore: object {
    chapters = static new Vector([
        newPlayerChapter,
        shorthandChapter,
        travelChapter,
        inventoryChapter,
        turnsAndUndoChapter,
        utilityCommandsChapter,
        experiencedWarningChapter,
        suitPartsChapter,
        lifeOfPreyChapter,
        parkourEvasionChapter,
        mapChapter,
        screenReaderChapter,
        missingContinueChapter,
        catModeChapter,
        autoSneakChapter,
        nightmareModeChapter,
        awarenessChapter,
        doorsChapter,
        tricksChapter,
        chasesChapter,
        exitControlChapter,
        verbsChapter
    ])
    isOpen = nil

    offerNavigation(srcChapter) {
        isOpen = true;
        local index = chapters.indexOf(srcChapter);
        local navChoice = new ChoiceGiver(
            'This chapter has concluded.',
            'Where would you like to go next?'
        );
        local choiceMap = [];
        if (index > 1) {
            choiceMap += 1;
            navChoice.add('P', 'Go to previous chapter', chapters[index - 1].name);
        }
        if (index < chapters.length) {
            choiceMap += 2;
            navChoice.add('N', 'Go to next chapter', chapters[index + 1].name);
        }
        choiceMap += 3;
        navChoice.add('T', 'Go to the table of contents');
        choiceMap += 4;
        navChoice.add('Q', 'Return to the game');
        local choice = choiceMap[navChoice.ask()];

        say('\b\b\b');

        if (choice == 1) {
            chapters[index - 1].play();
        }
        else if (choice == 2) {
            chapters[index + 1].play();
        }
        else if (choice == 3) {
            openTableOfContents();
        }
        else {
            returnToGame();
        }
    }

    openTableOfContents() {
        if (!isOpen) say('\b\b\b');
        isOpen = true;
        say(formatTitle('Table of Contents'));
        local chapterChoice = new ChoiceGiver(
            'Please choose a chapter to review.'
        );
        for (local i = 1; i <= chapters.length; i++) {
            local chapter = chapters[i];
            local chapterName = chapter.name;
            if (chapter.indented && !gFormatForScreenReader) {
                chapterName =
                    '<tt>&nbsp;&nbsp;&nbsp;&nbsp;</tt>' + chapterName;
            }
            chapterChoice.add(toString(i), chapterName);
        }
        chapterChoice.add('Q', 'Return to the game');

        local chapterSel = chapterChoice.ask();
        if (chapterSel > chapters.length) {
            returnToGame();
        }
        else {
            chapters[chapterSel].play();
        }
    }

    returnToGame() {
        isOpen = nil;
        //say('\b\b\b');
        gPlayerChar.getOutermostRoom().lookAroundWithin();
    }

    showVerbs() {
        if (!isOpen) say('\b\b\b');
        isOpen = true;
        verbsChapter.play();
    }
}
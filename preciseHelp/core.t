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
                inputManager.pauseForMore();
            }
        }
    }

    formatTitle(str) {
        if (gFormatForScreenReader) {
            return
                '<.p>' +
                str +
                '<.p>';
        }
        return
            '<.p><center><b><tt>' +
            str.toUpper().findReplace('&NBSP;', '&nbsp;') +
            '</tt></b></center><.p>';
    }

    formatCommand(str) {
        return '<b><u>' +
            str.toUpper().findReplace('&NBSP;', '&nbsp;').findReplace(' ', '&nbsp;') +
            '</u></b>';
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

    createOrderedList(items) {
        local lst = valToList(items);
        local strBfr = new StringBuffer(lst.length * 5);

        for (local i = 1; i <= lst.length; i++) {
            createListItem(strBfr, toString(i) + '.', lst[i]);
        }

        return '<.p>' + toString(strBfr) + '<.p>';
    }

    createUnorderedList(items) {
        local lst = valToList(items);
        local strBfr = new StringBuffer(lst.length * 5);

        for (local i = 1; i <= lst.length; i++) {
            createListItem(strBfr, '&bull;', lst[i]);
        }

        return '<.p>' + toString(strBfr) + '<.p>';
    }

    createListItem(strBfr, marker, str) {
        if (gFormatForScreenReader) {
            strBfr.append(toString(marker));
            strBfr.append(' ');
            strBfr.append(toString(str));
            strBfr.append('<.p>');
        }
        else {
            strBfr.append('\t');
            strBfr.append(toString(marker));
            strBfr.append(' ');
            strBfr.append(toString(str));
            strBfr.append('\n');
        }
    }

    freeAction() {
        return '<b><i>FREE</i> action</b>';
    }

    freeActions() {
        return '<b><i>FREE</i> actions</b>';
    }
}

class InstructionsPage: object {
    page() { }

    // Shortcuts
    formatTitle(str) { return InstructionsChapter.formatTitle(str); }
    formatCommand(str) { return InstructionsChapter.formatCommand(str); }
    formatInput(str) { return InstructionsChapter.formatInput(str); }
    abbr(str) { return InstructionsChapter.abbr(str); }
    createOrderedList(items) { return InstructionsChapter.createOrderedList(items); }
    createUnorderedList(items) { return InstructionsChapter.createUnorderedList(items); }
    freeAction() { return InstructionsChapter.freeAction(); }
    freeActions() { return InstructionsChapter.freeActions(); }
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
        say(InstructionsChapter.formatTitle('Table of Contents'));
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
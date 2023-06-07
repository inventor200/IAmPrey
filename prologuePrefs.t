#include <file.h>

// We save everything in plain text, in case the player wants to
// manually edit their preferences.

class BasePreference: object {
    construct(_name, _isHidden, _stateProp, _stateStoringObject, _prefProp, _prefStortingObject) {
        name = _name;
        isHidden = _isHidden;
        stateProp = _stateProp;
        stateStoringObject = _stateStoringObject;
        prefProp = _prefProp;
        if (_prefStortingObject == nil) {
            prefStortingObject = stateStoringObject;
        }
        else {
            prefStortingObject = _prefStortingObject;
        }
    }

    name = 'Untitled preference'
    isHidden = nil
    stateStoringObject = nil
    stateProp = nil
    prefStortingObject = nil
    prefProp = nil

    readState() {
        return stateStoringObject.(stateProp);
    }

    writeState(state) {
        stateStoringObject.(stateProp) = state;
    }

    hasPreference() {
        return prefStortingObject.(prefProp);
    }

    claimPreference() {
        prefStortingObject.(prefProp) = true;
    }

    process(statement) {
        //claimPreference();
        //writeState(nil);
        return nil;
    }

    getFileString() {
        return '';
    }

    getFileOptionString() {
        return '';
    }
}

class BooleanPreference: BasePreference {
    construct(_name, _isHidden, _positiveStr, _negativeStr, _stateProp, _stateStoringObject, _prefProp, _prefStortingObject?) {
        positiveStr = _positiveStr;
        negativeStr = _negativeStr;
        inherited(_name, _isHidden, _stateProp, _stateStoringObject, _prefProp, _prefStortingObject);
    }

    positiveStr = 'player prefers this option'
    negativeStr = 'player prefers no option'

    process(statement) {
        if (statement == positiveStr) {
            claimPreference();
            writeState(true);
            #if __DEBUG_PREFS
            "\tPositive: <<positiveStr>>\n
            \tConfirmed: <<readState() ? 'true' : 'nil'>>\n";
            #endif
            return true;
        }
        if (statement == negativeStr) {
            claimPreference();
            writeState(nil);
            #if __DEBUG_PREFS
            "\tNegative: <<negativeStr>>\n
            \tConfirmed: <<readState() ? 'true' : 'nil'>>\n";
            #endif
            return true;
        }
        return nil;
    }

    getFileString() {
        local actual = negativeStr;
        local inverse = positiveStr;
        if (readState()) {
            actual = positiveStr;
            inverse = negativeStr;
        }
        return '#\n#     ' + name + '\n' +
            actual + ';\n#     Opposite option:\n#' +
            inverse;
    }

    getFileOptionString() {
        return '#\n#     Unused yes/no option:\n' +
            '#' + positiveStr + ';\n#' + negativeStr + ';\n';
    }
}

class ValuePreference: BasePreference {
    construct(_name, _isHidden, _header, _stateProp, _stateStoringObject, _prefProp, _negativeBool, _prefStortingObject) {
        header = _header;
        negativeBool = _negativeBool;
        inherited(_name, _isHidden, _stateProp, _stateStoringObject, _prefProp, _prefStortingObject);
    }

    header = 'player prefers version '
    valueFromFile = nil
    negativeBool = nil

    processValueFromFile() {
        return valueFromFile;
    }

    convertToFileValue(state) {
        return nil;
    }

    readState() {
        return stateStoringObject.(stateProp);
    }

    process(statement) {
        if (negativeBool != nil) {
            if (statement == negativeBool.negativeStr) {
                negativeBool.process(nil);
                return true;
            }
        }
        local len = header.length;
        if (statement.length <= len) return nil;
        if (!statement.startsWith(header)) return nil;
        claimPreference();
        negativeBool.writeState(true);
        valueFromFile = statement.substr(len);
        local processedVal = processValueFromFile();
        writeState(processedVal);
        #if __DEBUG_PREFS
        "\tValued: <<header + valueFromFile>> -&gt; <<processedVal>>\n
        \tConfirmed: <<readState()>>\n";
        #endif
        return true;
    }

    getFileString() {
        if (negativeBool != nil) {
            #if __DEBUG_PREFS
            "\nChecking negative bool...\n";
            #endif
            if (!negativeBool.readState()) {
                #if __DEBUG_PREFS
                "\tIt's negative.\n";
                #endif
                return negativeBool.negativeStr;
            }
        }
        valueFromFile = convertToFileValue(readState());
        #if __DEBUG_PREFS
        "Processed value: <<valueFromFile>>\n";
        #endif
        return '#\n#     ' + name + '\n' +
            header + valueFromFile;
    }
}

class IntegerPreference: ValuePreference {
    construct(_name, _isHidden, _minVal, _maxVal, _defaultVal, _header, _stateProp, _stateStoringObject, _prefProp, _negativeBool?, _prefStortingObject?) {
        minVal = _minVal;
        maxVal = _maxVal;
        defaultVal = _defaultVal;
        inherited(_name, _isHidden, _header, _stateProp, _stateStoringObject, _prefProp, _negativeBool, _prefStortingObject);
    }

    minVal = 0
    maxVal = 100
    defaultVal = 50

    processValueFromFile() {
        local possible = tryInt(valueFromFile);
        if (possible == nil) return defaultVal;
        if (possible < minVal) possible = minVal;
        if (possible > maxVal) possible = maxVal;
        return possible;
    }

    convertToFileValue(state) {
        return toString(state);
    }

    getFileOptionString() {
        return '#\n#     Unused integer option:\n' +
            '#' + header + toString(defaultVal) + '\n'+
            '# Number can be between ' + minVal + ' and ' + maxVal + '\n';
    }
}

class EnumPreference: ValuePreference {
    construct(_name, _isHidden, _srcList, _defaultVal, _header, _stateProp, _stateStoringObject, _prefProp, _negativeBool?, _prefStortingObject?) {
        defaultVal = _defaultVal;
        srcList = valToList(_srcList);
        inherited(_name, _isHidden, _header, _stateProp, _stateStoringObject, _prefProp, _negativeBool, _prefStortingObject);
    }

    defaultVal = 1
    srcList = []

    processValueFromFile() {
        for (local i = 1; i <= srcList.length; i++) {
            if (valueFromFile == getComparableValueFromList(i)) {
                return i;
            }
        }
        return defaultVal;
    }

    convertToFileValue(state) {
        return getComparableValueFromList(state);
    }

    getComparableValueFromList(index) {
        return srcList[index].name;
    }

    getFileOptionString() {
        local res = '#\n#     Unused named option:\n' +
            '# Choices are:\n';
        for (local i = 1; i <= srcList.length; i++) {
            res += '#' + header + convertToFileValue(i) + '\n';
        }
        return res;
    }
}

transient prologuePrefCore: InitObject {
    execAfterMe = [screenReaderInit]

    prefVec = static new Vector([
        new BooleanPreference('Cat prologue preference', nil,
            'player prefers no cat prologue',
            'player prefers cat prologue',
            &playerPrefersNoCatPrologue,
            prologuePrefCore,
            &playerHasCatProloguePreference
        ),
        new BooleanPreference('Prey prologue preference', nil,
            'player prefers no prey prologue',
            'player prefers prey prologue',
            &playerPrefersNoPreyPrologue,
            prologuePrefCore,
            &playerHasPreyProloguePreference
        ),
        new BooleanPreference('Intro preference', nil,
            'player prefers no intro',
            'player prefers intro',
            &playerPrefersNoIntro,
            prologuePrefCore,
            &playerHasIntroPreference
        ),
        new IntegerPreference('Music volume preference', nil,
            0, 100, 50,
            'player prefers music set to ',
            &musicVolume,
            transMusicPlayer,
            &playerGavePreferences,
            new BooleanPreference('Music preference', nil,
                'player prefers music',
                'player prefers no music',
                &playerWantsMusic,
                transMusicPlayer,
                &playerGavePreferences
            )
        ),
        new BooleanPreference('SFX preference', nil,
            'player prefers sfx',
            'player prefers no sfx',
            &playerWantsSFX,
            transMusicPlayer,
            &playerGavePreferences
        ),
        new BooleanPreference('Screen reader preference', nil,
            'player uses screen reader',
            'player does not use screen reader',
            &formatForScreenReader,
            transScreenReader,
            &playerHasScreenReaderPreference
        ),
        new BooleanPreference('Read more preference', nil,
            'player prefers extra read more',
            'player prefers no extra read more',
            &includeWaitForPlayerPrompt,
            transScreenReader,
            &playerHasScreenReaderPreference
        ),
        new EnumPreference('Command encapsulation style preference', nil,
            transScreenReader.encapVec, 2,
            'player prefers encapsulation using ',
            &encapVecIndexPreference,
            transScreenReader,
            &playerHasScreenReaderPreference,
            new BooleanPreference('Command encapsulation preference', nil,
                'player prefers command encapsulation',
                'player prefers no command encapsulation',
                &formatForScreenReader,
                transScreenReader,
                &playerHasScreenReaderPreference
            )
        ),
        new BooleanPreference('Encapsulation comma preference', nil,
            'player prefers commas around commands',
            'player prefers no commas around commands',
            &encapPreferCommas,
            transScreenReader,
            &playerHasScreenReaderPreference
        )
    ])

    playerHasCatProloguePreference = nil
    playerPrefersNoCatPrologue = nil
    skipCatPrologue = (
        playerHasCatProloguePreference &&
        playerPrefersNoCatPrologue
    )

    playerHasPreyProloguePreference = nil
    playerPrefersNoPreyPrologue = nil
    skipPreyPrologue = (
        playerHasPreyProloguePreference &&
        playerPrefersNoPreyPrologue
    )

    playerHasIntroPreference = nil
    playerPrefersNoIntro = nil
    skipIntro = (
        playerHasIntroPreference &&
        playerPrefersNoIntro
    )

    preferencesWereLoaded = nil

    fileName = 'I-Am-Prey-Preferences.cfg'
    
    execute() {
        if (preferencesWereLoaded) return;
        preferencesWereLoaded = true;

        #if __DEBUG_PREFS
        "\b";
        #endif

        try {
            local prefsTextFile = File.openTextFile(fileName, FileAccessRead);

            local preferencesReadOkay = true;
            local lastLine = '';
            local strBfr = new StringBuffer(5);

            do {
                try {
                    lastLine = prefsTextFile.readFile();
                    local trimLine = '';
                    if (lastLine != nil) trimLine = lastLine.trim();
                    if (trimLine.length > 0) {
                        if (!lastLine.trim().startsWith('#')) {
                            strBfr.append(lastLine);
                        }
                    }
                } catch (FileIOException eex1) {
                    preferencesReadOkay = nil;
                    break;
                } catch (FileModeException eex2) {
                    preferencesReadOkay = nil;
                    break;
                }
            } while (lastLine != nil);

            prefsTextFile.closeFile();

            if (preferencesReadOkay) {
                local prefsStatements =
                    toString(strBfr)
                    .toLower()
                    .findReplace(';\n', ';')
                    .findReplace('.\n', ';')
                    .findReplace(',\n', ';')
                    .findReplace('\n', '; ')
                    .findReplace('.', ';')
                    .findReplace(',', ';')
                    .split(';');

                for (local i = 1; i <= prefsStatements.length; i++) {
                    local statement = prefsStatements[i].trim();

                    #if __DEBUG_PREFS
                    "Loading statement:\n\t<<statement>>\n";
                    #endif

                    for (local j = 1; j <= prefVec.length; j++) {
                        local pref = prefVec[j];

                        if (pref.process(statement)) {
                            #if __DEBUG_PREFS
                            "\bChecking: <<pref.name>>\n";
                            #endif
                            #if __DEBUG_PREFS
                            "Found handler.\b";
                            #endif
                            break;
                        }
                    }
                }
            }
        } catch (FileNotFoundException ex1) {
            //
        } catch (FileOpenException ex2) {
            //
        } catch (FileSafetyException ex3) {
            //
        }
    }

    hasWrittenAnything = nil

    writePreference(fl, str) {
        fl.writeFile(str + ';\n');
        hasWrittenAnything = true;
    }

    writePreferences() {
        hasWrittenAnything = nil;
        try {
            local prefsTextFile = File.openTextFile(fileName, FileAccessWrite);

            #if __DEBUG_PREFS
            "\bWriting preferences...\b";
            #endif

            prefsTextFile.writeFile(
                '# Lines starting with a hashtag ("#") are ignored.\n'
            );
            prefsTextFile.writeFile(
                '# Each option sits on its own line,\n'
            );
            prefsTextFile.writeFile(
                '# and ends with a comma, period, or semicolon.\n'
            );

            for (local i = 1; i <= prefVec.length; i++) {
                local pref = prefVec[i];
                
                #if __DEBUG_PREFS
                "\bChecking: <<pref.name>>";
                #endif
                if (pref.hasPreference()) {
                    local fs = pref.getFileString();
                    #if __DEBUG_PREFS
                    "\nWriting preference:\n\t<<fs>>";
                    #endif
                    writePreference(prefsTextFile, fs);
                }
                else if (!pref.isHidden) {
                    prefsTextFile.writeFile(pref.getFileOptionString());
                }
            }

            if (!hasWrittenAnything) {
                writePreference(prefsTextFile, 'player has no preferences');
            }

            #if __DEBUG_PREFS
            "\bWriting complete.\b";
            #endif
            
            prefsTextFile.closeFile();
        } catch (FileNotFoundException ex1) {
            //
        } catch (FileOpenException ex2) {
            //
        } catch (FileSafetyException ex3) {
            //
        }
    }

    remindOfFile() {
        "<<remember>>
        You can always reset your preferences by deleting the
        following file:\n
        <tt><<prologuePrefCore.fileName>></tt>\b
        You can also edit this file directly!\n
        It should be in the same directory as the game file!
        <<wait for player>>";
    }
}

#ifdef __DEBUG
VerbRule(TestDeath)
    'try' 'death'
    : VerbProduction
    action = TestDeath
    verbPhrase = 'test/testing death menu'
;

DefineSystemAction(TestDeath)
    execAction(cmd) {
        finishGameMsgSong(ftDeath, gEndingOptionsLoss);
    }
;
#endif

modify Restart {
    execAction(cmd) {
        local desireRestart = ChoiceGiver.staticAsk(
            'Are you sure you would like to start a new run? '
        );

        if (desireRestart) {
            //handleConfirmedRestart();
            doRestartGame();
        }
    }

    doRestartGame() {
        handleConfirmedRestart();
        musicPlayer.playSong(nil);
        sfxPlayer.setAmbience(nil);
        sfxPlayer.setDecorations(nil);
        PreRestartObject.classExec();
        throw new RestartSignal();
    }

    handleConfirmedRestart() {
        local choiceMade = nil;
        if (!prologuePrefCore.playerHasIntroPreference) {
            prologuePrefCore.playerPrefersNoIntro = ChoiceGiver.staticAsk(
                'Would you like to skip to the difficulty selection, from now on? '
            );

            prologuePrefCore.playerHasIntroPreference = true;
            choiceMade = true;
        }

        if (gCatMode) {
            if (!prologuePrefCore.playerHasCatProloguePreference) {
                prologuePrefCore.playerPrefersNoCatPrologue = ChoiceGiver.staticAsk(
                    'Would you like to skip the cat\'s prologue, from now on? '
                );

                prologuePrefCore.playerHasCatProloguePreference = true;
                choiceMade = true;
            }
        }
        else if (!prologuePrefCore.playerHasPreyProloguePreference) {
            prologuePrefCore.playerPrefersNoPreyPrologue = ChoiceGiver.staticAsk(
                'Would you like to skip Prey\'s prologue, from now on? '
            );

            prologuePrefCore.playerHasPreyProloguePreference = true;
            choiceMade = true;
        }

        prologuePrefCore.writePreferences();
        if (choiceMade) {
            prologuePrefCore.remindOfFile();
        }
    }
}

modify Quit {
    execAction(cmd) {      
        local desireRestart = ChoiceGiver.staticAsk(
            'Are you sure you would like to quit? '
        );

        if (desireRestart) {
            "\b";
            throw new QuittingException;
        }       
    }
}
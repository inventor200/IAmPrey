#include <file.h>

#ifdef __DEBUG
#define __DEBUG_PREFS nil
#else
#define __DEBUG_PREFS nil
#endif

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
        if (prefProp == nil) return true;
        return prefStortingObject.(prefProp);
    }

    claimPreference() {
        if (prefProp == nil) return;
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

    getFileNegativeOptionString() {
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

    getFileNegativeOptionString() {
        if (negativeBool != nil) {
            return '#     To disable:\n#' +
                negativeBool.negativeStr + ';\n';
        }
        return '';
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

class PreferencesModule: object {
    loadOrder = 100

    getPreferences() {
        return nil;
    }

    showWarnings() {
        //
    }

    getGameName() {
        return nil;
    }
}

corePreferences: PreferencesModule {
    loadOrder = 0

    getPreferences() {
        return new Vector([
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
        ]);
    }
}

transient preferencesCore: InitObject {
    execAfterMe = [screenReaderInit]

    prefVec = static new Vector()

    gameName = 'Inventor Game'

    fileName = ((gameName + '-Preferences.cfg').findReplace(' ', '-'))

    preferencesWereLoaded = nil
    
    execute() {
        local preferencesModules = new Vector(16);
        for (local cur = firstObj(PreferencesModule);
            cur != nil ; cur = nextObj(cur, PreferencesModule)) {
            preferencesModules.append(cur);
        }

        preferencesModules.sort(nil, {a, b: a.loadOrder - b.loadOrder});

        for (local i = 1; i <= preferencesModules.length; i++) {
            local module = preferencesModules[i];
            module.showWarnings();
            if (preferencesWereLoaded) continue;
            local loadedPrefs = convertToVector(module.getPreferences());
            dumpVectorAIntoB(loadedPrefs, prefVec);
            local possibleName = module.getGameName();
            if (toString(possibleName).length == 0) continue;
            gameName = possibleName;
        }

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
                    showFailureWarning(true);
                    preferencesReadOkay = nil;
                    break;
                } catch (FileModeException eex2) {
                    showFailureWarning(true);
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
            showFailureWarning(true);
        } catch (FileOpenException ex2) {
            showFailureWarning(true);
        } catch (FileSafetyException ex3) {
            showFailureWarning(true);
        }
    }

    showFailureWarning(wasLoading) {
        """
        <<formatTitle('OOPS!')>>

        Something went wrong <<wasLoading ? 'loading' : 'saving'>>
        your settings and preferences!\b

        If you are using an online interpreter, your browser might not
        be allowing this webpage to save and load local files. The local
        storage allotted to this webpage might also be full.\b

        If you are playing offline, then your interpreter might be
        restricting read/write capabilities for games, or the game
        file's location might have restricted permissions.

        <<wait for player>>
        """;
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
                    prefsTextFile.writeFile(pref.getFileNegativeOptionString());
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
            showFailureWarning(nil);
        } catch (FileOpenException ex2) {
            showFailureWarning(nil);
        } catch (FileSafetyException ex3) {
            showFailureWarning(nil);
        }
    }

    remindOfFile() {
        "<<remember>>
        You can always reset your preferences by deleting the
        following file:\n
        <tt><<preferencesCore.fileName>></tt>\b
        You can also edit this file directly!\n
        <i>(It should be in the same directory as the game file,
        if you are using an offline interpreter!)</i>
        <<wait for player>>";
    }
}
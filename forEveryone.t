/* From the TADS Cookbook: https://github.com/jimbonator/tads-cookbook/blob/main/src/ForEveryone/ForEveryone.t
 *
 * ForEveryone
 * BlindHunter95
 *
 * (Modified for modular use by Joey Cramsey)
 */

screenReaderInit: InitObject {
    execute() {
        if (transScreenReader.playerHasScreenReaderPreference) {
            if (transScreenReader.formatForScreenReader) {
                statusLine.statusDispMode = StatusModeText;
                prepForScreenReaders();
            }
            return;
        }

        transScreenReader.playerHasScreenReaderPreference = true;

        #if __SHOW_PROLOGUE
        if (ChoiceGiver.staticAsk(
            'Are you using a screen reader to play this story?', nil, true
        )) {
            statusLine.statusDispMode = StatusModeText;
            transScreenReader.formatForScreenReader = true;
            prepForScreenReaders();
        }
        #endif
    }

    prepForScreenReaders() {
        // For authors
    }
}

transient transScreenReader: object {
    formatForScreenReader = nil
    playerHasScreenReaderPreference = nil
}
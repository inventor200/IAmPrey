/* From the TADS Cookbook: https://github.com/jimbonator/tads-cookbook/blob/main/src/ForEveryone/ForEveryone.t
 *
 * ForEveryone
 * BlindHunter95
 *
 * (Modified for modular use by Joey Cramsey)
 */

screenReaderInit: InitObject {
    execute() {
        if (ChoiceGiver.staticAsk(
            'Are you using a screen reader to play this story?', nil, true
        )) {
            statusLine.statusDispMode = StatusModeText;
            gFormatForScreenReader = true;
            prepForScreenReaders();
        }
    }

    prepForScreenReaders() {
        // For authors
    }
}
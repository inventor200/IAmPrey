// From the TADS Cookbook: https://github.com/jimbonator/tads-cookbook/blob/main/src/ForEveryone/ForEveryone.t
//
// ForEveryone
// BlindHunter95
//

screenReaderInit: InitObject {
    execute() {
        "\bAre you using a screen reader to play this story? (Yes or no.)\n";
        if(yesOrNo()) {
            prepForScreenReaders();
        }
    }

    prepForScreenReaders() {
        statusLine.statusDispMode = StatusModeText;
    }
}
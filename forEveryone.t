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
        else if (ChoiceGiver.staticAsk(
            'Are you using a screen reader to play this story?', nil, true
        )) {
            statusLine.statusDispMode = StatusModeText;
            transScreenReader.formatForScreenReader = true;
            prepForScreenReaders();
        }

        transScreenReader.playerHasScreenReaderPreference = true;

        if (transScreenReader.formatForScreenReader) {
            """
            Excellent! There are a few more adjustments to make,
            in order to make this game as accessible as possible.\b
            
            Up ahead is a <q>press any key to continue</q> prompt
            or a <q>more</q> prompt. No matter which one appears, it
            should be written after the countdown.\b

            What we want to do is make sure your screen reader is able
            to read it. Again, it should be written after the countdown.\b
            
            Ready? Three. Two. One. Go.
            <<wait for player>>
            Welcome back!
            """;

            if (!ChoiceGiver.staticAsk(
                'Did a prompt to press any key appear after the countdown?'
            )) {
                "Noted!\b
                Some interpreters place this prompt outside of the text window.";

                transScreenReader.includeWaitForPlayerPrompt = ChoiceGiver.staticAsk(
                    'Would you like these prompts to also appear in the text window?'
                );
            }
        }
        else {
            // Nuts to it. Maybe sighted players want an extra prompt, too!
            """
            Excellent!\b

            Now, this <i>might</i> seem silly, but can you see a
            <q><b>press&nbsp;any&nbsp;key&nbsp;to&nbsp;continue</b></q> or
            <q><b><tt>MORE</tt></b></q> prompt below?\b

            It should be right here:
            <<wait for player>>
            Oh, welcome back!\b

            Right... so...
            """;

            local spotted = ChoiceGiver.staticAsk(
                'Did you see a prompt to press any key, or read more?'
            );

            if (!spotted) {
                transScreenReader.includeWaitForPlayerPrompt = ChoiceGiver.staticAsk(
                    'Would you like one...?'
                );
            }

            """
            Great! Thanks for letting me know!
            <<wait for player>>
            """;
        }

        if (transScreenReader.formatForScreenReader) {
            "Okay! Two more screen reader adjustments to go!";
            local encapsulationChoice = new ChoiceGiver(
                'What kind of encapsulation do you want for commands?',
                'Some commands blend into the sentence, so you can choose a
                phrase that is read aloud before and after a command, to
                make its presence more apparent.'
            );

            for (local i = 1; i <= transScreenReader.encapVec.length; i++) {
                local capObj = transScreenReader.encapVec[i];
                encapsulationChoice.add(toString(i), capObj.name,
                    'This example sentence explains that you can
                    <<commandFormatter._encapsulate(
                        'turn on the sink', capObj.frontEnd, capObj.backEnd, true
                    )>>
                    in the bathroom. You can also use the jump command.'
                );
            }

            transScreenReader.encapVecIndexPreference = encapsulationChoice.ask();

            local capObj =
                transScreenReader.encapVec[transScreenReader.encapVecIndexPreference];

            """
            Okay, here's a sentence with an encapsulated command,
            which uses commas:\b

            This example suggests that you <<commandFormatter._encapsulate(
                'close the door', capObj.frontEnd, capObj.backEnd, true)>>.\b

            What follows is the same encapsulation example, but
            without the commas:\b

            This example suggests that you <<commandFormatter._encapsulate(
                'close the door', capObj.frontEnd, capObj.backEnd, nil)>>.\b
            """;

            transScreenReader.encapPreferCommas = ChoiceGiver.staticAsk(
                'Would you like to keep using commas when
                commands are encapsulated?'
            );
        }
        prologuePrefCore.writePreferences();
    }

    prepForScreenReaders() {
        // For authors
    }
}

class CommandEncapsulator: object {
    name = ''
    frontEnd = ''
    backEnd = ''
}

starsEncap: CommandEncapsulator {
    name = 'stars'
    frontEnd = 'star'
    backEnd = 'star'
}

capEncap: CommandEncapsulator {
    name = 'caps'
    frontEnd = 'caps'
    backEnd = 'caps'
}

quoteEncap: CommandEncapsulator {
    name = 'quote and unquote'
    frontEnd = 'quote'
    backEnd = 'unquote'
}

phraseEncap: CommandEncapsulator {
    name = 'phrase and end phrase'
    frontEnd = 'phrase'
    backEnd = 'end phrase'
}

transient transScreenReader: object {
    formatForScreenReader = nil
    playerHasScreenReaderPreference = nil
    includeWaitForPlayerPrompt = nil
    encapVecIndexPreference = 2
    encapPreferCommas = true

    encapVec = static new Vector([
        starsEncap,
        capEncap,
        quoteEncap,
        phraseEncap
    ])
}
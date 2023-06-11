class ChoiceGiver: object {
    construct(question_, context_?, beforeScreenReaderCertainty_?) {
        question = question_;
        context = context_;
        beforeScreenReaderCertainty = beforeScreenReaderCertainty_;
        choices = new Vector();
    }

    choices = nil
    question = 'Would you like to choose?'
    context = nil
    beforeScreenReaderCertainty = nil

    add(abbreviation, choiceStr, context?) {
        if (context != nil) {
            context = context.trim();
        }
        choices.append([
            abbreviation.trim().toUpper(),
            choiceStr.trim(),
            context
        ]);
    }

    showAskPrompt() {
        if (formatForScreenReader) {
            say('<.p><b>Type in your choice here:</b> ');
        }
        else {
            say('<.p>&gt;&nbsp;');
        }
        local response = inputManager.getInputLine(nil);
        say('&nbsp;<.p>');
        return response.trim().toUpper();
    }

    ask() {
        if (choices.length == 0) return nil;
        if (choices.length == 1) {
            return 1;
        }

        say('<.p><b><tt>');
        say(question);
        say('</tt></b>');
        if (context != nil) {
            if (context.length > 0) {
                say('\n');
                say(context);
            }
        }

        local formatForScreenReader =
            (beforeScreenReaderCertainty || gFormatForScreenReader);

        if (formatForScreenReader) {
            say('<.p>(The choices are');
        }
        else {
            say('\n');
        }

        local hasContext = nil;

        for (local i = 1; i <= choices.length; i++) {
            local choice = choices[i];
            local abbreviation = choice[1];
            local text = choice[2];
            local context = choice[3];
            if (context != nil) {
                if (context.length == 0) {
                    context = nil;
                }
            }

            if (context != nil) hasContext = true;

            if (formatForScreenReader) {
                say('\n<b>');
                say(abbreviation);
                say('</b> for <q>');
                say(text);
                say('</q>');
                if (i < choices.length) {
                    say(', ');
                    if (i == choices.length - 1) {
                        say('or ');
                    }
                }
                else {
                    say('.');
                }
            }
            else {
                say('\t<b><tt>');
                if (outputManager.htmlMode) {
                    say('<FONT COLOR="#888888">');
                }
                say(abbreviation);
                say('</tt></b> = ');
                if (outputManager.htmlMode) {
                    say('</FONT>');
                }
                say(aHrefAlt(
                    abbreviation,
                    text,
                    '<b>' + text + '</b>'
                ));
                if (context != nil) {
                    say('\n');
                    say(context);
                    say('\b');
                }
                else if (hasContext) {
                    say('\b');
                }
                else {
                    say('\n');
                }
            }
        }

        if (formatForScreenReader) {
            say(')');
        }
        else {
            say('\n');
        }

        if (hasContext && formatForScreenReader) {
            for (local i = 1; i <= choices.length; i++) {
                local choice = choices[i];
                local text = choice[2];
                local context = choice[3];
                if (context != nil) {
                    if (context.length == 0) {
                        context = nil;
                    }
                }

                if (context != nil) {
                    say('<.p><b>The description for <q>');
                    say(text);
                    say('</q> is:</b><.p>');
                    say(context);
                }
            }
        }

        local lastChoice = nil;
        local lastChoiceLength = 0;

        do {
            lastChoice = nil;
            local reduced = showAskPrompt();
            for (local i = 1; i <= choices.length; i++) {
                local choice = choices[i];
                local abbreviation = choice[1];
                if (reduced.left(abbreviation.length) == abbreviation) {
                    if (abbreviation.length >= lastChoiceLength) {
                        lastChoice = i;
                        lastChoiceLength = abbreviation.length;
                    }
                }
            }

            if (lastChoice != nil) return lastChoice;

            say('\bInvalid choice.');
        } while(lastChoice == nil);

        return nil;
    }

    staticAsk(question_, context_?, beforeScreenReaderCertainty_?) {
        local question = new ChoiceGiver(
            question_, context_, beforeScreenReaderCertainty_
        );
        question.add('y', 'Yes');
        question.add('n', 'No');
        local result = question.ask();
        return result == 1;
    }
}
VerbRule(Dock)
    'dock' singleDobj  
    : VerbProduction
    action = Dock
    verbPhrase = 'dock/docking (what)'
    missingQ = 'what do you want to dock'
;

DefineTAction(Dock)
;

VerbRule(LogInto)
    ('log' ('in'|'into') | 'login' ('to'|)) singleDobj  
    : VerbProduction
    action = LogInto
    verbPhrase = 'log/logging in to (what)'
    missingQ = 'what do you want to log in to'
;

DefineTAction(LogInto)
;

VerbRule(ShowTerminals)
    ('show'|'list'|) 'terminals' 
    : VerbProduction
    action = ShowTerminals
    verbPhrase = 'list/listing terminals'
;

DefineIAction(ShowTerminals)
    execAction(cmd) {
        local scope = Q.scopeList(gActor);
        local terminalsFound = nil;
        for (local i = 1; i <= scope.length; i++) {
            local item = scope[i];
            if (!gActor.canReach(item)) continue;
            if (!item.ofKind(TerminalComputer)) continue;
            terminalsFound = true;
            "A terminal with a device name of <q><tt><<item.deviceName>></tt></q>
            <<if item.currentDock != nil>>sits in a dock,
            <<item.currentDock.stagingLocation.objInPrep>>
            <<item.currentDock.stagingLocation.theName>><<else
            >>is <<item.stagingLocation.objInPrep>>
            <<item.stagingLocation.theName>><<end>>.\n";
        }
        if (!terminalsFound) {
            "{I} cannot seem to find any nearby terminals. ";
        }
    }
;

modify VerbRule(TypeOn)
    'type' ('on'|'in'|'into') singleDobj :
;

modify VerbRule(TypeLiteralOn)
    'type' ('in'|) literalDobj 'on' singleIobj |
    'type' literalDobj ('in'|'into') singleIobj :
;

modify VerbRule(TypeLiteralOnWhat)
    [badness 500] 'type' ('in'|) literalDobj :
;

modify Type
    execAction(cmd) {
        local scope = Q.scopeList(gActor);
        local terminalsInScope = new Vector(4);
        for (local i = 1; i <= scope.length; i++) {
            local item = scope[i];
            if (!gActor.canReach(item)) continue;
            if (!item.ofKind(TerminalComputer)) continue;
            terminalsInScope.append(item);
        }
        if (terminalsInScope.length > 0) {
            if (terminalsInScope.length > 1) {
                terminalsInScope.sort(true, {a, b:
                    scoreForTerminal(a) - scoreForTerminal(b)
                });
            }
            local chosen = terminalsInScope[1];
            extraReport('<.p>');
            extraReport(
                '(typing on device named <q><tt><<chosen.deviceName>></tt></q>...)'
            );
            if (terminalsInScope.length > 1) {
                extraReport(
                    '\n<small><i>(Wrong terminal? Use
                    <<formatTheCommand('terminals', shortCmd)>>
                    to find the name of another terminal.)</i></small>'
                );
            }
            extraReport('<.p>');
            nestedAction(TypeOn, chosen, gLiteral);
            return;
        }
        askForIobj(TypeOn);
    }

    scoreForTerminal(item) {
        if (item == libGlobal.lastTypedOnObj) {
            return 32 + item.valueBiasScore;
        }
        if (item.isIn(gActor)) {
            return 16 + item.valueBiasScore;
        }
        return item.valueBiasScore;
    }
;

modify Thing {
    cannotDockMsg =
        '{That subj dobj} {is} not something {i} can dock. '
    cannotLogIntoMsg =
        '{That subj dobj} {is} not something {i} can log into. '

    dobjFor(Dock) {
        verify() {
            illogical(cannotDockMsg);
        }
    }

    dobjFor(LogInto) {
        verify() {
            illogical(cannotLogIntoMsg);
        }
    }
}
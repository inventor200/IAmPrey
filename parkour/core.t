//TODO: Tutorial hinting
parkourCore: object {
    requireRouteRecon = true
    formatForScreenReader = (gFormatForScreenReader)
    //autoPathCanDiscover = (!requireRouteRecon)
    autoPathCanDiscover = true
    enforceDirectionality = nil
    announceRouteAfterTrying = true
    maxReconsPerTurn = 3

    doParkourRunnerCheck(actor) {
        if (gMover.fitForParkour) return true;
        sayParkourRunnerError(actor);
        return nil;
    }

    sayParkourRunnerError(actor) {
        if (gMover != actor) {
            say(gMover.cannotDoParkourInMsg);
            return;
        }

        say(actor.cannotDoParkourMsg);
    }

    getKeyString() {
        local strBfr = new StringBuffer(5);
        strBfr.append(formatTitle('Bullet Symbol Key'));
        createBasicListItem(strBfr,
            getBulletPoint(true, true), ' = dangerous jump'
        );
        createBasicListItem(strBfr,
            getBulletPoint(nil, true), ' = dangerous climb'
        );
        createBasicListItem(strBfr,
            getBulletPoint(true, nil), ' = jump'
        );
        createBasicListItem(strBfr,
            getBulletPoint(nil, nil), ' = simple climb'
        );
        return toString(strBfr);
    }

    loadParkourKeyHint(strBfr) {
        strBfr.append('\n');
        strBfr.append(aHrefAlt(
            'show parkour list key',
            '<small>Not sure what the bullet symbols mean?
            Click here!</small> ',
            '(Not sure what the bullet symbols mean?
            Type <<formatCommand('PARKOUR KEY')>> for clarification!) '
        ));
        strBfr.append('<.p>');
    }

    printParkourKey() {
        if (parkourCore.formatForScreenReader) {
            "This command does nothing in screen reader mode.
            Outside of screen reader mode, it clarifies some
            ASCII symbols used when describing routes. ";
        }
        else {
            "<<getKeyString()>>";
        }
    }

    //TODO: Rework this into a hint for using the verb.
    printParkourFullRoutesHint() {
        "(Parkour verb hint will go here) ";
        /*return aHrefAlt(
            'all routes',
            '\n<small>Click here for all known routes!</small><.p>',
            ''
        );*/
    }

    printParkourRoutes() {
        gMoverFrom(gActor);
        local str = gMoverLocation.getRouteListString();
        if (str.length > 0) {
            "<<str>>";
            return;
        }
        "<<noKnownRoutesMsg>>";
    }

    getLocalPlatforms() {
        return gMoverFrom(gActor).getLocalPlatforms();
    }

    printLocalPlatforms() {
        local platList = getLocalPlatforms();
        platList = platList.subset({p: !p.omitFromPrintedLocalsList()});
        if (platList.length == 0) {
            "{I} {see} no known or notable surfaces in easy reach.<.p>";
            return;
        }
        "The following surfaces{plural} {is} either in easy reach,
        or rest{s/ed} on the same surface that {i} {do}:<.p>";
        if (formatForScreenReader) {
            "<<makeListStr(platList, &getPlatformName, 'and')>>";
        }
        else {
            local strBfr = new StringBuffer();
            for (local i = 1; i <= platList.length; i++) {
                local plat = platList[i];
                local platName = plat.getPlatformName();
                strBfr.append('\n\t');
                strBfr.append(aHrefAlt(
                    plat.getLocalPlatformBoardingCommand(),
                    platName,
                    platName
                ));
            }
            say(toString(strBfr));
        }
    }

    //TODO: Find a better way to print this hint
    loadAbbreviationReminder(strBfr) {
        if (hasShownClimbAbbreviationHint) return;
        strBfr.append(
            '<<remember>>
            <i>You can use parkour shorthand to enter commands faster!</i>\b
            <<formatCommand('CLIMB')>> can be shortened to <<abbr('CL')>>, and
            <<formatCommand('JUMP')>> can be shortened to <<abbr('JM')>>!
            <<formatTitle('Examples')>>
            <<formatCommand('CL UP DESK')>> for an <i>explicit</i> climb-up, or just
            <<formatCommand('CL DESK')>> for an <i>implicit</i> climb, which picks the
            most appropriate direction, but only if it was used before.'
        );
        hasShownClimbAbbreviationHint = true;
    }

    implicitPlatform = nil
    theImplicitPlatformName() {
        if (implicitPlatform == nil) return 'a better spot';
        return implicitPlatform.theName;
    }
    lastPath = nil
    showNewRoute = nil
    hadAccident = nil
    hasShownClimbAbbreviationHint = nil
    noKnownRoutesMsg =
        '{I} {do} not {know} of any interesting routes from {here}. '
    
    isParkourPoorlyHandledFor(obj) {
        if (obj.parkourModule == nil && !obj.forcedLocalPlatform) {
            for (local i = 1; i < poorlyHandledActions.length; i++) {
                if (gActionIs(poorlyHandledActions[i])) {
                    return true;
                }
            }
        }
        return nil;
    }

    poorlyHandledActions = [
        Board, Climb, ClimbUp, ClimbDown,
        ParkourClimbUpTo, ParkourClimbOverTo, ParkourClimbDownTo,
        ParkourClimbUpInto, ParkourClimbOverInto, ParkourClimbDownInto,
        ParkourJumpUpTo, ParkourJumpOverTo, ParkourJumpDownTo,
        ParkourJumpUpInto, ParkourJumpOverInto, ParkourJumpDownInto
    ]
}
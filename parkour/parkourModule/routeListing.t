getBulletPoint(requiresJump, isHarmful) {
    if (isHarmful && requiresJump) return '\n\t<tt><b>[!*]</b></tt>';
    if (isHarmful) return '\n\t<tt><b>[!!]</b></tt>';
    if (requiresJump) return '\n\t<tt><b>[**]</b></tt>';
    return '\n\t<tt><b>[&gt;&gt;]</b></tt>';
}

modify ParkourModule {
    getRouteListString() {
        local strBfr = new StringBuffer(20);
        local climbPaths = [];
        local climbHarmfulPaths = [];
        local jumpPaths = [];
        local jumpHarmfulPaths = [];
        local fallPaths = [];
        local providerPaths = [];
        local providerHarmfulPaths = [];
        local describedPaths = [];
        local describedHarmfulPaths = [];

        local blindEasyPaths = [];
        local blindEasyDescribedPaths = [];
        local blindJumpPaths = [];
        local blindJumpDescribedPaths = [];
        local blindHarmfulPaths = [];
        local blindHarmfulDescribedPaths = [];
        local blindHarmfulJumpPaths = [];
        local blindHarmfulJumpDescribedPaths = [];

        local exitPath = nil;
        local currPlat = getStandardOn();
        local outerPlat = currPlat.exitLocation;
        local outerPM = nil;
        if (outerPlat != nil) outerPM = outerPlat.getParkourModule();
        local canSuggestExits = !standardDoNotSuggestGetOff();

        for (local i = 1; i <= pathVector.length; i++) {
            local path = pathVector[i];
            // Do not suggest stupid paths
            if (path.destination.parkourModule == self) continue;

            // Reserve the GET/JUMP OFF path
            if (outerPM != nil) {
                if (path.destination.parkourModule == outerPM) {
                    if (canSuggestExits && exitPath == nil) {
                        exitPath = path;
                    }
                    continue; // Do not add any other exit paths
                }
            }

            // Do not suggest basic climb-on actions
            if (!path.requiresJump && !path.isHarmful) {
                local destPlat = path.destination.getStandardOn();
                if (destPlat.stagingLocation != nil) {
                    if (destPlat.stagingLocation == currPlat) continue;
                }
            }

            // Filter:
            if (path.isKnown) {
                if (path.injectedPathDescription != nil) {
                    if (path.isHarmful) {
                        describedHarmfulPaths += path;
                        if (path.requiresJump) {
                            blindHarmfulJumpDescribedPaths += path;
                        }
                        else {
                            blindHarmfulDescribedPaths += path;
                        }
                    }
                    else {
                        describedPaths += path;
                        if (path.requiresJump) {
                            blindJumpDescribedPaths += path;
                        }
                        else {
                            blindEasyDescribedPaths += path;
                        }
                    }
                }
                else if (path.provider != nil) {
                    if (path.isHarmful) {
                        providerHarmfulPaths += path;
                        if (path.requiresJump) {
                            blindHarmfulJumpPaths += path;
                        }
                        else {
                            blindHarmfulPaths += path;
                        }
                    }
                    else {
                        providerPaths += path;
                        if (path.requiresJump) {
                            blindJumpPaths += path;
                        }
                        else {
                            blindEasyPaths += path;
                        }
                    }
                }
                else if (path.requiresJump) {
                    if (path.isHarmful) {
                        if (path.direction == parkourDownDir) {
                            fallPaths += path;
                        }
                        else {
                            jumpHarmfulPaths += path;
                            blindHarmfulJumpPaths += path;
                        }
                    }
                    else {
                        jumpPaths += path;
                        blindJumpPaths += path;
                    }
                }
                else {
                    if (path.isHarmful) {
                        climbHarmfulPaths += path;
                        blindHarmfulPaths += path;
                    }
                    else {
                        climbPaths += path;
                        blindEasyPaths += path;
                    }
                }
            }
        }

        local totalCount =
            climbPaths.length +
            climbHarmfulPaths.length +
            jumpPaths.length +
            jumpHarmfulPaths.length +
            fallPaths.length +
            providerPaths.length +
            providerHarmfulPaths.length +
            describedPaths.length +
            describedHarmfulPaths.length;
        
        if (exitPath != nil) totalCount++;
        
        if (totalCount > 0) {
            blindEasyPaths += blindEasyDescribedPaths;
            blindJumpPaths += blindJumpDescribedPaths;
            blindHarmfulPaths += blindHarmfulDescribedPaths;
            blindHarmfulJumpPaths += blindHarmfulJumpDescribedPaths;
            local routeCount =
                blindEasyPaths.length +
                blindJumpPaths.length +
                blindHarmfulPaths.length +
                blindHarmfulJumpPaths.length;
            strBfr.append('<i>{I} review{s/ed} the parkour routes {i} {can} use from {here}...</i>');
            if (parkourCore.formatForScreenReader) {
                strBfr.append('<.p>');
                strBfr.append(
                    'In total, {i} {see} <<spellNumber(routeCount)>>
                    viable <<getRouteCase(routeCount)>>.'
                );
                if (exitPath != nil) {
                    loadGetOffSuggestion(
                        strBfr, exitPath.requiresJump, exitPath.isHarmful
                    );
                }
                getBlindRouteDescription(strBfr, blindEasyPaths,
                    'can be performed with ease. '
                );
                getBlindRouteDescription(strBfr, blindJumpPaths,
                    'can be performed with difficulty. '
                );
                getBlindRouteDescription(strBfr, blindHarmfulPaths,
                    'can be performed at the risk of injury. '
                );
                getBlindRouteDescription(strBfr, blindHarmfulJumpPaths,
                    'can be performed with both great difficulty and risk of injury. '
                );
            }
            else {
                parkourCore.loadParkourKeyHint(strBfr);
                climbPaths += climbHarmfulPaths;
                jumpPaths += jumpHarmfulPaths;
                jumpPaths += fallPaths;
                providerPaths += providerHarmfulPaths;
                describedPaths += describedHarmfulPaths;

                if (exitPath != nil) {
                    loadGetOffSuggestion(
                        strBfr, exitPath.requiresJump, exitPath.isHarmful
                    );
                }

                if (climbPaths.length > 0) {
                    strBfr.append('<.p><tt><b>(CL)</b> CLIMB ROUTES:</tt>');
                    for (local i = 1; i <= climbPaths.length; i++) {
                        formatForBulletPoint(strBfr, climbPaths[i]);
                    }
                }

                if (jumpPaths.length > 0) {
                    strBfr.append('<.p><tt><b>(JM)</b> JUMP ROUTES:</tt>');
                    for (local i = 1; i <= jumpPaths.length; i++) {
                        formatForBulletPoint(strBfr, jumpPaths[i]);
                    }
                }

                if (providerPaths.length > 0) {
                    strBfr.append('<.p><tt>COMPLEX ROUTES:</tt>');
                    for (local i = 1; i <= providerPaths.length; i++) {
                        local path = providerPaths[i];
                        local provider = path.provider.getParkourProvider(nil, nil);
                        if (provider == nil) continue;
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        strBfr.append(' ');
                        strBfr.append(getProviderHTML(provider));
                        strBfr.append('\n\t<i>leads to ');
                        strBfr.append(getBetterDestinationName(path.destination.parkourModule));
                        strBfr.append('</i>');
                    }
                }

                if (describedPaths.length > 0) {
                    strBfr.append('<.p><tt>MISC ROUTES:</tt>');
                    for (local i = 1; i <= describedPaths.length; i++) {
                        local path = describedPaths[i];
                        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
                        strBfr.append(' ');
                        if (path.provider == nil) {
                            strBfr.append(getClimbHTML(
                                path, path.injectedPathDescription.toUpper()
                            ));
                        }
                        else {
                            local provider = path.provider.getParkourProvider(nil, nil);
                            strBfr.append(getProviderHTML(
                                provider, path.injectedPathDescription.toUpper()
                            ));
                        }
                    }
                }
            }
        }

        return toString(strBfr);
    }

    getRouteCase(count) {
        if (count == 1) return 'route';
        return 'routes';
    }

    getVerbFromPath(path) {
        if (path.requiresJump) return 'JUMP ';
        return 'CLIMB ';
    }

    getPrepFromPath(path) {
        switch (path.direction) {
            case parkourUpDir:
                return 'up ';
            default:
                return 'over ';
            case parkourDownDir:
                return 'down ';
        }
    }

    getBetterPrepFromPath(path) {
        switch (path.direction) {
            case parkourUpDir:
                return 'atop ';
            default:
                return 'over to ';
            case parkourDownDir:
                return 'down to ';
        }
    }

    formatForBulletPoint(strBfr, path) {
        strBfr.append(getBulletPoint(path.requiresJump, path.isHarmful));
        strBfr.append(' ');
        local destName = path.destination.parkourModule.theName;
        local commandAlt = getBetterPrepFromPath(path) + destName;
        strBfr.append(aHrefAlt(
            getClimbCommand(path).toLower(),
            commandAlt,
            formatCommand(getClimbCommand(path), longFakeCmd)
        ));
    }

    getClimbCommand(path) {
        return getVerbFromPath(path) +
            getBetterPrepFromPath(path) +
            path.destination.parkourModule.theName;
    }

    getClimbHTML(path, commandText?) {
        if (commandText == nil) {
            commandText = getProviderVerb(provider) +
                getPrepFromPath(path) + 'to ' +
                path.destination.parkourModule.theName;
        }
        return aHrefAlt(
            getClimbCommand(path).toLower(),
            commandText,
            formatCommand(commandText, longFakeCmd)
        );
    }

    getProviderCommand(provider) {
        local provName = provider.theName;
        if (provider.canSwingOnMe) return 'swing on ' + provName;
        if (provider.canJumpOverMe) return 'jump over ' + provName;
        if (provider.canRunAcrossMe) return 'run across ' + provName;
        if (provider.canSlideUnderMe) return 'slide under ' + provName;
        if (provider.canSqueezeThroughMe) return 'squeeze through ' + provName;
        return 'cl ' + provName;
    }

    getProviderVerb(provider) {
        local provName = provider.theName.toUpper();
        if (provider.canSwingOnMe) return 'SWING ON ' + provName;
        if (provider.canJumpOverMe) return 'JUMP OVER ' + provName;
        if (provider.canRunAcrossMe) return 'RUN ACROSS ' + provName;
        if (provider.canSlideUnderMe) return 'SLIDE UNDER ' + provName;
        if (provider.canSqueezeThroughMe) return 'SQUEEZE THROUGH ' + provName;
        return 'parkour via ' + provName;
    }

    getProviderHTML(provider, commandText?) {
        if (commandText == nil) {
            commandText = getProviderVerb(provider);
        }
        return aHrefAlt(
            getProviderCommand(provider),
            commandText, formatCommand(commandText, longFakeCmd)
        );
    }

    getBlindRouteDescription(strBfr, routeList, routeSuffix) {
        if (routeList.length > 0) {
            strBfr.append('<.p>');
            for (local i = 1; i <= routeList.length; i++) {
                local path = routeList[i];
                if (path.injectedPathDescription != nil) {
                    strBfr.append('<b>');
                    strBfr.append(path.injectedPathDescription.toUpper());
                    strBfr.append('</b>');
                }
                else if (path.provider == nil) {
                    strBfr.append('<b>');
                    strBfr.append(getVerbFromPath(path));
                    strBfr.append(getBetterPrepFromPath(path).toUpper());
                    strBfr.append(path.destination.parkourModule.theName.toUpper());
                    strBfr.append('</b>');
                }
                else {
                    local provider = path.provider.getParkourProvider(nil, nil);
                    strBfr.append('<b>');
                    strBfr.append(getProviderVerb(provider));
                    strBfr.append('</b>');
                    if (path.injectedPathDescription == nil) {
                        strBfr.append(' <i>(which leads to ');
                        strBfr.append(getBetterDestinationName(path.destination.parkourModule));
                        strBfr.append(')</i>');
                    }
                }
                if (i == routeList.length) {
                    strBfr.append(' ');
                }
                else if (i == routeList.length - 1) {
                    strBfr.append(', and ');
                }
                else {
                    strBfr.append(', ');
                }
            }
            strBfr.append(routeSuffix);
        }
    }
}
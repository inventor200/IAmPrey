// Just some adjustments to the behavior of "X ALL" actions
enum notifDangerous, notifImportant, notifUnexamined;

class AllHeurNotification: object {
    construct(_obj, _reason) {
        obj = _obj;
        reason = _reason;
    }

    obj = nil
    reason = nil
}

allHeurCore: InitObject {
    notifierVec = static new Vector()
    infoDaemon = nil

    enforceExamining = true
    doExamineAfterTake = nil
    enforceCarefulTake = true
    enforceCarefulDrop = true

    execute() {
        infoDaemon = new PromptDaemon(self, &afterTurn);
    }

    afterTurn() {
        if (notifierVec.length > 0) {
            local dangerousLst = [];
            local importantLst = [];
            local unexaminedLst = [];

            for (local i = 1; i <= notifierVec.length; i++) {
                local notif = notifierVec[i];
                switch (notif.reason) {
                    case notifDangerous:
                        dangerousLst += notif.obj;
                        break;
                    case notifImportant:
                        importantLst += notif.obj;
                        break;
                    case notifUnexamined:
                        unexaminedLst += notif.obj;
                        break;
                }
            }

            if (dangerousLst.length + importantLst.length + unexaminedLst.length > 0) {
                local strBfr = new StringBuffer(20);
                strBfr.append('\b');

                if (dangerousLst.length > 0) {
                    appendReasonList(dangerousLst, strBfr, 'create{s/d} handling risks');
                }
                if (importantLst.length > 0) {
                    appendReasonList(importantLst, strBfr, '{is} important to keep in inventory');
                }
                if (unexaminedLst.length > 0) {
                    appendReasonList(unexaminedLst, strBfr, '{have} not been examined');
                }

                say(toString(strBfr));
            }

            notifierVec.removeRange(1, -1);
        }
    }

    appendReasonList(lst, strBfr, reasonStr) {
        strBfr.append('\n(\^');
        strBfr.append(makeListStr(lst, &theName, 'and'));
        strBfr.append('{prev} ');
        strBfr.append(reasonStr);
        strBfr.append(', and {do} not qualify for "ALL".)\n');
    }

    checkNotifiedFor(obj, reason) {
        for (local i = 1; i <= notifierVec.length; i++) {
            if (notifierVec[i].obj == obj) {
                return true;
            }
        }

        notifierVec.append(new AllHeurNotification(obj, reason));

        return nil;
    }
}

modify Thing {
    isDangerousInventory = nil
    isImportantInventory = nil
    isFamiliarInventory = nil

    hideFromAll(action) {
        if (action.skipsCheckAllSafeties) { // Any qualifying actions are guaranteed safe
            return hideFromAllNormally(action);
        }

        if (!action.skipsCheckCarefulTake) {
            if (isDangerousInventory) { // Do not accidentally interact with dangerous things
                if (allHeurCore.enforceCarefulTake) noteDangerous();
                return allHeurCore.enforceCarefulTake;
            }
        }

        if (!action.skipsCheckExamining) {
            if (!(examined || isFamiliarInventory)) { // Do not accidentally interact with unexamined things
                if (allHeurCore.doExamineAfterTake) return nil;

                if (allHeurCore.enforceExamining) noteUnexamined();
                return allHeurCore.enforceExamining;
            }
        }

        if (!action.skipsCheckCarefulDrop) { // Only dump unimportant things
            if (isImportantInventory) {
                if (allHeurCore.enforceCarefulDrop) noteImportant();
                return allHeurCore.enforceCarefulDrop;
            }
        }

        return hideFromAllNormally(action);
    }

    hideFromAllNormally(action) {
        return nil;
    }

    noteDangerous() {
        allHeurCore.checkNotifiedFor(self, notifDangerous);
    }

    noteImportant() {
        allHeurCore.checkNotifiedFor(self, notifImportant);
    }

    noteUnexamined() {
        allHeurCore.checkNotifiedFor(self, notifUnexamined);
    }

    dobjFor(Take) {
        action() {
            inherited();
            if (gActor == gPlayerChar) {
                isFamiliarInventory = true;
                if (allHeurCore.doExamineAfterTake && !examined) {
                    extraReport('({I} {take} {the dobj} and examine{s/d} {him dobj}.)\b');
                    doNested(Examine, self);
                }
            }
        }
    }

    preinitThing() {
        inherited();
        doPlayerHoldingCheck();
    }

    moveInto(loc) {
        inherited(loc);
        doPlayerHoldingCheck();
    }

    doPlayerHoldingCheck() {
        if (isHeldBy(gPlayerChar)) {
            isFamiliarInventory = true;
        }
    }
}

modify Action {
    skipsCheckAllSafeties = nil
    skipsCheckCarefulDrop = (isFinnicky)
    skipsCheckCarefulTake = nil // Never X ALL with something dangerous!!
    skipsCheckExamining = (isFinnicky)
    isFinnicky = nil
}

/*
 * STUFF THAT GATHERS INFO SAFELY
 */

modify Examine {
    skipsCheckAllSafeties = true
}

modify Inventory {
    skipsCheckAllSafeties = true
}

modify ListenTo {
    skipsCheckAllSafeties = true
}

modify Look {
    skipsCheckAllSafeties = true
}

modify LookBehind {
    skipsCheckAllSafeties = true
}

modify LookThrough {
    skipsCheckAllSafeties = true
}

modify LookUnder {
    skipsCheckAllSafeties = true
}

modify LookHere {
    skipsCheckAllSafeties = true
}

modify Read {
    skipsCheckAllSafeties = true
}

modify SmellSomething {
    skipsCheckAllSafeties = true
}

modify TopicTAction {
    skipsCheckAllSafeties = true
}

modify SystemAction {
    skipsCheckAllSafeties = true
}

modify ImplicitConversationAction {
    skipsCheckAllSafeties = true
}

modify MiscConvAction {
    skipsCheckAllSafeties = true
}

modify TravelAction {
    skipsCheckAllSafeties = true
}

/*
 * STUFF THAT IS FINNICKY
 * (Meaning it's harmless enough, and would be infuriating to have checks for)
 */

modify Board {
    isFinnicky = true
}

modify Climb {
    isFinnicky = true
}

modify ClimbDown {
    isFinnicky = true
}

modify ClimbDownVague {
    isFinnicky = true
}

modify ClimbUp {
    isFinnicky = true
}

modify ClimbUpVague {
    isFinnicky = true
}

modify Close {
    isFinnicky = true
}

modify Enter {
    isFinnicky = true
}

modify EnterOn {
    isFinnicky = true
}

modify Extinguish {
    isFinnicky = true
}

modify Flip {
    isFinnicky = true
}

modify Follow {
    isFinnicky = true
}

modify GetOff {
    isFinnicky = true
}

modify GetOutOf {
    isFinnicky = true
}

modify GoThrough {
    isFinnicky = true
}

modify Jump {
    isFinnicky = true
}

modify JumpOff {
    isFinnicky = true
}

modify JumpOffIntransitive {
    isFinnicky = true
}

modify JumpOver {
    isFinnicky = true
}

modify Lie {
    isFinnicky = true
}

modify LieIn {
    isFinnicky = true
}

modify LieOn {
    isFinnicky = true
}

modify Light {
    isFinnicky = true
}

modify Lock {
    isFinnicky = true
}

modify LockWith {
    isFinnicky = true
}

modify Open {
    isFinnicky = true
}

modify Pull {
    isFinnicky = true
}

modify Push {
    isFinnicky = true
}

modify PushTravelClimbDown {
    isFinnicky = true
}

modify PushTravelClimbUp {
    isFinnicky = true
}

modify PushTravelDir {
    isFinnicky = true
}

modify PushTravelEnter {
    isFinnicky = true
}

modify PushTravelGetOutOf {
    isFinnicky = true
}

modify PushTravelThrough {
    isFinnicky = true
}

modify Set {
    isFinnicky = true
}

modify SetTo {
    isFinnicky = true
}

modify Sit {
    isFinnicky = true
}

modify SitIn {
    isFinnicky = true
}

modify SitOn {
    isFinnicky = true
}

modify Stand {
    isFinnicky = true
}

modify StandIn {
    isFinnicky = true
}

modify StandOn {
    isFinnicky = true
}

modify SwitchOff {
    isFinnicky = true
}

modify SwitchOn {
    isFinnicky = true
}

modify SwitchVague {
    isFinnicky = true
}

modify Turn {
    isFinnicky = true
}

modify TurnTo {
    isFinnicky = true
}

modify TurnWith {
    isFinnicky = true
}

modify Type {
    isFinnicky = true
}

modify TypeOn {
    isFinnicky = true
}

modify TypeOnVague {
    isFinnicky = true
}

modify Unlock {
    isFinnicky = true
}

modify UnlockWith {
    isFinnicky = true
}

modify Write {
    isFinnicky = true
}

modify WriteOn {
    isFinnicky = true
}

/*
 * STUFF THAT REQUIRES TAKING
 */

modify Feel {
    skipsCheckCarefulDrop = true
}

modify Remove {
    skipsCheckCarefulDrop = true
}

modify Take {
    skipsCheckCarefulDrop = true
}

modify TakeFrom {
    skipsCheckCarefulDrop = true
}

modify Taste {
    skipsCheckCarefulDrop = true
}

/*
 * STUFF THAT REQUIRES DROPPING
 */

modify Doff {
    skipsCheckExamining = true
}

modify Drop {
    skipsCheckExamining = true
}

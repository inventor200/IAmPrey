/* TRINKETS
 * by Joseph Cramsey
 * 
 * A Thing that can be interacted with, but has limited listing
 * behaviors, and is excluded from _ ALL actions.
 */

modify Thing {
    // Only apply ALL to me if I'm in inventory
    pleaseIgnoreMe = nil
    // Never apply ALL to me
    alwaysHideFromAll = (isDecoration)
    // Only allow EXAMINE ALL for me
    onlyExamineAll = (isDecoration)

    hideFromAll(action) {
        if (alwaysHideFromAll) {
            return true;
        }

        local isHeld = isHeldBy(gPlayerChar);

        if (onlyExamineAll) {
            if (isOrIsIn(gPlayerChar) && !examined) return nil;
            return !action.ofKind(Examine);
        }

        // If the object is set to be ignored, then ALL only applied for inventory
        if (pleaseIgnoreMe) {
            return !isHeld;
        }

        // Don't bother with anyone's clothing
        if (isWearable && wornBy != nil) {
            return true;
        }

        // Simple examination is fine
        if (action.ofKind(Examine)) return nil;

        // For any other senses, we need the player to be more specific.
        if (
            action.ofKind(ListenTo) &&
            action.ofKind(Feel) &&
            action.ofKind(Taste) &&
            action.ofKind(SmellSomething)
        ) {
            return true;
        }

        // Skip obvious problems
        if (action.ofKind(Open) || action.ofKind(Close)) return !isOpenable;
        if (action.ofKind(Take) || action.ofKind(TakeFrom)) return !isTakeable;
        if (action.ofKind(Wear) || action.ofKind(Doff)) return !isWearable;

        // Player has full control over inventory
        return !isHeld;
    }
}

modify SubComponent {
    alwaysHideFromAll = true
    onlyExamineAll = true
}

modify Platform {
    pleaseIgnoreMe = true
}

modify Booth {
    pleaseIgnoreMe = true
}

class Trinket: Thing {
    // This property works in both Adv3 and Adv3Lite
    isListed = (!canBeIgnored())

    // Adv3Lite properties
    inventoryListed = true
    lookListed = (isListed)
    examineListed = true
    searchListed = true

    // Adv3 properties
    isListedInInventory = true
    isListedInContents = true

    // This check works in both Adv3 and Adv3Lite!
    hideFromAll(action) {
        return canBeIgnored() || inherited(action);
    }

    // The bit that handles the actual logic.
    // This ALSO works in both Adv3 and Adv3Lite!
    canBeIgnored() {
        // If we are exposed, in the middle of the room, then
        // we cannot be ignored.
        if (location == getOutermostRoom()) {
            return nil;
        }

        // Allow actions like DROP ALL if we are being carried.
        if (isHeldBy(gPlayerChar)) {
            return nil;
        }

        // Otherwise, pay us no mind in X ALL.
        return true;
    }
}
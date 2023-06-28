/* TRINKETS
 * by Joseph Cramsey
 * 
 * A Thing that can be interacted with, but has limited listing
 * behaviors, and is excluded from _ ALL actions.
 */

modify Thing {
    pleaseIgnoreMe = nil

    hideFromAll(action) {
        // If the object is set to be ignored, then ALL only applied for inventory
        if (pleaseIgnoreMe) {
            return !isHeldBy(gPlayerChar);
        }

        // Simple actions are fine
        if (action.ofKind(Examine)) return nil;
        if (action.ofKind(ListenTo)) return nil;
        if (action.ofKind(Feel)) return nil;
        if (action.ofKind(Taste)) return nil;
        if (action.ofKind(SmellSomething)) return nil;

        // Skip obvious problems
        if (action.ofKind(Open) || action.ofKind(Close)) return !isOpenable;
        if (action.ofKind(Take) || action.ofKind(TakeFrom)) return !isTakeable;
        if (action.ofKind(Wear) || action.ofKind(Doff)) return !isWearable;

        // Player has full control over inventory
        return !isHeldBy(gPlayerChar);
    }
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
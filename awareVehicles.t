/* 
 * Aware Vehicles
 * by Joseph Cramsey
 * (Compatible with Adv3Lite only!)
 */

class GenericVehicle: Heavy {
    isVehicle = true
    stagingLocation = (location)
    isListed = true
}

class CoveredVehicle: GenericVehicle {
    isEnterable = true
    contType = In
}

class EnclosedVehicle: CoveredVehicle {
    isOpenable = true
}

class RidingVehicle: GenericVehicle {
    isBoardable = true
    contType = On
}

awareVehicleCache: object {
    actor = nil
    vehicle = nil

    showVehiclePosition = true
    showVehicleOnFloorOnly = nil
    useStackedPositions = true

    actorPrep = (actor.location.objInPrep)
    actorLoc = (actor.location.theName)
    actorStatusPrefix = (' (')
    actorStatusSuffix = (')')
    actorStatusDivider = (' ')
    actorStatusMsg =
        (actorStatusPrefix + actorPrep +
        actorStatusDivider + actorLoc + actorStatusSuffix)

    vehiclePrep = (vehicle.location.objInPrep)
    vehicleLoc = (vehicle.location.theName)
    vehicleStatusPrefix = (' (')
    vehicleStatusSuffix = (')')
    vehicleStatusDivider = (' ')
    vehicleStatusMsg =
        (vehicleStatusPrefix + vehiclePrep +
        vehicleStatusDivider + vehicleLoc + vehicleStatusSuffix)
    
    stackedDivider = (', which is ')
    stackedStatusMsg =
        (actorStatusPrefix + actorPrep +
        actorStatusDivider + actorLoc +
        stackedDivider + vehiclePrep +
        vehicleStatusDivider + vehicleLoc + vehicleStatusSuffix)
}

modify Room {
    statusName(actor) {
        local nestedLoc = '';
        local vehicleLoc = '';

        awareVehicleCache.actor = actor;

        local vehicle = actor;
        local potentialVehicle = actor.location;
        while (potentialVehicle != nil && !potentialVehicle.ofKind(Room)) {
            if (potentialVehicle.isVehicle) {
                vehicle = potentialVehicle;
                break;
            }
            potentialVehicle = potentialVehicle.location;
        }

        awareVehicleCache.vehicle = vehicle;

        if (awareVehicleCache.showVehicleOnFloorOnly) {
            local noVehicle = (actor == vehicle);
            local onFloor =
                (noVehicle ? actor.location.ofKind(Room) : vehicle.location.ofKind(Room));
            if (onFloor) {
                if (!noVehicle) {
                    nestedLoc = (awareVehicleCache.actorStatusMsg);
                }
            }
            else if (noVehicle) {
                nestedLoc = (awareVehicleCache.actorStatusMsg);
            }
            else {
                nestedLoc = (awareVehicleCache.vehicleStatusMsg);
            }
        }
        else {
            if (!actor.location.ofKind(Room)) {
                nestedLoc = (awareVehicleCache.actorStatusMsg);
            }

            if (awareVehicleCache.showVehiclePosition) {
                if (vehicle != actor) {
                    if (awareVehicleCache.useStackedPositions) {
                        if (!vehicle.location.ofKind(Room)) {
                            nestedLoc = (awareVehicleCache.stackedStatusMsg);
                        }
                    }
                    else {
                        if (!vehicle.location.ofKind(Room)) {
                            vehicleLoc = (awareVehicleCache.vehicleStatusMsg);
                        }
                    }
                }
            }
        }

        if(isIlluminated) {
            "<<roomTitle>><<nestedLoc>><<vehicleLoc>>";
        }
        else {
            "<<darkName>><<nestedLoc>><<vehicleLoc>>";
        }
    }
}
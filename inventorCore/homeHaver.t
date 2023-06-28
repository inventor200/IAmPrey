HomeHaver template 'vocab' @location? "basicDesc"?;
class HomeHaver: Thing {
    desc() {
        if (isHome()) {
            homeDesc();
            return;
        }
        basicDesc();
    }
    basicDesc = "(Missing description!) "
    homeDesc() { basicDesc(); }
    home = nil
    backHomeMsg = '{I} {put} {the dobj} back where it belongs. '
    pleaseIgnoreMe = true

    setHome() {
        home = location;
    }

    isHome() {
        if (isHeldBy(gPlayerChar)) return nil;
        if (home == nil) return true;
        return location == home;
    }

    dobjFor(Take) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(TakeFrom) {
        action() {
            setHome();
            inherited();
        }
    }

    dobjFor(Drop) {
        report() {
            if (location == home) {
                say(backHomeMsg);
            }
            else {
                inherited();
            }
        }
    }
}
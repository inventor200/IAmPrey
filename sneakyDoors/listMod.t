// Modify the normal exit listers, to be courteous of sneaking
modify statuslineExitLister {
    showListItem(obj, options, pov, infoTab) {
        if (highlightUnvisitedExits && (obj.dest_ == nil || !obj.dest_.seen)) {
            htmlSay('<FONT COLOR="<<unvisitedExitColour>>">');
        }

        "<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            AHREF_Plain)>>";

        if (highlightUnvisitedExits && (obj.dest_ == nil || !obj.dest_.seen)) {
            htmlSay('</FONT>');
        }
    }
}

modify lookAroundTerseExitLister {
    showListItem(obj, options, pov, infoTab) {
        htmlSay('<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            0)>>'
        );
    }
}

modify explicitExitLister {
    showListItem(obj, options, pov, infoTab) {
        htmlSay('<<aHref(
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            obj.dir_.name,
            sneakyCore.getDefaultTravelAction() + ' ' + obj.dir_.name,
            0)>>'
        );
    }
}
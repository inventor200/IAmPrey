class Cutscene: object {
    script = perInstance(new Vector())

    addPage(page) {
        script.append(new CutscenePage(page));
    }

    play() {
        local len = script.length;
        for (local i = 1; i <= len; i++) {
            "\b";
            if (gFormatForScreenReader) {
                "<b><tt>(page <<i>> of <<len>>)</tt></b>\b";
            }
            script[i].page();
            if (!gFormatForScreenReader) {
                "\b<b><tt>(pg <<i>> of <<len>>)</tt></b>\n";
            }
            waitForPlayer();
        }
    }
}

class CutscenePage: object {
    construct(_page) {
        self.setMethod(&page, _page);
    }

    page = nil
}
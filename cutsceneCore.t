class Cutscene: object {
    script = []

    addPage(page) {
        script += new CutscenePage(page);
    }

    play() {
        local len = script.length;
        for (local i = 1; i <= len; i++) {
            "\b";
            script[i].page();
            "\b<b><tt>(pg <<i>> of <<len>>)</tt></b>\n";
            morePrompt();
        }
    }
}

class CutscenePage: object {
    construct(_page) {
        self.setMethod(&page, _page);
    }

    page = nil
}
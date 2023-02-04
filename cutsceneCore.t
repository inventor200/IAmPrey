class Cutscene: object {
    script = perInstance(new Vector())

    addPage(page) {
        script.append(new CutscenePage(page));
    }

    play() {
        local len = script.length;
        for (local i = 1; i <= len; i++) {
            "\b";
            script[i].page();
            "\b<b><tt>(pg <<i>> of <<len>>)</tt></b>\n";
            inputManager.pauseForMore();
        }
    }
}

class CutscenePage: object {
    construct(_page) {
        self.setMethod(&page, _page);
    }

    page = nil
}
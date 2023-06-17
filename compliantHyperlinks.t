class CompULR: object {
    baseHeader = ''
    baseText = 'Click here'
    baseTail = ''
    altText = (baseText)
    name = 'Link to demo'
    url = './link/here'
    clickURL = (url)

    printBase() {
        if (outputManager.htmlMode) {
            say(baseHeader);
            say('<a href="' + clickURL + '">');
            say(baseText);
            say('</a>');
            say(baseTail);
        }
        else {
            say(altText);
        }
    }

    printFooter() {
        if (outputManager.htmlMode) return;
        say('<.p>\t<b>' + name + ':</b>\n');
        say('<tt>' + url + '</tt><.p>');
    }
}

authorEmailURL: CompULR {
    baseHeader = ' ('
    baseText = 'Email'
    baseTail = ')'
    altText = ''
    name = 'Author email address'
    url = 'josephcsoftware@gmail.com'
    clickURL = 'mailto:josephcsoftware@gmail.com'
}

authorBandcampURL: CompULR {
    baseHeader = ' ('
    baseText = 'Bandcamp'
    baseTail = ')'
    altText = ''
    name = 'URL to the author\'s bandcamp'
    url = 'https://joeycramsey.bandcamp.com/'
}

forumsURL: CompULR {
    baseText = 'Intfiction Forum'
    name = 'URL to the Intfiction Forum'
    url = 'https://intfiction.org/'
}

mathbrushURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to IFDB'
    baseTail = ')'
    altText = ''
    name = 'URL to Mathbrush\'s IFDB page'
    url = 'https://ifdb.org/showuser?id=nufzrftl37o9rw5t'
}

nightshademakerURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to Twitch'
    baseTail = ')'
    altText = ''
    name = 'URL to Nightshademakers\'s Twitch channel'
    url = 'https://www.twitch.tv/nightshademakers'
}

pinkunzURL: CompULR {
    baseHeader = ' ('
    baseText = 'Link to IFDB'
    baseTail = ')'
    altText = ''
    name = 'URL to Pinkunz\'s IFDB page'
    url = 'https://ifdb.org/showuser?id=dqr2mj29irbx1qv4'
}

mapURL: CompULR {
    baseHeader = '<.p>'
    baseText = 'Click here for the facility map!'
    baseTail = '<.p>'
    altText = ''
    name = 'URL to the facility map (on the IFArchive)'
    url = 'https://unbox.ifarchive.org/1363p9wc5y/extras/Stylized-Map.png'
}
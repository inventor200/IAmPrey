class Whiteboard: Fixture {
    vocab = 'whiteboard;white[weak];board'
    desc = "A large dry-erase whiteboard. Sometimes low tech solutions simply work. "
    readDesc = "<<if gCatMode
    >>{I} can't read.<<else
    >><<if hasWriting == nil>>Nothing seems to written here.<<else
    >>The whiteboard's written content is as follows:\n<tt><<
    writtenDesc()>></tt><<end>><<end>> "
    writtenDesc = ""
    hasWriting = nil
    wasRead = (hasWriting == nil)
}

class Projector: Decoration {
    vocab = 'projector'
    desc = "A large projector hangs from the ceiling. "
    notImportantMsg = 'The projector cannot be reached. '
}

class ProjectorScreen: Decoration {
    vocab = 'projector[weak] screen;wide smooth;canvas'
    desc = "A wide, smooth canvas, perfect for displaying a projected image. "
}
import SwiftUI

public struct Book {
    let id = UUID().uuidString
    let title: String
    let image: UIImage?
    var chapters: [Chapter]
    
    init?(path: URL?) {
        guard let path, let parser = EPUBParser(path: path) else { return nil }
        self.chapters = parser.chapters
        self.title = parser.getTitle()
        self.image = parser.image
    }
}

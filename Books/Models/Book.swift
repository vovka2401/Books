import Foundation
import UIKit

struct Book {
    public var id = UUID().uuidString
    public var title: String
    public var cover: UIImage?
    public var chapters: [Chapter]
    
    init?(path: URL?) {
        guard let path, let parser = EPUBParser(path: path), let book = parser.book else { return nil }
        self.init(book)
    }

    init(title: String, cover: UIImage? = nil, chapters: [Chapter]) {
        self.title = title
        self.cover = cover
        self.chapters = chapters
    }

    init(_ book: Book) {
        self = book
    }
}

extension Book : Equatable, Identifiable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
}

extension Book : Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
        case chapters
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(cover?.pngData(), forKey: .cover)
        try container.encode(chapters, forKey: .chapters)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        if let coverData = try values.decode(Data?.self, forKey: .cover) {
            cover = UIImage(data: coverData)
        }
        chapters = try values.decode([Chapter].self, forKey: .chapters)
    }
}

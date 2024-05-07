import Foundation

struct Chapter {
    var title: String
    var number: Int
    var text: String
//    var book: Book?

    init(title: String, number: Int, text: String, book: Book? = nil) {
        self.title = title
        self.number = number
        self.text = text
//        self.book = book
    }
}

extension Chapter: Hashable {
    func hash(into hasher: inout Hasher) {}

    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        lhs.number == rhs.number
    }
}

extension Chapter: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case number
        case text
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(number, forKey: .number)
        try container.encode(text, forKey: .text)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        number = try values.decode(Int.self, forKey: .number)
        text = try values.decode(String.self, forKey: .text)
    }
}

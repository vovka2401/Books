import SwiftUI

class BookViewModel: ObservableObject {
    @Published var book: Book!
    @Published var currentChapter: Chapter?
    var canGoPreviousChapter: Bool { currentChapter?.number != 0 }
    var canGoNextChapter: Bool { currentChapter?.number != book.chapters.count - 1 }
    
    init(book: Book) {
        self.book = book
        self.currentChapter = book.chapters.first
    }

    func choosePreviousChapter() {
        if let number = currentChapter?.number, number > 0 {
            currentChapter = book.chapters[number - 1]
        }
    }

    func chooseNextChapter() {
        if let number = currentChapter?.number, number + 1 < book.chapters.count {
            currentChapter = book.chapters[number + 1]
        }
    }
}

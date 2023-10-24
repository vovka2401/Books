import SwiftUI

class BookViewModel: ObservableObject {
    @Published var book: Book!
    @Published var currentChapter: Chapter?
    var canGoPreviousChapter: Bool { currentChapter?.numberWrapper != 0 }
    var canGoNextChapter: Bool { currentChapter?.numberWrapper != book.chaptersWrapper.count - 1 }
    
    public func setBook(book: Book) {
        self.book = book
        self.currentChapter = book.chaptersWrapper.first
    }

    func choosePreviousChapter() {
        if let number = currentChapter?.numberWrapper, number > 0 {
            currentChapter = book.chaptersWrapper[number - 1]
        }
    }

    func chooseNextChapter() {
        if let number = currentChapter?.numberWrapper, number + 1 < book.chaptersWrapper.count {
            currentChapter = book.chaptersWrapper[number + 1]
        }
    }
}

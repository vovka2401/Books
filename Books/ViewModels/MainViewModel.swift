import SwiftUI

class MainViewModel: ObservableObject {
    @Published var bookViewModel: BookViewModel!
    @Published var books: [Book] = []

    func addBook(_ book: Book) {
        books.append(book)
    }
//
//    func openBook(_ book: Book) {
//
//    }
}

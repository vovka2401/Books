import SwiftUI

class MainViewModel: ObservableObject {
    @Published var books: [Book]
    @Published var selectedBook: Book!

    init() {
        books = DiskManager.shared.retrieveBooks()
        selectedBook = books.first
    }

    func addBook(_ book: Book) {
        books.append(book)
    }

    func deleteBook(_ book: Book) {
        if let index = books.firstIndex(of: book) {
            books.remove(at: index)
        }
    }
    
    func saveBooks() {
        DiskManager.shared.saveBooks(books)
    }
}

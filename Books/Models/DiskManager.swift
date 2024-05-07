import Foundation
import Disk

final class DiskManager {
    static let shared = DiskManager()
    
    private init() {}
    
    func saveBooks(_ books: [Book]) {
        do {
            try Disk.save(books, to: .documents, as: "Disk/books")
        } catch {
            debugPrint("Couldn't save books")
        }
    }
    
    func retrieveBooks() -> [Book] {
        do {
            let books = try Disk.retrieve("Disk/books", from: .documents, as: [Book].self)
            return books
        } catch {
            debugPrint("Couldn't retrieve books")
            return []
        }
    }
}

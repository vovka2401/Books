import Foundation
import CoreData
import UIKit


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var cover: Data?
    @NSManaged public var chapter: NSSet?

    public var titleWrapper: String { title ?? "Unknown" }
    public var coverWrapper: UIImage? {
        guard let coverData = cover else { return nil }
        return UIImage(data: coverData)
    }
    public var chaptersWrapper: [Chapter] {
        guard let set = chapter as? Set<Chapter> else { return [] }
        return set.sorted { $0.number < $1.number }
    }
    
    convenience init(path: URL?, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        guard let path, let parser = EPUBParser(path: path, managedObjectContext: managedObjectContext) else { return }
        self.chapter = Set<Chapter>(parser.chapters) as NSSet
        self.title = parser.getTitle()
        self.cover = parser.image?.pngData()
    }
}

// MARK: Generated accessors for chapter
extension Book {

    @objc(addChapterObject:)
    @NSManaged public func addToChapter(_ value: Chapter)

    @objc(removeChapterObject:)
    @NSManaged public func removeFromChapter(_ value: Chapter)

    @objc(addChapter:)
    @NSManaged public func addToChapter(_ values: NSSet)

    @objc(removeChapter:)
    @NSManaged public func removeFromChapter(_ values: NSSet)

}

extension Book : Identifiable {

}

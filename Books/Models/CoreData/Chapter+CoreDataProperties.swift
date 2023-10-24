import Foundation
import CoreData


extension Chapter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        return NSFetchRequest<Chapter>(entityName: "Chapter")
    }

    @NSManaged public var title: String?
    @NSManaged public var number: Int16
    @NSManaged public var text: String?
    @NSManaged public var book: Book?

    public var titleWrapper: String { title ?? "" }
    public var numberWrapper: Int { Int(number) }
    public var textWrapper: String { text ?? "" }
}

extension Chapter : Identifiable {

}

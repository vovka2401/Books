import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Book")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

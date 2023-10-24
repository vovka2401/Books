import SwiftUI

@MainActor
@main
struct BooksApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
    }
}

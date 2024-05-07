import SwiftUI

@MainActor
@main
struct BooksApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}

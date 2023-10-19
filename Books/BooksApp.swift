import SwiftUI

@MainActor
@main
struct BooksApp: App {
    let mainViewModel: MainViewModel
    
    init() {
        mainViewModel = MainViewModel()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(viewModel: mainViewModel)
            }
        }
    }
}

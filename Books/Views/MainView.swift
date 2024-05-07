import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var bookViewModel = BookViewModel()
    @State var books: [Book] = []
    @State var showFilePicker = false
    @State var showBookView = false
    @State var showOptions = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                newBookView
                booksView
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
        .frame(width: Screen.width, height: Screen.height)
        .background(
            LinearGradient(
                colors: [.white, Color(red: 1, green: 0.5, blue: 0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.epub],
            allowsMultipleSelection: false
        ) { result in
            guard let url = try? result.get().first, let book = Book(path: url) else { return }
            viewModel.addBook(book)
            viewModel.saveBooks()
        }
        .confirmationDialog("Options", isPresented: $showOptions, titleVisibility: .visible) {
                Button("Delete") {
                    viewModel.deleteBook(viewModel.selectedBook)
                    viewModel.saveBooks()
                }
            }
        .fullScreenCover(isPresented: $showBookView) {
            BookView(viewModel: bookViewModel, isActive: $showBookView)
        }
        .onAppear {
            books = viewModel.books
        }
    }

    var newBookView: some View {
        Button {
            showFilePicker.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 250, height: 350)
                .foregroundColor(.gray)
                .overlay {
                    ZStack {
                        Circle()
                            .stroke(style: .init(lineWidth: 4))
                            .foregroundColor(.blue)
                            .frame(width: 100)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
        }
    }
    
    var booksView: some View {
        HStack {
            ForEach(viewModel.books.reversed(), id: \.id) { book in
                VStack {
                    if let cover = book.cover {
                        Image(uiImage: cover)
                            .resizable()
                            .frame(width: 250, height: 350)
                            .cornerRadius(25)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 250, height: 350)
                            .foregroundColor(.gray)
                            .overlay {
                                Text(book.title)
                                    .foregroundColor(.white)
                            }
                    }
                }
                .onTapGesture {
                    viewModel.selectedBook = book
                    bookViewModel.setBook(book: book)
                    showBookView.toggle()
                }
                .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 20) {
                    viewModel.selectedBook = book
                    showOptions.toggle()
                }
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(viewModel: MainViewModel())
//    }
//}

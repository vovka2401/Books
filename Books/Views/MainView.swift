import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var bookViewModel = BookViewModel()
    @State var books: [Book] = []
    @State var showFilePicker = false
    @State var showBookView = false
    @State var showOptions = false
    private var bookSize: CGSize {
        let width = Screen.width / 2 - 40
        let height = width * sqrt(2)
        return CGSize(width: width, height: height)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                let bookPairs = getBookPairs()
                ForEach(bookPairs, id: \.0?.id) { bookPair in
                    HStack(spacing: 20) {
                        if let leftBook = bookPair.0 {
                            bookView(leftBook)
                        } else {
                            addBookView
                        }
                        if let rightBook = bookPair.1 {
                            bookView(rightBook)
                        } else {
                            Spacer()
                                .frame(width: bookSize.width)
                        }
                    }
                }
            }
            .padding(.top, SafeAreaInsets.hasTop ? SafeAreaInsets.top : 20)
            .padding(.bottom, SafeAreaInsets.hasBottom ? SafeAreaInsets.bottom : 20)
        }
        .ignoresSafeArea()
        .frame(width: Screen.width, height: Screen.height)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
        )
        .ignoresSafeArea()
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

    var addBookView: some View {
        Button {
            showFilePicker.toggle()
        } label: {
            Rectangle()
                .frame(size: bookSize)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .white],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
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
    
    func bookView(_ book: Book) -> some View {
        VStack {
            if let cover = book.cover {
                Image(uiImage: cover)
                    .resizable()
                    .frame(size: bookSize)
            } else {
                Rectangle()
                    .frame(size: bookSize)
                    .foregroundColor(.gray)
                    .overlay {
                        Text(book.title)
                            .foregroundColor(.white)
                    }
            }
        }
        .onTapGesture {
            viewModel.selectBook(book)
            bookViewModel.openBook(book: book)
            showBookView.toggle()
        }
        .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 20) {
            viewModel.selectBook(book)
            showOptions.toggle()
        }
    }
}

extension MainView {
    private func getBookPairs() -> [(Book?, Book?)] {
        var bookPairs: [(Book?, Book?)] = [(nil, books.first)]
        for i in stride(from: 1, to: books.count, by: 2) {
            bookPairs.append((books[i], i < books.count ? books[i + 1] : nil))
        }
        return bookPairs
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(viewModel: MainViewModel())
//    }
//}

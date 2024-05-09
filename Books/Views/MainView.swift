import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var bookViewModel = BookViewModel()
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
            .padding(.top, SafeAreaInsets.top + 20)
            .padding(.bottom, SafeAreaInsets.hasBottom ? SafeAreaInsets.bottom : 20)
            .frame(width: Screen.width)
        }
        .ignoresSafeArea()
        .frame(size: Screen.size)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .ignoresSafeArea()
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.epub],
            allowsMultipleSelection: false
        ) { result in
            guard let url = try? result.get().first, let book = Book(path: url) else { return }
            withAnimation(.easeInOut) {
                viewModel.addBook(book)
            }
            viewModel.saveBooks()
        }
        .confirmationDialog("Options", isPresented: $showOptions, titleVisibility: .visible) {
                Button("Delete") {
                    withAnimation(.easeInOut) {
                        viewModel.deleteBook(viewModel.selectedBook)
                    }
                    viewModel.saveBooks()
                }
            }
        .fullScreenCover(isPresented: $showBookView) {
            BookView(viewModel: bookViewModel, isActive: $showBookView)
        }
    }

    var addBookView: some View {
        Button {
            showFilePicker.toggle()
        } label: {
            Image("default_book_cover")
                .resizable()
                .frame(size: bookSize)
                .overlay {
                    ZStack {
                        Circle()
                            .stroke(style: .init(lineWidth: 4))
                            .foregroundColor(Color(red: 0.69, green: 0.792, blue: 0.58))
                            .frame(width: 70)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(Color(red: 0.69, green: 0.792, blue: 0.58))
                            .frame(width: 40, height: 40)
                    }
                }
                .shadow(color: .black.opacity(0.3), radius: 10, x: 3, y: 5)
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
        .shadow(color: .black.opacity(0.3), radius: 10, x: 3, y: 5)
        .onTapGesture {
            viewModel.selectBook(book)
            bookViewModel.openBook(book: book)
            showBookView.toggle()
        }
        .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 20) {
            viewModel.selectBook(book)
            withAnimation(.easeInOut) {
                showOptions.toggle()
            }
        }
    }
}

extension MainView {
    private func getBookPairs() -> [(Book?, Book?)] {
        let books = viewModel.books
        var bookPairs: [(Book?, Book?)] = [(nil, books.first)]
        for i in stride(from: 1, to: books.count, by: 2) {
            bookPairs.append((books[i], i + 1 < books.count ? books[i + 1] : nil))
        }
        return bookPairs
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(viewModel: MainViewModel())
//    }
//}

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    @StateObject var viewModel = MainViewModel()
    @StateObject var bookViewModel = BookViewModel()
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
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.epub],
            allowsMultipleSelection: false
        ) { result in
            guard let url = try? result.get().first else { return }
            let book = Book(path: url, managedObjectContext: managedObjectContext)
            viewModel.addBook(book)
            try? managedObjectContext.save()
        }
        .confirmationDialog("Options", isPresented: $showOptions, titleVisibility: .visible) {
                Button("Delete") {
                    viewModel.deleteBook(viewModel.selectedBook)
                    books.drop { $0 == viewModel.selectedBook }
                    try? managedObjectContext.save()
                }
            }
        .fullScreenCover(isPresented: $showBookView) {
            BookView(viewModel: bookViewModel, isActive: $showBookView)
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
            ForEach(books.reversed(), id: \.id) { book in
                Button {
                    viewModel.selectedBook = book
                    bookViewModel.setBook(book: book)
                    showBookView.toggle()
                } label: {
                    VStack {
                        if let cover = book.coverWrapper {
                            Image(uiImage: cover)
                                .resizable()
                                .frame(width: 250, height: 350)
                                .cornerRadius(25)
                        } else {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 250, height: 350)
                                .foregroundColor(.gray)
                                .overlay {
                                    Text(book.titleWrapper)
                                        .foregroundColor(.white)
                                }
                        }
                    }
//                    .onTapGesture {}
//                    .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 20) {
//                        viewModel.selectedBook = book
//                        showOptions.toggle()
//                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var showFilePicker = false
    @State var showBookView = false

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
            guard let url = try? result.get().first, let book = Book(path: url) else { return }
            viewModel.addBook(book)
        }
        .fullScreenCover(isPresented: $showBookView) {
            BookView(viewModel: viewModel.bookViewModel, isActive: $showBookView)
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
                Button {
                    viewModel.bookViewModel = BookViewModel(book: book)
                    showBookView.toggle()
                } label: {
                    if let image = book.image {
                        Image(uiImage: image)
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
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

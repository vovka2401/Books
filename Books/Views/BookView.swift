import SwiftUI
import AVKit

struct BookView: View {
    @ObservedObject var viewModel: BookViewModel
    @Binding var isActive: Bool
    @State var speed = Double.zero
    @State var offset = Double.zero
    @State var translation = Double.zero
    @State var isOn = true
    @State var isNavigationHidden = true
    @State var maxHeight: Double?
    @State var showSettingsView = false
    @State var audioPlayer: AVAudioPlayer?
    var book: Book { viewModel.book }
    let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            text
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: SafeAreaInsets.top)
                if !isNavigationHidden {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .overlay {
                            HStack {
                                Button {
                                    isActive.toggle()
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                                Spacer()
                                Button {
                                    viewModel.choosePreviousChapter()
                                } label: {
                                    Image(systemName: "arrowshape.backward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                                .disabled(!viewModel.canGoPreviousChapter)
                                Spacer()
                                Button {
                                    viewModel.chooseNextChapter()
                                } label: {
                                    Image(systemName: "arrowshape.forward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                                .disabled(!viewModel.canGoNextChapter)
                                Spacer()
                                Button {
                                    showSettingsView.toggle()
                                } label: {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                }
                Spacer()
                Slider(value: $speed, in: 0...5)
                    .accentColor(isOn ? .accentColor : .red)
                    .padding(.horizontal, 20)
                    .frame(height: SafeAreaInsets.bottom + 40)
                    .background(Color.white)
                    .onChange(of: speed) { _ in
                        isOn = true
                    }
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            if isOn {
                offset -= speed * 0.2
            }
        }
        .onReceive(viewModel.$currentChapter) { _ in
            resetOffset()
            isOn = false
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView(audioPlayer: $audioPlayer)
                .presentationDetents([.medium, .large])
        }
    }
    
    var text: some View {
        GeometryReader { proxy in
            if let currentChapter = viewModel.currentChapter {
                VStack {
                    Text(currentChapter.title)
                        .bold()
                    Text(currentChapter.text)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(alignment: .leading)
                }
                .readSize { size in
                    maxHeight = size.height - Screen.height + SafeAreaInsets.top + SafeAreaInsets.bottom + 40.0
                }
            }
        }
        .offset(y: offset + translation)
        .padding(.top, SafeAreaInsets.top)
        .padding(.bottom, SafeAreaInsets.bottom + 40)
        .padding(.horizontal, 12)
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    isOn = false
                    if value.translation.height + offset < 0, let maxHeight,
                        value.translation.height + offset > -maxHeight {
                        translation = value.translation.height
                    } else if value.translation.height + offset >= 0 {
                        translation = -offset
                    } else if let maxHeight, value.translation.height + offset <= -maxHeight {
                        translation = -offset - maxHeight
                    }
                }
                .onEnded { value in
                    offset += translation
                    translation = 0
                }
        )
        .gesture (
            SimultaneousGesture(TapGesture(count: 1), TapGesture(count: 2))
                .onEnded { gestureValue in
                    if gestureValue.second != nil {
                        isOn.toggle()
                    } else if gestureValue.first != nil {
                        withAnimation(.easeInOut) {
                            isNavigationHidden.toggle()
                        }
                    }
                }

        )
    }

    private func resetOffset() {
        offset = 0
        translation = 0
    }
}

//struct BookView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookView(book: Book(path: nil))
//    }
//}

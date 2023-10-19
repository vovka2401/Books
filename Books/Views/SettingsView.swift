import SwiftUI
import AVKit

struct SettingsView: View {
    @Binding var audioPlayer: AVAudioPlayer?
    var soundTracks: [SoundTrack] = [
        SoundTrack(sound: "soft-rain", image: Image(systemName: "cloud.rain")),
        SoundTrack(sound: "birds", image: Image(systemName: "bird")),
    ]

    var body: some View {
        HStack(spacing: 20) {
            Button {
                self.audioPlayer?.stop()
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "pause.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                    }
            }
            ForEach(soundTracks, id: \.sound) { soundTrack in
                Button {
                    guard let sound = Bundle.main.path(forResource: soundTrack.sound, ofType: "mp3") else { return }
                    let url = URL(fileURLWithPath: sound)
                    if audioPlayer?.url != url {
                        self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                    }
                    self.audioPlayer?.play()
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 50, height: 50)
                        .overlay {
                            soundTrack.image
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                        }
                }
            }
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    @State var audioPlayer: AVAudioPlayer!
//    static var previews: some View {
//        SettingsView(audioPlayer: $audioPlayer)
//    }
//}

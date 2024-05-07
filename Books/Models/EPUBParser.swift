import EPUBKit
import CoreData
import UIKit
import Foundation

class EPUBParser {
    var book: Book?
    private var image: UIImage?

    init?(path: URL) {
        guard let document = EPUBDocument(url: path) else { return nil }
        fetchImage(from: document)
        let fileManager = FileManager.default
        var chapters: [Chapter] = []
        if let files = try? fileManager.contentsOfDirectory(atPath: document.contentDirectory.path) {
            var chapterURLs: [URL] = []
            let htmls = NSArray(array: files).pathsMatchingExtensions(["html", "xhtml"]).sorted(using: .localizedStandard)
            for html in htmls {
                let chapterURL = document.contentDirectory.appendingPathComponent(html)
                chapterURLs.append(chapterURL)
            }
            chapters = getChapters(from: chapterURLs).sorted { $0.number < $1.number }
        }
        book = Book(title: document.title ?? "Unknown", cover: image, chapters: chapters)
    }

    private func getChapters(from urls: [URL]) -> [Chapter] {
        var chapters: [Chapter] = []
        for (number, url) in urls.enumerated() {
            if let html = try? String(contentsOf: url),
               let txt = html.htmlToAttributedString  {
                let title = txt.string.components(separatedBy: "\n").first ?? ""
                let text = txt.string.replacingOccurrences(of: title, with: "")
                let chapter = Chapter(title: title, number: number, text: text)
                chapters.append(chapter)
            }
        }
        return chapters
    }
    
    private func fetchImage(from document: EPUBDocument) {
        if let imageURL = document.cover {
            downloadImage(from: imageURL) { image in
                if let image = image {
                    debugPrint("------ Parse cover initiated")
                    self.image = image
                }
            }
        }
    }

    private func downloadImage(from imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        let semaphore = DispatchSemaphore.init(value: 0)
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            defer { semaphore.signal() }
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid data or couldn't create an image.")
                completion(nil)
                return
            }
            completion(image)
        }
        .resume()
        semaphore.wait()
    }
}

import EPUBKit
import CoreData
import UIKit
import Foundation

class EPUBParser {
    var image: UIImage?
    var chapters: [Chapter] = []
    private var managedObjectContext: NSManagedObjectContext
    private var document: EPUBDocument

    init?(path: URL, managedObjectContext: NSManagedObjectContext) {
        guard let document = EPUBDocument(url: path) else { return nil }
        self.document = document
        self.managedObjectContext = managedObjectContext
        getImage()
        let fileManager = FileManager.default
        if let files = try? fileManager.contentsOfDirectory(atPath: document.contentDirectory.path) {
            var chapterURLs: [URL] = []
            let htmls = NSArray(array: files).pathsMatchingExtensions(["html"]).sorted(using: .localizedStandard)
            for html in htmls {
                let title = document.contentDirectory.appendingPathComponent(html)
                chapterURLs.append(title)
            }
            chapters = getChapters(from: chapterURLs)
        }
    }

    func getChapters(from urls: [URL]) -> [Chapter] {
        var chapters: [Chapter] = []
        for (number, url) in urls.enumerated() {
            if let html = try? String(contentsOf: url),
               let txt = html.htmlToAttributedString  {
                let title = txt.string.components(separatedBy: "\n").first ?? ""
                let text = txt.string.replacingOccurrences(of: title, with: "")
                let chapter = Chapter(context: managedObjectContext)
                chapter.title = title
                chapter.text = text
                chapter.number = Int16(number)
                chapters.append(chapter)
            }
        }
        return chapters
    }
    
    func getImage() {
        if let imageURL = document.cover {
            downloadImage(from: imageURL) { (image) in
                if let image = image {
                    self.image = image
                }
            }
        }
    }

    func downloadImage(from imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
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
    }
    
    func getTitle() -> String {
        document.title ?? ""
    }
}

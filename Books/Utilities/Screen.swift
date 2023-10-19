import CoreGraphics
import UIKit

enum Screen {
    static var bounds: CGRect { UIScreen.main.bounds }
    static var scale: CGFloat { UIScreen.main.scale }
    static var size: CGSize { bounds.size }
    static var width: CGFloat { size.width }
    static var height: CGFloat { size.height }
    static var isWide: Bool { width >= 414 }
    static var isTall: Bool { height >= 812 }
}

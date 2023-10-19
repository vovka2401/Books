import SwiftUI

enum SafeAreaInsets {
    static var top: CGFloat { value.top }
    static var bottom: CGFloat { value.bottom }
    static var hasTop: Bool { top != 0 }
    static var hasBottom: Bool { bottom != 0 }
    static var value: EdgeInsets { UIApplication.shared.keyWindow?.safeAreaInsets.asSwiftUI() ?? EdgeInsets() }
}

extension UIEdgeInsets {
    func asSwiftUI() -> EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

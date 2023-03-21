import Foundation
import UIKit

public extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

    func setCurrentPage(position: Int) {
        var cgpoint = self.frame.origin
        cgpoint.x = frame.size.width * CGFloat(position)
        cgpoint.y = 0
        setContentOffset(cgpoint, animated: true)
    }
}

public extension UIScrollView {
    /// Forces this view to get down to the bottom because we just moved what "bottom" means.
    func viewScrollToBottom(animated: Bool) {
        if contentSize.height < bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - (bounds.size.height - contentInset.bottom))
        setContentOffset(bottomOffset, animated: animated)
    }
}

import UIKit

extension UIView: GradientViewProvider {
    public typealias GradientViewType = GradientLayer
}

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return GradientLayer.self
        }
    }
}

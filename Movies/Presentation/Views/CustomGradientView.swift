import Foundation
import UIKit

class CustomGradientBackgroundView: GradientView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let topColor: UIColor = UIColor.black.withAlphaComponent(0.2)
        let bottomColor: UIColor = UIColor.black.withAlphaComponent(0.7)

        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.gradient = GradientPoint.topBottom.draw()
    }
}

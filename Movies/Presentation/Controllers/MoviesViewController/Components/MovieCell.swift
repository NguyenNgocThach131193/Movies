import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setup(title: String, year: String, poster: String) {
        nameLabel.text = title
        yearLabel.text = year
        posterImageView.sd_setImage(with: URL(string: poster))
    }
}

private extension MovieCell {
    func setupViews() {
        contentView.backgroundColor = .white

        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill

        nameLabel.font = UIFont.Font(.SanFranciscoDisplay, type: .Bold, size: 12)
        yearLabel.font = UIFont.Font(.SanFranciscoDisplay, type: .Medium, size: 12)

        nameLabel.textColor = .white
        yearLabel.textColor = .white
    }
}

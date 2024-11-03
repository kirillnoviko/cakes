import UIKit

class RecipeCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 13
        self.layer.masksToBounds = true

        viewImage.layer.cornerRadius = 13
        viewImage.layer.masksToBounds = true

    }
}

import UIKit

class SummaryView: UIView {
    var onSave: (() -> Void)?
    var onTryAgain: (() -> Void)?
    
    @IBOutlet weak var imageCream: UIImageView!
    @IBOutlet weak var imageShape: UIImageView!
    @IBOutlet weak var imageSprinkle: UIImageView!
    @IBOutlet weak var labelfilling: UILabel!
    @IBOutlet weak var labelbatter: UILabel!
    
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 600
        } else {
            constraintWidth.constant = 342
        }
    }
    
    func configure(shape: UIImage, cream: UIImage, sprinkle: UIImage, batter: String, filling: String) {
        imageCream.image = cream
        imageShape.image = shape
        imageSprinkle.image = sprinkle
        labelbatter.text = "Brownie batter: \(batter)"
        labelfilling.text = "Brownie filling: \(filling)"
    }
    
    // Действие для кнопки "Добавить в рецепты"
    @IBAction func addToRecipesTapped(_ sender: UIButton) {
        onSave?()
    }
    
    // Действие для кнопки "Try Again"
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        onTryAgain?()
    }
}

import UIKit

class ShapeSelectionView: UIView {
    var onShapeSelected: ((UIImage) -> Void)?
    
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    override func awakeFromNib() {
   
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 600
           
        }else{
            constraintWidth.constant = 342
        }
    }
    @IBAction func shapeButtonTapped(_ sender: UIButton) {
        if let selectedImage = sender.imageView?.image {
            onShapeSelected?(selectedImage)
        }
    }
}

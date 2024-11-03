import UIKit

class FillingSelectionView: UIView {
    var onFillingSelected: ((String) -> Void)?
    
  
    @IBAction func fillingButtonTapped(_ sender: UIButton) {
        if let selectedImage = sender.titleLabel?.text {
            onFillingSelected?(selectedImage)
        }
    }
}

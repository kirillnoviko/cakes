import UIKit

class BatterSelectionView: UIView {
    var onBatterSelected: ((String) -> Void)?
    
    @IBAction func batterButtonTapped(_ sender: UIButton) {
        if let selectedImage = sender.titleLabel?.text {
            onBatterSelected?(selectedImage)
        }
    }
}

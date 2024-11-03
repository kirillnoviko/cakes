import UIKit

class CreamSelectionView: UIView {
    var onCreamSelected: ((UIImage) -> Void)?
    
  
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button1.setBackgroundImage(UIImage(named: "cakeCream1"), for: .normal)
        button2.setBackgroundImage(UIImage(named: "cakeCream2"), for: .normal)
        button3.setBackgroundImage(UIImage(named: "cakeCream3"), for: .normal)
    }
    
    
    @IBAction func creamCButtonTapped(_ sender: UIButton) {
        if let selectedImage = sender.backgroundImage(for: .normal) {
            onCreamSelected?(selectedImage)
            }
    }
}

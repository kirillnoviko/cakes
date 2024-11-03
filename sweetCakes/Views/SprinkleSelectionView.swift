import UIKit

class SprinkleSelectionView: UIView {
    var onSprinkleSelected: ((UIImage) -> Void)?
    
    @IBOutlet weak var cake6: UIButton!
    @IBOutlet weak var cake5: UIButton!
    @IBOutlet weak var cake4: UIButton!
    @IBOutlet weak var cake3: UIButton!
    @IBOutlet weak var cake2: UIButton!
    @IBOutlet weak var cake1: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        cake1.setBackgroundImage(UIImage(named: "cakeSprinkle1"), for: .normal)
        cake2.setBackgroundImage(UIImage(named: "cakeSprinkle3"), for: .normal)
        cake3.setBackgroundImage(UIImage(named: "cakeSprinkle5"), for: .normal)
        cake4.setBackgroundImage(UIImage(named: "cakeSprinkle4"), for: .normal)
        cake5.setBackgroundImage(UIImage(named: "cakeSprinkle6"), for: .normal)
        cake6.setBackgroundImage(UIImage(named: "cakeSprinkle2"), for: .normal)
       
       
    }
    
    @IBAction func SprinkleButtonTapped(_ sender: UIButton) {
       
        if let selectedImage = sender.currentBackgroundImage {
            onSprinkleSelected?(selectedImage)
        }
    }
    
    
    
   
}

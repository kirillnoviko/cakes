
import UIKit

class BackupFinishView: UIView {
    
    @IBOutlet weak var returnToMainMenuButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        returnToMainMenuButton.addTarget(self, action: #selector(goToMainMenu), for: .touchUpInside)
    }
    var onReturnToMainMenu: (() -> Void)?
   
    @objc func goToMainMenu() {
        onReturnToMainMenu?()
    }}

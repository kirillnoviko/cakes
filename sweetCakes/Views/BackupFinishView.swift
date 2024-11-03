
import UIKit

class BackupFinishView: UIView {
    

    // Определите `IBOutlet` для кнопки
    @IBOutlet weak var returnToMainMenuButton: UIButton!
    
    // Замыкание для уведомления контроллера
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройте кнопку, если нужно
        returnToMainMenuButton.addTarget(self, action: #selector(goToMainMenu), for: .touchUpInside)
    }
    var onReturnToMainMenu: (() -> Void)?
    // Действие для возврата на главный экран
    @objc func goToMainMenu() {
        onReturnToMainMenu?() // Вызов замыкания для уведомления контроллера
    }}

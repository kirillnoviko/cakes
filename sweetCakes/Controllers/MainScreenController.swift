import UIKit

class MainScreenController: UIViewController {
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    @IBOutlet weak var constraint4: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    var coordinator: AppCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 580
            
            constraint1.constant = 16
            constraint2.constant = 16
            constraint3.constant = 16
            constraint4.constant = 16
        }else{
        
            constraintWidth.constant = 290
            
            constraint1.constant = 11
            constraint2.constant = 11
            constraint3.constant = 11
            constraint4.constant = 11
        }
 
    }
    
    @IBAction func goToFeedback(_ sender: UIButton) {
        coordinator?.showOnboardingScreenMenu()
    }
    
    @IBAction func clickShop(_ sender: Any) {
        coordinator?.showOrderCakes()
        
    }
    
    @IBAction func clickOrders(_ sender: Any) {
        coordinator?.showMyOrders()
        
    }
    @IBAction func clickrecipes(_ sender: Any) {
        coordinator?.showRecipes()
    }
    
    @IBAction func clickFeedback(_ sender: Any) {
        coordinator?.showFeedback()
       
    }
    @IBAction func clickGame(_ sender: Any) {
        coordinator?.showGame()
        
    }
   
    
    @IBAction func clickQR(_ sender: Any) {
        coordinator?.showQRScaner()
    }
}

import UIKit

class MainScreenController: UIViewController {
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    var coordinator: AppCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 580
           
        }else{
        
            constraintWidth.constant = 290
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
    
}

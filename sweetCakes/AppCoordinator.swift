import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
  
    
    init() {
        // init navigationController
              self.navigationController = UINavigationController()
             
    }
    
    
    func start() {
        
        if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            showPrivacyAndRule()
        } else {
            showMainScreen()
        }
    }
    
    func showPrivacyAndRule() {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        let storyboard = UIStoryboard(name: "PrivacyAndRule", bundle: nil)
        guard let privacyVC = storyboard.instantiateViewController(withIdentifier: "PrivacyAndRuleController") as? PrivacyAndRuleController else {
            fatalError("PrivacyAndRule not found")
        }
        privacyVC.coordinator = self
        navigationController.pushViewController(privacyVC, animated: true)
   
    }
    func showOnboardingScreen() {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingController") as? OnboardingController else {
            fatalError("OnboardingController not found")
        }
        onboardingVC.isCallMenu = false
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
   
    }
    func showOnboardingScreenMenu() {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingController") as? OnboardingController else {
            fatalError("OnboardingController not found")
        }
        onboardingVC.isCallMenu = true
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
   
    }
    
    func showMainScreen() {
        guard let navigationController = navigationController else {
            print("Navigation controller not found")
            return
        }
        
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        guard let mainScreenVC = storyboard.instantiateViewController(withIdentifier: "MainScreenController") as? MainScreenController else {
            fatalError("MainScreenController not found")
        }
        
        mainScreenVC.coordinator = self
        
       
        navigationController.setViewControllers([mainScreenVC], animated: true)
    }
    

    func showOrderCakes() {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        let storyboard = UIStoryboard(name: "OrderCakes", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OrderCakesController") as? OrderCakesController else {
            fatalError("OrderCakesController not found")
        }
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
    }

    func showOrderPlace(with selectedCakes: [Cake]) {
        
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        let storyboard = UIStoryboard(name: "OrderPlace", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OrderPlaceController") as? OrderPlaceController else {
            fatalError("OrderPlaceController not found")
        }
        
        onboardingVC.coordinator = self
        onboardingVC.selectedCakes = selectedCakes
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    
    func showMyOrders() {
        
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "MyOrders", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "MyOrdersController") as? MyOrdersController else {
            fatalError("MyOrdersController not found")
        }
        
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
        
    }
    
    func showRecipes() {
        
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "RecipeListView", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "RecipeListViewController") as? RecipeListViewController else {
            fatalError("RecipeListViewController not found")
        }
        
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
        
    }
    func showAddRecipes() {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "AddRecipe", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "AddRecipeController") as? AddRecipeController else {
            fatalError("AddRecipeController not found")
        }
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    func showDetailRecipe(with recipe: Recipe) {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "RecipeDetailView", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else {
            fatalError("RecipeDetailViewController not found")
        }
        onboardingVC.coordinator = self
        onboardingVC.recipe = recipe
        navigationController.pushViewController(onboardingVC, animated: true)
    }

    func showFeedback() {
       
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "FeedBack", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "FeedbackController") as? FeedbackController else {
            fatalError("FeedbackController not found")
        }
        
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
        
    }

    func showQRScaner(){
        let qrScannerVC = QRCodeScannerViewController()
        navigationController!.pushViewController(qrScannerVC, animated: true)
    }
   

        func goBack() {
            navigationController?.popViewController(animated: true)
        }
    
    func showGame()
    {
        guard let navigationController = navigationController else {
            print("return start")
            return
        }
        
        print(" start")
        
        let storyboard = UIStoryboard(name: "AnimatedView", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "AnimatedViewController") as? AnimatedViewController else {
            fatalError("AnimatedViewController not found")
        }
        
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
           
    }
    
    
    }


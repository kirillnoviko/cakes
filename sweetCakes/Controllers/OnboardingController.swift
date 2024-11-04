
import UIKit

class OnboardingController: UIViewController {
    var coordinator: AppCoordinator?

    
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var labelSkip: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    var isCallMenu: Bool!
    var currentPage = 0 
    
    let onboardingImages = ["Onboarding1", "Onboarding2"]
    let abouteTextButton = ["Next", "back to menu"]
    let onboardingTextButton = ["Next", "I’m ready"]
   
    override func viewDidLoad() {
        buttonBack.isHidden = true
        if isCallMenu  == true {
            setupNavigationBar()
        }
        super.viewDidLoad()
       
    }
    
    
    private func setupNavigationBar() {
        labelTitle.text = "About Kate"
        labelSkip.isHidden = true
        buttonBack.isHidden = false
    }
    @IBAction func goBack(_ sender: UIButton) {
        if currentPage == 1 {
            
          
            currentPage -= 1
            updateUI()
        } else {
            
            coordinator?.goBack()
            
            
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        
            if currentPage < onboardingImages.count - 1 {
                
         
                currentPage += 1
                updateUI()
            } else {
                if isCallMenu == true{
                    coordinator?.goBack()
                }else{
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    coordinator?.showMainScreen()
                }
                
            }
        
      
    }
    
  
    func updateUI() {
        imageView.image = UIImage(named: onboardingImages[currentPage])
        labelSkip.isHidden = true
        if isCallMenu == true{
            buttonContinue.setTitle(abouteTextButton[currentPage], for: .normal)
            
        }else{
            buttonContinue.setTitle(onboardingTextButton[currentPage], for: .normal)
        }
        
    }
  

}


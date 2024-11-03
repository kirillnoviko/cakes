
import UIKit

class PrivacyAndRuleController: UIViewController {
    var coordinator: AppCoordinator?

    @IBOutlet weak var continueButton: UIButton!
  
    @IBOutlet weak var consentSwitch: UIButton!

    @IBOutlet weak var textView: UITextView!
    
    var isChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         textView.clipsToBounds = true
        continueButton.isEnabled = false
        consentSwitch.setImage(UIImage(named: "checkButton"), for: .normal)
        
        continueButton.setImage(UIImage(named: "ButtonCustDisableText"), for: .normal)
        
        
        
               if let customFont = UIFont(name: "Digitalt", size: 14) {
                   
                   let shadow = NSShadow()
                   shadow.shadowColor = UIColor(red: 0xD7 / 255.0, green: 0x2F / 255.0, blue: 0xBE / 255.0, alpha: 1.0)
                   shadow.shadowOffset = CGSize(width: 1, height: 1)
                   
                   let attributes: [NSAttributedString.Key: Any] = [
                       .font: customFont,
                       .foregroundColor: UIColor.white,
                       .shadow: shadow
                   ]
                   
                   let attributedText = NSAttributedString(string: textView.text, attributes: attributes)
                   textView.attributedText = attributedText
               }
               
               textView.isEditable = false
               textView.isSelectable = false
               
          

    }


        
    @IBAction  func checkBoxTapped(_ sender: UIButton) {
              isChecked.toggle()

              if isChecked {
                
             
                  consentSwitch.setImage(UIImage(named: "checkButtonActive"), for: .normal)
                  continueButton.isEnabled = true
                  continueButton.setImage(UIImage(named: "ButtonCustText"), for: .normal)
                  
                     
              } else {
                  consentSwitch.setImage(UIImage(named: "checkButton"), for: .normal)
                  continueButton.isEnabled = false
                  continueButton.setImage(UIImage(named: "ButtonCustDisableText"), for: .normal) 
                  
                 
             
           
              }
          }
    

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        coordinator?.showOnboardingScreen()
    }
}

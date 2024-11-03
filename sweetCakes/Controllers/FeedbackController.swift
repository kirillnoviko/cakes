import UIKit
import SafariServices

class FeedbackController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var coordinator: AppCoordinator?
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    var xibView: BackupFinishView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShadow(for: buttonLeft)
        setupShadow(for: buttonRight)
        nameTextField.delegate = self
        emailTextField.delegate = self
        surnameTextField.delegate = self
        messageTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func openRules(_ sender: Any) {
        openSafari(with: "https://www.google.com")
    }
    @IBAction func openPrivacyPolicy(_ sender: Any) {
        openSafari(with: "https://www.vk.com")
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillHide() {
        view.gestureRecognizers?.forEach { recognizer in
            if recognizer is UITapGestureRecognizer {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    private func openSafari(with urlString: String) {
           if let url = URL(string: urlString) {
               let safariVC = SFSafariViewController(url: url)
               present(safariVC, animated: true, completion: nil)
           }
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func setupShadow(for button: UIButton) {
        button.layer.shadowColor = UIColor.systemPink.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 1
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        coordinator?.goBack()
    }


    func validateFields() -> Bool {
        var missingFields = [String]()
        
        if nameTextField.text?.isEmpty == true {
            missingFields.append("NAME")
        }
        if emailTextField.text?.isEmpty == true {
            missingFields.append("E-MAIL")
        } else if !isValidEmail(emailTextField.text!) {
            missingFields.append("E-MAIL (invalid format)")
        }
        if surnameTextField.text?.isEmpty == true {
            missingFields.append("SURNAME")
        }
        if messageTextField.text?.isEmpty == true {
            missingFields.append("MESSAGE")
        }
        
        if missingFields.isEmpty {
            return true
        } else {
            let alert = UIAlertController(title: "Fill in the Fields", message: "Please fill in the following fields: \(missingFields.joined(separator: ", "))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    // Функция для проверки формата email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func replaceContainerViewWithXib() {
        guard validateFields() else { return }

        buttonBack.isHidden = true
        containerView.removeFromSuperview()

        if let loadedView = Bundle.main.loadNibNamed("FeedbackFinish", owner: self, options: nil)?.first as? BackupFinishView {
            loadedView.frame = containerView.frame
            loadedView.translatesAutoresizingMaskIntoConstraints = false

            loadedView.onReturnToMainMenu = { [weak self] in
                self?.returnToMainMenu()
            }
            
            view.addSubview(loadedView)
            xibView = loadedView
            
            NSLayoutConstraint.activate([
                loadedView.topAnchor.constraint(equalTo: view.topAnchor),
                loadedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                loadedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loadedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }

    @IBAction func switchToSecondView(_ sender: UIButton) {
        replaceContainerViewWithXib()
    }
    
    func returnToMainMenu() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

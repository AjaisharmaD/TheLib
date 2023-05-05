//
//  ViewController.swift
//  TheLib
//
//  Created by Ideas2it on 30/03/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerStack: UIStackView!
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let userViewModel = UserViewModel()
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = setText(text: "login")
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        //HiLabel
        hiLabel.text = setText(text: "welcomeBack")
        hiLabel.textAlignment = .center
        hiLabel.font = Constants.titleFont
        
        //loginStackView
        loginStack.layer.shadowColor = Constants.shadowColor
        loginStack.layer.shadowOffset = Constants.shadowOffset
        loginStack.layer.shadowRadius = Constants.shadowRadius
        loginStack.layer.shadowOpacity = Constants.shadowOpacity
        loginStack.spacing = 20
        loginStack.backgroundColor = .white
        loginStack.layer.cornerRadius = Constants.cornerRadius
        loginStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.padding,
                                                                      leading: Constants.padding,
                                                                      bottom: Constants.padding,
                                                                      trailing: Constants.padding)
        
        loginStack.isLayoutMarginsRelativeArrangement = true
        
        //Email TF
        let imageView = UIImageView()
        let image1 = UIImage(systemName: "person")
        imageView.image = image1
        imageView.tintColor = .black
        emailTF.leftViewMode = .always
        emailTF.leftView = imageView
        emailTF.placeholder = setText(text: "email")
        emailTF.setStyle(textField: emailTF)
        emailTF.keyboardType = .emailAddress
        emailTF.returnKeyType = .next
        emailTF.rightViewMode = .always
        emailTF.addTarget(self,
                          action: #selector(ValidateEmail),
                          for: UIControl.Event.editingChanged)
        
        //Password TF
        passwordTF.placeholder = setText(text: "password")
        passwordTF.setStyle(textField: passwordTF)
        passwordTF.isSecureTextEntry = true
        passwordTF.returnKeyType = .done
        let imageView2 = UIImageView()
        let image2 = UIImage(systemName: "lock")
        imageView2.image = image2
        imageView2.tintColor = .black
        passwordTF.leftViewMode = .always
        passwordTF.leftView = imageView2
        passwordTF.addTarget(self,
                             action: #selector(ValidatePassword),
                             for: UIControl.Event.editingChanged)
        
        //Login Button
        loginButton.setTitle(setText(text: "login"), for: .normal)
        loginButton.layer.cornerRadius = loginButton.bounds.height/2
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginButton.layer.shadowRadius = 4
        loginButton.layer.shadowOpacity = 0.5
//        loginButton.isEnabled = true
        
        //RegisterStack
        registerStack.distribution = .fillProportionally
        registerStack.frame = CGRect(x: 0,
                                     y: 0,
                                     width: 300,
                                     height: 35)
        
        //MessageLable
        messageLable.numberOfLines = 1
        messageLable.text = setText(text: "dontHaveAccount")
        messageLable.textAlignment = .right
        
        //RegisterButton
        registerButton.setTitle(setText(text: "register"), for: .normal)
        registerButton.contentHorizontalAlignment = .left
    }
    
    @objc func ValidateEmail() {
        guard let email = emailTF.text else{
            return
        }
        emailTF.layer.borderWidth = Constants.borderWidth

        if validation.isEmailValid(email: email) {
            emailTF.layer.borderColor = Constants.correctColor
        } else {
            emailTF.layer.borderColor = Constants.wrongColor
        }
    }
    
    @objc func ValidatePassword() {
        guard let password = passwordTF.text else {
            return
        }
        passwordTF.layer.borderWidth = Constants.borderWidth
        
        if validation.isPasswordValid(password: password) {
            passwordTF.layer.borderColor = Constants.correctColor
        } else {
            passwordTF.layer.borderColor = Constants.wrongColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.login(loginButton)
        }
        return true
    }
    
    @IBAction func goToRegistration(_ sender: UIButton) {
        if let registerScreen = self.storyboard?.instantiateViewController(withIdentifier: "registerScreen") as? SignupViewController {
            self.navigationController?.pushViewController(registerScreen, animated: true)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {            
        if emailTF.text == "" && passwordTF.text == "" {
            self.showAlert(alertTitle: setText(text: "enterEmailPassword"),
                           alertMessage: setText(text: "notFilled"),
                           actionTitle: setText(text: "ok"))
        }
        
        if isExistingUser() {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(emailTF.text, forKey: "userEmail")
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).showDashBoard()
        } else {
            self.showAlert(alertTitle: setText(text: "notUser"),
                           alertMessage: setText(text: "noAccount"),
                           actionTitle: setText(text: "ok"))
        }
    }
    
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

extension UITextField {
    public func setStyle(textField: UITextField) {
        textField.font = .systemFont(ofSize: 15)
    }
}

extension LoginViewController: UITextFieldDelegate {
    private func isExistingUser() -> Bool {
    var isExisting: Bool = false
        if let email = emailTF.text, let password = passwordTF.text {
            if let user = userViewModel.fetchUserByEmail(email: email) {
                
                if password == user.password {
                    isExisting = true
                } else {
                    self.showAlert(alertTitle: setText(text: "wrongPassword"),
                                   alertMessage: setText(text: "wrongPasswordMessage"),
                                   actionTitle: setText(text: "ok"))
                }
            }
        }
        return isExisting
    }
}

extension UIViewController {
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle,
                                      style: .default))
        self.present(alert, animated: true)
    }
}

//extension String {
//    public func isEmailValid(email: String) -> Bool {
//        let regex = "^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$"
//
//        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
//
//        return pred.evaluate(with: email)
//    }
//
//    func isPasswordValid(password: String) -> Bool {
//        let regex  = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
//
//        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
//        return pred.evaluate(with: password)
//    }
//}

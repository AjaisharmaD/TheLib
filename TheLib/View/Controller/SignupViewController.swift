//
//  SignupViewController.swift
//  TheLib
//
//  Created by Ideas2it on 31/03/23.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {

    @IBOutlet weak var hiLable: UILabel!
    @IBOutlet weak var registerStack: UIStackView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let userViewModel = UserViewModel()
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hiding the back button
        navigationItem.hidesBackButton = true
        
        self.title = setText(text: "register")
        
        //Delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        
        //Hi Label
        hiLable.text = setText(text: "hi")
        hiLable.textAlignment = .center
        hiLable.font = Constants.titleFont
        
        //Register Stack
        registerStack.layer.shadowColor = Constants.shadowColor
        registerStack.layer.shadowRadius = Constants.shadowRadius
        registerStack.layer.shadowOffset = Constants.shadowOffset
        registerStack.layer.shadowOpacity = Constants.shadowOpacity
        registerStack.layer.cornerRadius = Constants.cornerRadius
        registerStack.backgroundColor = .white
        registerStack.spacing = 20
        registerStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.padding,
                                                                         leading: Constants.padding,
                                                                         bottom: Constants.padding,
                                                                         trailing: Constants.padding)
        registerStack.isLayoutMarginsRelativeArrangement = true
        
        //NameTF
        nameTF.placeholder = setText(text: "name")
        nameTF.setStyle(textField: nameTF)
        
        //EmailTF
        emailTF.placeholder = setText(text: "email")
        emailTF.setStyle(textField: emailTF)
        emailTF.keyboardType = .emailAddress
        emailTF.leftViewMode = .always
        emailTF.leftView = setPersonImage()
        emailTF.addTarget(self,
                          action: #selector(ValidateEmail),
                          for: UIControl.Event.editingChanged)
        
        //PasswordTF
        passwordTF.placeholder = setText(text: "password")
        passwordTF.setStyle(textField: passwordTF)
        passwordTF.isSecureTextEntry = true
        passwordTF.leftViewMode = .always
        passwordTF.leftView = setLockImage()
        passwordTF.addTarget(self,
                             action: #selector(ValidatePassword),
                             for: UIControl.Event.editingChanged)
        
        //ConfirmPasswordTF
        confirmPasswordTF.placeholder = setText(text: "confirmPassword")
        confirmPasswordTF.setStyle(textField: confirmPasswordTF)
        confirmPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.leftViewMode = .always
        confirmPasswordTF.leftView = setLockImage()
        confirmPasswordTF.addTarget(self,
                                    action: #selector(validateConfirmPassword),
                                    for: UIControl.Event.editingChanged)
        
        //RegistereButton
        registerButton.setTitle(setText(text: "register"), for: .normal)
        registerButton.layer.cornerRadius = registerButton.bounds.height / 2
        registerButton.layer.masksToBounds = true
        
        //LoginStack
        loginStack.distribution = .fillProportionally
        loginStack.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        
        //MessageLable
        messageLable.numberOfLines = 1
        messageLable.text = setText(text: "haveAccount")
        messageLable.textAlignment = .right
        
        //RegisterButton
        loginButton.setTitle(setText(text: "login"), for: .normal)
        loginButton.contentHorizontalAlignment = .left
        
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
    
    @objc func validateConfirmPassword() {
        confirmPasswordTF.layer.borderWidth = Constants.borderWidth
        if isPasswordEqual() {
            confirmPasswordTF.layer.borderColor = Constants.correctColor
        } else {
            confirmPasswordTF.layer.borderColor = Constants.wrongColor
        }
    }
    
    func setPersonImage() -> UIImageView {
        let imageView = UIImageView()
        let emailImage = UIImage(systemName: "person")
        imageView.image = emailImage
        imageView.tintColor = .black
        return imageView
    }
    
    func setLockImage() -> UIImageView {
        let imageView = UIImageView()
        let emailImage = UIImage(systemName: "lock")
        imageView.image = emailImage
        imageView.tintColor = .black
        return imageView
    }
    
    @IBAction func register(_ sender: UIButton) {
        if emailTF.text == "" &&
            nameTF.text == "" &&
            passwordTF.text == "" &&
            confirmPasswordTF.text == "" {
            self.showAlert(alertTitle: setText(text:"enterDetails"),
                           alertMessage: setText(text: "notFilled"),
                           actionTitle: setText(text: "ok"))
            
        } else if isAccountCreated(email: emailTF.text!) {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(emailTF.text, forKey: "userEmail")
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).showDashBoard()
        } else {
            print("something wrong")
        }
    }
    
    // popping the pushed view controller
    @IBAction func goToLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Localizing the string
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    // checking for new user
    private func isNewUser(email: String) -> Bool {
        var isNewUser: Bool = true
        let users = userViewModel.fetchAllUser()
        
        if users.isEmpty {
            isNewUser = true
        } else {
            if users.contains(where: { $0.emailId == email }) {
                isNewUser = false
            }
        }
        return isNewUser
    }
    
    //checking for account creation
    private func isAccountCreated(email: String) -> Bool {
        var isCreated: Bool = false
        
        if isNewUser(email: email) {
            if isPasswordEqual() {
                let newUser = User(context: userViewModel.context)
                
                //Setting user Details
                setToUser(user: newUser)
                //Save the User
                userViewModel.saveUser()
                isCreated = true
            } else {
                self.showAlert(alertTitle: setText(text:"passwordError"),
                               alertMessage: setText(text: "passwordNotMatching"),
                               actionTitle: setText(text: "ok"))
            }
        } else {
            self.showAlert(alertTitle: setText(text: "existingUser"),
                           alertMessage: setText(text:"alreadyReader"),
                           actionTitle: setText(text: "ok"))
        }
        return isCreated
    }
    
    //checking the password and confirm password is equal
    private func isPasswordEqual() -> Bool {
        var isEqual: Bool = false
        
        if confirmPasswordTF.text == passwordTF.text  {
            isEqual = true
        }
        return isEqual
    }
    
    // setting the user details to store it in the core data
    private func setToUser(user: User) {
        user.emailId = emailTF.text
        user.name = nameTF.text
        user.password = passwordTF.text
        let date  = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = setText(text: "dateFormat")
        user.created_date = date
        user.updated_date = date
        user.is_active = true
    }
}

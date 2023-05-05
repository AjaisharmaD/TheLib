//
//  ProfileViewController.swift
//  TheLib
//
//  Created by Ideas2it on 05/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileStack: UIStackView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    let userViewModel = UserViewModel()
    var user = User()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // profile Stack
        profileStack.backgroundColor = .white
        profileStack.spacing = 20
        profileStack.distribution = .fillEqually
        profileStack.layer.shadowRadius = Constants.shadowRadius
        profileStack.layer.shadowOpacity = Constants.shadowOpacity
        profileStack.layer.shadowOffset = Constants.shadowOffset
        profileStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.padding,
                                                                        leading: Constants.padding,
                                                                        bottom: Constants.padding,
                                                                        trailing: Constants.padding)
        profileStack.isLayoutMarginsRelativeArrangement = true
        profileStack.layer.cornerRadius = Constants.cornerRadius
        setStackConstraints()
        
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            return
        }
        
        if let currentUser = userViewModel.fetchUserByEmail(email: userEmail) {
            user = currentUser
        }

//        guard let email = user.emailId else {
//            return
//        }
//        
//        self.email = email
        
        //title lable
        titleLable.text = setText(text: "profile")
        titleLable.font = .systemFont(ofSize: 20, weight: .bold)
        titleLable.textAlignment = .center
        
        //Name Tf
        nameTF.text = user.name
        
        // Email TF
        emailTF.text = user.emailId
        emailTF.isUserInteractionEnabled = false
        
        //Update Button
        updateButton.setTitle(setText(text: "update"), for: .normal)
        updateButton.layer.shadowRadius = Constants.shadowRadius
        updateButton.layer.shadowOpacity = Constants.shadowOpacity
        updateButton.layer.shadowOffset = Constants.shadowOffset
        updateButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        
        //Logout Button
        logout.setTitle(setText(text: "logout"), for: .normal)
        logout.addTarget(self, action: #selector(didLogoutPressed), for: .touchUpInside)
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didMenuPressed))
    }
    
    @objc func updateProfile() {
            let date  = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = setText(text: "dateFormat")
            user.updated_date = date
            user.name = nameTF.text
            userViewModel.saveUser()
    }
    
//    private func isUniqueEmail(email: String) -> Bool {
//        var isUnique: Bool = true
//        let users = userViewModel.fetchAllUser()
//
//        if let existingUser = users.first(where: { $0.emailId == email }) {
//            if existingUser.emailId != email {
//                isUnique = false
//            }
//        }
//        return isUnique
//    }
    
    @objc func didLogoutPressed() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "userEmail")
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).showLogin()
    }
    
    @objc func didMenuPressed() {
        slideMenuController()?.openLeft()
    }
}

extension ProfileViewController {
    private func setText(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
    private func setStackConstraints() {
        profileStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    profileStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
                    profileStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
                    profileStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
                    profileStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
                ])
    }
}

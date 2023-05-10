//
//  SlideViewController.swift
//  FirstcarHost
//
//  Created by Ideas2IT-GaneshM on 10/10/17.
//  Copyright © 2017 Pandiyaraj. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // View Controllers
    var dashboardVC :UIViewController!
    var allBooksVC: UIViewController!
    var myBookVc : UIViewController!
    var categoryVC: UIViewController!
    var addBookVc : UIViewController!
    var profileVC : UIViewController!
    var loginVC: UIViewController!

    var SelectedGeneralMenuIndex: IndexPath?
    var menuIcon = ["house", "plus.circle", "book", "square.stack.3d.down.right", "person", "rectangle.portrait.and.arrow.forward", ""]

    private var menuItems = [MenuTitle]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuTitle.allCases
        self.menuItems = menu
        self.tableView.register(UINib.init(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        self.tableView.register(UINib(nibName: "DarkModeTableViewCell", bundle: nil), forCellReuseIdentifier: "DarkModeTableViewCell")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Dashboard
        let dashboard = storyboard.instantiateViewController(withIdentifier: "dashboardScreen") as! DashboardViewController
        let displayDashboard = CustomNavigationController(rootViewController: dashboard)
        self.dashboardVC = displayDashboard
        
        //All Books
//        let allBook = storyboard.instantiateViewController(withIdentifier: "AllBookScreen") as! AllBookViewController
//        let displayAllBooks = CustomNavigationController(rootViewController: allBook)
//        self.allBooksVC = displayAllBooks
        
        //My Book
        let myBook = storyboard.instantiateViewController(withIdentifier: "MyBookViewScreen") as! MyBookViewController
        let displayMyBook = CustomNavigationController.init(rootViewController: myBook)
        self.myBookVc = displayMyBook
        
        // Category
        let category = storyboard.instantiateViewController(withIdentifier: "CategoryScreen") as! CategoryViewController
        let displayCategory = CustomNavigationController.init(rootViewController: category)
        self.categoryVC = displayCategory
        
        // Add Book
        let addBook = storyboard.instantiateViewController(withIdentifier: "AddBookViewScreen") as! AddBookViewController
        let displayAddBook = CustomNavigationController.init(rootViewController: addBook)
        self.addBookVc = displayAddBook
        
        //Profile
        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileViewScreen") as! ProfileViewController
        let displayProfile = CustomNavigationController(rootViewController: profile)
        self.profileVC = displayProfile
        
        
        //Login
        let login = storyboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController
        let displayLoginVC = CustomNavigationController(rootViewController: login)
        self.loginVC = displayLoginVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:- Button actions
    // View Account button tapped
    
//    @IBAction func onCloseAction() -> Void{
//        self.slideMenuController()?.closeLeft()
//    }
    
//    @IBAction func onLogoutAction(sender : UIButton) {
//
//        UIApplication.shared.startNetworkActivity(info: Strings.loading.localized)
//        UserViewModel.sharedInfo.logoutUser { (success, response) in
//            DispatchQueue.main.async {
//                UIApplication.shared.stopNetworkActivity()
//                PermissionListObject.sharedInfo.clear()
//                ADServices.sharedInfo.signoutAction()
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.showLoginVc()
//            }
//        }
//
//
//
//    }
    
    //MARK:- TableView Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if 6 == indexPath.row {
            let darkModeCell = tableView.dequeueReusableCell(withIdentifier: "DarkModeTableViewCell", for: indexPath) as! DarkModeTableViewCell
            
            darkModeCell.label.text = "Change theme"
            darkModeCell.darkModeSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
            return darkModeCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            
            cell.iconImage.image = UIImage(systemName: menuIcon[indexPath.row])
            cell.titleLable.text = menuItems[indexPath.row].rawValue
            
            if SelectedGeneralMenuIndex != nil && self.SelectedGeneralMenuIndex == indexPath {
                cell.titleLable.font = Constants.titleFont
            } else {
                cell.titleLable.font = Constants.statusLableFont
                cell.titleLable.textColor = UIColor.black
            }
            return cell
        }
    }
    
    @objc func switchPressed(_ sender: UISwitch) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        if sender.isOn {
            sceneDelegate.window?.overrideUserInterfaceStyle = .dark
        } else {
            sceneDelegate.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.SelectedGeneralMenuIndex = indexPath
        let item = menuItems[indexPath.row]
        let selectedRow = item
        
        switch selectedRow {
        case .dashboard :
            DispatchQueue.main.async {
                self.slideMenuController()?.changeMainViewController(self.dashboardVC, close: true)
            }
            break
            
        case .myBook:
            DispatchQueue.main.async {
                self.slideMenuController()?.changeMainViewController(self.myBookVc, close: true)
            }
            break
            
        case .category:
            DispatchQueue.main.async {
                self.slideMenuController()?.changeMainViewController(self.categoryVC, close: true)
            }
            break
            
        case .addBook:
            DispatchQueue.main.async {
                self.slideMenuController()?.changeMainViewController(self.addBookVc, close: true)
            }
            break
            
        case .profile:
            DispatchQueue.main.async {
                self.slideMenuController()?.changeMainViewController(self.profileVC, close: true)
            }
            break
            
        case .logout:
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set(nil, forKey: "userEmail")
            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).showLogin()
            break
        case .theme:
            break
        }
    }
    
    public func pushVc(controller : UIViewController) -> Void {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

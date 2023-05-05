//
//  CustomNavigationController.swift
//  Zeus
//
//  Created by Mac on 2/20/19.
//  Copyright © 2019 Pandiyaraj. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateView()
        // Do any additional setup after loading the view.
    }
    
    func updateView() -> Void {
        self.navigationBar.barTintColor = UIColor.lightGray
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: " ", style: .plain, target: self, action: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

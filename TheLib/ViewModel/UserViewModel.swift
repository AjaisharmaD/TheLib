//
//  UserViewModel.swift
//  TheLib
//
//  Created by Ideas2it on 07/04/23.
//

import UIKit
import CoreData

class UserViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func saveUser() {
        
        do {
            try context.save()
            
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "Not Found")
        } catch {
            print("not saved")
        }
    }
    
    public func fetchAllUser() -> [User] {
        var users = [User]()
        
        do {
            let req = User.fetchRequest()
            req.returnsObjectsAsFaults = false
            users = try context.fetch(req)
        } catch {
            print("Unable to get User")
        }
        return users
    }

    public func fetchUserByEmail(email: String) -> User? {
        var existingUser : User?
        let req = User.fetchRequest()
        req.predicate = NSPredicate(format: "emailId == %@", email)
        
        do {
            let user = try context.fetch(req)
            if let user1 = user.first {
                existingUser = user1
            }
        } catch {
            
        }
        return existingUser
    }
}

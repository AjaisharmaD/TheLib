//
//  UserBookViewModel.swift
//  TheLib
//
//  Created by Ideas2it on 26/04/23.
//

import UIKit

public class UserBookViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUserBook() {
        do {
            try context.save()
        } catch {
            print("error while saving book")
        }
    }
    
    func fetchMyBook(email: String) -> [UserBook] {
        var books = [UserBook]()
        
        do {
            let req = UserBook.fetchRequest()
            req.predicate = NSPredicate(format: "user_email = %@", email)
            books = try context.fetch(req)
        } catch {
            print("error while fetching the Books")
        }
        return books
    }
}

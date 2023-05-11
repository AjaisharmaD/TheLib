//
//  UserBookViewModel.swift
//  TheLib
//
//  Created by Ideas2it on 26/04/23.
//
import UIKit

public class UserBookViewModel {
    let ubContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUserBook() {
        do {
            try ubContext.save()
        } catch {
            print("error while saving book")
        }
    }
    
    func fetchMyBook(email: String) -> [UserBook] {
        var books = [UserBook]()
        
        do {
            let req = UserBook.fetchRequest()
            req.predicate = NSPredicate(format: "user_email = %@", email)
            books = try ubContext.fetch(req)
        } catch {
            print("error while fetching the Books")
        }
        return books
    }
    
    func deleteMyBook(book: UserBook) {
            ubContext.delete(book)
            saveUserBook()
    }
}

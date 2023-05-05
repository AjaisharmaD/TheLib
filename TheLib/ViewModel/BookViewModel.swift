//
//  BookViewModel.swift
//  TheLib
//
//  Created by Ideas2it on 11/04/23.
//

import Foundation
import CoreData
import UIKit

class BookViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func saveBook() {
        do {
            try context.save()
        } catch {
            print("error while saving book")
        }
    }
    
    public func fetchAllBooks() -> [Book] {
        var books = [Book]()
        
        do {
            let req = Book.fetchRequest()
            req.predicate = NSPredicate(format: "(is_deleted == nil || is_deleted = %d)", false)
            books = try context.fetch(req)
        } catch {
            print("error while fetching the Books")
        }
        return books
    }
    
    public func fetchBook(bookId: String) -> Book? {
        var book : Book?
        
        do {
            let req = Book.fetchRequest()
            req.predicate = NSPredicate(format: "book_id = %@ AND (is_deleted == nil || is_deleted = %d)", bookId, false)
            let results = try context.fetch(req)
            book = results.first
        } catch {
            print("error while fetching the Books")
        }
        return book
    }
    
    public func fetchByStatus(bookStatus: BookStatus) -> [Book] {
        var books = [Book]()
        
        do {
            let req = Book.fetchRequest()
            req.predicate = NSPredicate(format: "status == %@", bookStatus.rawValue)
            books = try context.fetch(req)
        } catch {
            print("Error while fetching by Status")
        }
        return books
    }
    
    public func fetchByCategory(category: Category) -> [Book] {
        var books = [Book]()
        
        do {
            let req = Book.fetchRequest()
            req.predicate = NSPredicate(format: "catagory == %@", category.rawValue)
            books = try context.fetch(req)
        } catch {
            print("Error while fetching by Status")
        }
        return books
    }
}

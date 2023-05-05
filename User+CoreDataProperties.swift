//
//  User+CoreDataProperties.swift
//  TheLib
//
//  Created by Ideas2it on 05/05/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var created_date: Date?
    @NSManaged public var emailId: String?
    @NSManaged public var is_active: Bool
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var updated_date: Date?
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension User {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: UserBook)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: UserBook)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

extension User : Identifiable {

}

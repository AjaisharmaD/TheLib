//
//  Book+CoreDataProperties.swift
//  TheLib
//
//  Created by Ideas2it on 05/05/23.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var book_description: String?
    @NSManaged public var book_id: String?
    @NSManaged public var book_image: Data?
    @NSManaged public var catagory: String?
    @NSManaged public var created_date: Date?
    @NSManaged public var is_deleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var updated_date: Date?
    @NSManaged public var forUser: NSSet?

}

// MARK: Generated accessors for forUser
extension Book {

    @objc(addForUserObject:)
    @NSManaged public func addToForUser(_ value: UserBook)

    @objc(removeForUserObject:)
    @NSManaged public func removeFromForUser(_ value: UserBook)

    @objc(addForUser:)
    @NSManaged public func addToForUser(_ values: NSSet)

    @objc(removeForUser:)
    @NSManaged public func removeFromForUser(_ values: NSSet)

}

extension Book : Identifiable {

}

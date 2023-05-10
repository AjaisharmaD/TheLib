//
//  UserBook+CoreDataProperties.swift
//  TheLib
//
//  Created by Ideas2it on 09/05/23.
//
//

import Foundation
import CoreData


extension UserBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserBook> {
        return NSFetchRequest<UserBook>(entityName: "UserBook")
    }

    @NSManaged public var book_id: String?
    @NSManaged public var status: String?
    @NSManaged public var user_email: String?
    @NSManaged public var books: Book?

}

extension UserBook : Identifiable {

}

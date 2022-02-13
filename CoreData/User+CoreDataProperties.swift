//
//  User+CoreDataProperties.swift
//  
//
//  Created by Nikolas on 15.01.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var cigaretteProgress: NSProgress?
    @NSManaged public var image: Data?
    @NSManaged public var moneyProgress: NSProgress?

}

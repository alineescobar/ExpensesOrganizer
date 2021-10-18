//
//  Item+CoreDataProperties.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 18/10/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var recurrence: Bool

}

extension Item : Identifiable {

}

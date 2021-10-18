//
//  Goal+CoreDataProperties.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 18/10/21.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var goalID: UUID?
    @NSManaged public var goalDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension Goal : Identifiable {

}

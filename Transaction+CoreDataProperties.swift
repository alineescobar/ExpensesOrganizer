//
//  Transaction+CoreDataProperties.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 18/10/21.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var transactionDate: Date?
    @NSManaged public var value: Double
    @NSManaged public var origem: UUID?
    @NSManaged public var destination: UUID?

}

extension Transaction : Identifiable {

}

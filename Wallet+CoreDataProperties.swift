//
//  Wallet+CoreDataProperties.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 18/10/21.
//
//

import Foundation
import CoreData


extension Wallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallet> {
        return NSFetchRequest<Wallet>(entityName: "Wallet")
    }

    @NSManaged public var walletID: UUID?
    @NSManaged public var name: String?
    @NSManaged public var walletDescription: String?
    @NSManaged public var value: Double
    @NSManaged public var recurrence: Bool

}

extension Wallet : Identifiable {

}

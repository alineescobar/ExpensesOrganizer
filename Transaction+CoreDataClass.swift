//
//  Transaction+CoreDataClass.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 18/10/21.
//
//

import CoreData
import Foundation
import UIKit

public class Transaction: NSManagedObject, Operable {
//    swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    swiftlint:enable force_cast

// MARK: - Fetch goal
    func fetchGoal(objectID: UUID) -> Goal? {
        do {
            let request = Goal.fetchRequest() as NSFetchRequest<Goal>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "goalID == %@", objectID.uuidString)
            
            request.predicate = predicate

            let goal = try context.fetch(request)
            return goal.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

// MARK: - Fetch wallet
    func fetchWallet(objectID: UUID) -> Wallet? {
        do {
            let request = Wallet.fetchRequest() as NSFetchRequest<Wallet>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "walletID == %@", objectID.uuidString)
            
            request.predicate = predicate

            let wallet = try context.fetch(request)
            return wallet.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

// MARK: - Income function
    func income(objectID: UUID, value: Double) {
        if let goal = fetchGoal(objectID: objectID) {
            if value > 0.0 {
                goal.value += value
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("valor inválido")
            }
        } else if let wallet = fetchWallet(objectID: objectID) {
            if value > 0.0 {
                wallet.value += value
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("valor inválido")
            }
        }
        
    }

// MARK: - Outcome function
    func outcome(objectID: UUID?, value: Double) {
        if let objectID = objectID {
            if let goal = fetchGoal(objectID: objectID) {
                if value > 0.0 && value < goal.value {
                    goal.value -= value
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("valor insuficiente POBRE")
                }
            } else if let wallet = fetchWallet(objectID: objectID) {
                if value > 0.0 && value < wallet.value {
                    wallet.value -= value
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("valor inválido")
                }
            }
        } else {
            print("sem object id")
        }
    }
    
}

protocol Operable {
    func income(objectID: UUID, value: Double)
    func outcome(objectID: UUID?, value: Double)
}

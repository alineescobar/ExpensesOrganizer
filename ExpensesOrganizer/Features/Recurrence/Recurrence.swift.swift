//
//  Recurrence.swift.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 26/11/21.
//

import CoreData
import UIKit

class Recurrence {
    
    var wallet: Wallet?
    var transaction: Transaction?
    
    func reloadTransactions() {
        do {
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>

            let recurrenceType = NSPredicate(format: "recurrenceType == %@", transaction?.recurrenceType ?? "")
            let transactionDate = NSPredicate(format: "transactionDate == %@", transaction?.transactionDate?.shortDate ?? "")
            
            request.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    recurrenceType,
                    transactionDate
                ]
            )
            
            DispatchQueue.main.async {
                //self.mainTableView.reloadData()
            }
        }
    }
    
    func reloadWallets() {
        do {
            let request = Wallet.fetchRequest() as NSFetchRequest<Wallet>

            let recurrenceType = NSPredicate(format: "recurrenceType == %@", wallet?.recurrencyType ?? "")
            let transactionDate = NSPredicate(format: "transactionDate == %@", wallet?.recurrenceDate?.shortDate ?? "")
            
            request.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    recurrenceType,
                    transactionDate
                ]
            )
            
            DispatchQueue.main.async {
                //self.mainTableView.reloadData()
            }
        }
    }
    
    
    func recurrenceCounter() {
        
    }
}

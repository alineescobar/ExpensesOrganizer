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
                // self.mainTableView.reloadData()
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
                // self.mainTableView.reloadData()
            }
        }
    }
    // olhar no user defults se foi aberto, p apenas fazer uma vez por dia.
    func recurrenceCounterDec(recurrenceType: RecurrencyTypes, transactionDate: Date) {
        let calendar = Calendar.current
        let currentDate = Date()
        
        if transactionDate == currentDate { //comparar só o dia/mes/ano, tranformar com date components
            switch recurrenceType {
            case .never:
                print("Never")
                
            case .everyDay:
                wallet?.value = wallet!.value - (wallet?.item!.value)!
                let date = calendar.date(byAdding: .day, value: 1, to: transactionDate)
                transactionDate = date //criar uma nova despesa, para o prox dia
                
            case .everyWeek:
                let date = calendar.date(byAdding: .day, value: 7, to: transactionDate)
                wallet?.value = wallet!.value - (wallet?.item!.value)!
                transactionDate = date
                
            case .eachTwoWeeks:
                let date = calendar.date(byAdding: .day, value: 14, to: transactionDate)
                wallet?.value = wallet!.value - (wallet?.item!.value)!
                
            case .eachMonth:
                let date = calendar.date(byAdding: .month, value: 1, to: transactionDate)
                wallet?.value = wallet!.value - (wallet?.item!.value)!
                
            case .eachYear:
                //Ano bissexto?
                let date = calendar.date(byAdding: .year, value: 1, to: transactionDate)
                wallet?.value = wallet!.value - (wallet?.item!.value)!
                
            default:
                print("default")
            }
        }
    }
    
}

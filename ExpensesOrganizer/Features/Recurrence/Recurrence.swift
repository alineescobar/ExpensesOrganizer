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
        }
    }
    
    // olhar no user defults se foi aberto, p apenas fazer uma vez por dia.
    func recurrenceCounterDec(recurrenceType: RecurrencyTypes, transactionDate: Date, wallet: Wallet, item: Item) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let expenseName: String = ""
        let expenseValue: Double = 0.0
        let selectedDate: Date = Date()
        let selectedRecurrencyType: RecurrencyTypes = .never
        
        let currentDate = Date()
        let calendar = Calendar.current.dateComponents([.day, .month, .year], from: currentDate)
        
        let transactionDateParce = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate)
        
        if transactionDateParce == calendar {// comparar só o dia/mes/ano, tranformar com date components -> ok
            switch recurrenceType {// fazer validacao de a carteira tem saldo -> ok
            case .never:
                print("Never")
                
            case .everyDay:
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                    item.recurrenceDate = date // criar uma nova despesa, para o prox dia -> ok
                }
                
            case .everyWeek:
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
                    item.recurrenceDate = date
                }
                
            case .eachTwoWeeks:
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 14, to: currentDate)
                    item.recurrenceDate = date
                }
                
            case .eachMonth:
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
                    item.recurrenceDate = date
                }
                
            case .eachYear:
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)
                    item.recurrenceDate = date
                }
                
            }
            
        }
        guard let newContext = context else {
            return
        }
        
        let newTransaction = Transaction(context: newContext)
        newTransaction.name = expenseName.isEmpty ? NSLocalizedString("Transaction", comment: "") : expenseName
        newTransaction.value = expenseValue
        newTransaction.transactionDate = selectedDate
        newTransaction.recurrenceType = selectedRecurrencyType.rawValue
        newTransaction.category = item.template
        newTransaction.transactionDestination = wallet.walletID
        newTransaction.origin = nil
        do {
            try newContext.save()
        } catch {
            print("erro")
            return
        }
        
    }
    
    func recurrenceCounterInc(recurrenceType: RecurrencyTypes, transactionDate: Date, wallet: Wallet, item: Item) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let expenseName: String = ""
        let expenseValue: Double = 0.0
        let selectedDate: Date = Date()
        let selectedRecurrencyType: RecurrencyTypes = .never
        
        let currentDate = Date()
        let calendar = Calendar.current.dateComponents([.day, .month, .year], from: currentDate)
        
        let transactionDateParce = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate)
        
        if transactionDateParce == calendar {// comparar só o dia/mes/ano, tranformar com date components -> ok
            switch recurrenceType {// fazer validacao de a carteira tem saldo -> ok
            case .never:
                print("Never")
                
            case .everyDay:
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                    item.recurrenceDate = date // criar uma nova despesa, para o prox dia -> ok
                
            case .everyWeek:
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
                    item.recurrenceDate = date
                
            case .eachTwoWeeks:
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 14, to: currentDate)
                    item.recurrenceDate = date
                
            case .eachMonth:
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
                    item.recurrenceDate = date
                
            case .eachYear:
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)
                    item.recurrenceDate = date
                
            }
            
        }
        guard let newContext = context else {
            return
        }
        
        let newTransaction = Transaction(context: newContext)
        newTransaction.name = expenseName.isEmpty ? NSLocalizedString("Transaction", comment: "") : expenseName
        newTransaction.value = expenseValue
        newTransaction.transactionDate = selectedDate
        newTransaction.recurrenceType = selectedRecurrencyType.rawValue
        newTransaction.category = item.template
        newTransaction.transactionDestination = wallet.walletID
        newTransaction.origin = nil
        do {
            try newContext.save()
        } catch {
            print("erro")
            return
        }
        
    }
    
}

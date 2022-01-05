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
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
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
    
    func recurrenceCounterDec(recurrenceType: RecurrencyTypes, transactionDate: Date, wallet: Wallet, item: Item) -> Bool {
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        switch recurrenceType {
        case .never:
            print("Never")
            
        case .everyDay:
            let transactionDateParse: DateComponents = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 1) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 1, to: transactionDate)
                    item.recurrenceDate = date
                } else {
                    return false
                }
            }
            
        case .everyWeek:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 7) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 7, to: transactionDate)
                    item.recurrenceDate = date
                } else {
                    return false
                }
            }
            
        case .eachTwoWeeks:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 14) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    let date = Calendar.current.date(byAdding: .day, value: 14, to: transactionDate)
                    item.recurrenceDate = date
                } else {
                    return false
                }
            }
            
        case .eachMonth:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .month, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    item.recurrenceDate = transactionDateFuture
                } else {
                    return false
                }
            }
            
        case .eachYear:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .year, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                if item.value > 0.0 && item.value < wallet.value {
                    wallet.value -= item.value
                    item.recurrenceDate = transactionDateFuture
                } else {
                    return false
                }
            }
            
        }
        
        guard let newContext = context else {
            return false
        }
        guard let name = item.name else {
            return false
        }
        
        let newTransaction = Transaction(context: newContext)
        newTransaction.name = name.isEmpty ? NSLocalizedString("Transaction", comment: "") : name
        newTransaction.value = item.value
        newTransaction.transactionDate = item.recurrenceDate
        newTransaction.recurrenceType = item.recurrenceType
        newTransaction.category = item.template
        newTransaction.transactionDestination = wallet.walletID
        newTransaction.origin = nil
        
        do {
            try newContext.save()
        } catch {
            print("erro")
            return false
        }
        
        return true
    }
    
    func recurrenceCounterInc(recurrenceType: RecurrencyTypes, transactionDate: Date, wallet: Wallet, item: Item) {
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        switch recurrenceType {
        case .never:
            print("Never")
            
        case .everyDay:
            let transactionDateParse: DateComponents = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 1) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += item.value
                let date = Calendar.current.date(byAdding: .day, value: 1, to: transactionDate)
                item.recurrenceDate = date
            }
            
        case .everyWeek:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 7) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += item.value
                let date = Calendar.current.date(byAdding: .day, value: 7, to: transactionDate)
                item.recurrenceDate = date
            }
            
        case .eachTwoWeeks:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 14) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += item.value
                let date = Calendar.current.date(byAdding: .day, value: 14, to: transactionDate)
                item.recurrenceDate = date
            }
            
        case .eachMonth:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .month, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += item.value
                item.recurrenceDate = transactionDateFuture
            }
            
        case .eachYear:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .year, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += item.value
                item.recurrenceDate = transactionDateFuture
            }
        }
        
        guard let newContext = context else {
            return
        }
        guard let name = item.name else {
            return
        }
        
        let newTransaction = Transaction(context: newContext)
        newTransaction.name = name.isEmpty ? NSLocalizedString("Transaction", comment: "") : name
        newTransaction.value = item.value
        newTransaction.transactionDate = item.recurrenceDate
        newTransaction.recurrenceType = item.recurrenceType
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
    
    func recurrenceCounterIncWallets(recurrenceType: RecurrencyTypes, transactionDate: Date, wallet: Wallet) {
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        switch recurrenceType {
        case .never:
            print("Never")
            
        case .everyDay:
            let transactionDateParse: DateComponents = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 1) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                    wallet.value += wallet.recurrenceValue
                    let date = Calendar.current.date(byAdding: .day, value: 1, to: transactionDate)
                    wallet.recurrenceDate = date
                // }
            }
            
        case .everyWeek:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 7) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += wallet.recurrenceValue
                    let date = Calendar.current.date(byAdding: .day, value: 7, to: transactionDate)
                    wallet.recurrenceDate = date
            }
            
        case .eachTwoWeeks:
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDate.adding(days: 14) ?? Date())
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += wallet.recurrenceValue
                    let date = Calendar.current.date(byAdding: .day, value: 14, to: transactionDate)
                    wallet.recurrenceDate = date
            }
            
        case .eachMonth:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .month, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += wallet.recurrenceValue
                wallet.recurrenceDate = transactionDateFuture
            }
            
        case .eachYear:
            let transactionDateFuture: Date = Calendar.current.date(byAdding: .year, value: 1, to: transactionDate) ?? Date()
            let transactionDateParse = Calendar.current.dateComponents([.day, .month, .year], from: transactionDateFuture)
            let transactionDateNormalized: Date = Calendar.current.date(from: transactionDateParse) ?? Date()
            let currentDateNormalized: Date = Calendar.current.date(from: currentDate) ?? Date()
            
            if currentDateNormalized >= transactionDateNormalized {
                wallet.value += wallet.recurrenceValue
                    wallet.recurrenceDate = transactionDateFuture
            }
            
        }
        
        guard let newContext = context else {
            return
        }
        
        let newTransaction = Transaction(context: newContext)
        newTransaction.name = (wallet.name ?? "") + NSLocalizedString("ProgrammedAddition", comment: "")
        newTransaction.value = wallet.recurrenceValue
        newTransaction.transactionDate = wallet.recurrenceDate
        newTransaction.recurrenceType = wallet.recurrencyType
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

//
//  TransactionsViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 26/10/21.
//

import UIKit

protocol TransactionAttDelegate: AnyObject {
    func reloadTransactions()
}

class TransactionsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    private let customCellId = "TransactionCell"
    private var transactions: [Transaction] = []
    weak var transactionDelegate: TransactionAttDelegate?
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        mainTableView.register(UINib(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        
        self.navigationItem.title = NSLocalizedString("TransactionsHeader", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any,
                                                                        NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor(named: "TertiaryBrandColor")
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
        // MARK: Transactions fetch
        getAllTransactions()
    }
    
    func getAllTransactions() {
        guard let context = self.context else {
            return
        }
        do {
            transactions = try context.fetch(Transaction.fetchRequest()).reversed()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        var date: String
        
        let today = Calendar.current.dateComponents([.day], from: Date())
        let transactionDay = Calendar.current.dateComponents([.day], from: transactions[indexPath.row].transactionDate ?? Date())
        
        if today.day == transactionDay.day {
            date = transactions[indexPath.row].transactionDate?.shortTime ?? Date().shortTime
        } else {
            let formatter = DateFormatter()
            let format = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
            formatter.dateFormat = format
            date = formatter.string(from: transactions[indexPath.row].transactionDate ?? Date())
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
        cell.transactionName.text = transactions[indexPath.row].name
        cell.transactionTag.text = transactions[indexPath.row].category?.name ?? NSLocalizedString("Others", comment: "")
        cell.transactionDate.text = date
        cell.transactionPrice.text = transactions[indexPath.row].category?.isExpense ?? false ? "-" + String(format: "%.2f", transactions[indexPath.row].value).currencyInputFormatting() :
        "+" + String(format: "%.2f", transactions[indexPath.row].value).currencyInputFormatting()
        cell.transactionImage.image = UIImage(named: transactions[indexPath.row].category?.templateIconName ?? "Atom")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let context = self.context else {
                return
            }
            context.delete(transactions[indexPath.row])
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
             try context.save()
            } catch {
                print(error.localizedDescription)
            }
            transactionDelegate?.reloadTransactions()
        }
    }
}

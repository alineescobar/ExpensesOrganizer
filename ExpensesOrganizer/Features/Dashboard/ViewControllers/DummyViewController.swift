//
//  DummyViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 25/10/21.
//

import UIKit

enum TransactionCells {
    case header, cell, emptyState
    
    static var allCases: [TransactionCells] {
        return [.header, .cell, .emptyState]
    }
}

class DummyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewDummy: UITableView!
    let customCellHeader = "TransactionsHeaderCell"
    let transactionsID = "transactions"
    private let transactionCells: [TransactionCells] = TransactionCells.allCases
    private let customCellId = "TransactionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDummy.register(UINib.init(nibName: customCellHeader, bundle: nil), forCellReuseIdentifier: customCellHeader)
        tableViewDummy.register(UINib(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableViewDummy.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionCells = transactionCells[indexPath.row]
        
        switch transactionCells {
        case .header:
            guard let cell = tableViewDummy.dequeueReusableCell(withIdentifier: customCellHeader, for: indexPath) as? TransactionsHeaderCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        case .cell:
            guard let cell = tableViewDummy.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
                return UITableViewCell()
            }

            cell.transactionImage.image = UIImage(named: "subscriptions")
            cell.transactionName.text = "Netflix"
            cell.transactionTag.text = "Assinatura"
            cell.transactionDate.text = "20 out"
            cell.transactionPrice.text = "-9,50"
            cell.selectionStyle = .none
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

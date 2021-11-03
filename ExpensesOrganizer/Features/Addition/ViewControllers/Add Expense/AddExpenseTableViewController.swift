//
//  AddExpenseTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

enum AddExpenseCells: CaseIterable {
    case value, divider, name, category, paymentMethod, planning
    
    static var allCases: [AddExpenseCells] {
        [.value, .name, .divider, .category, .divider, .paymentMethod, .divider, .planning]
    }
}

class AddExpenseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddExpenseCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = AddExpenseCells.allCases[indexPath.row]
        
        switch cellCategory {
        case .value:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseValueCell.identifier, for: indexPath) as? AddExpenseValueCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseNameCell.identifier, for: indexPath) as? AddExpenseNameCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpenseCategoryCell.identifier, for: indexPath) as? AddExpenseCategoryCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .paymentMethod:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePaymentCell.identifier, for: indexPath) as? AddExpensePaymentCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExpensePlanningCell.identifier, for: indexPath) as? AddExpenseValueCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .divider:
            return tableView.dequeueReusableCell(withIdentifier: "add-expense-divider-cell", for: indexPath)
        }
    }
}

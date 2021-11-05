//
//  AddIncomeTableViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

enum AddIncomeCells: CaseIterable {
    case value, divider, name, category, wallet, planning
    
    static var allCases: [AddIncomeCells] {
        [.value, .name, .divider, .category, .divider, .wallet, .divider, .planning]
    }
}

class AddIncomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        doneButton.layer.cornerRadius = 8
        
        cancellButton.layer.cornerRadius = 8
        cancellButton.layer.borderColor = UIColor.label.cgColor
        cancellButton.layer.borderWidth = 2.0
    }
}

extension AddIncomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddIncomeCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = AddIncomeCells.allCases[indexPath.row]
        
        switch cellCategory {
        case .value:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeValueCell.identifier, for: indexPath) as? AddIncomeValueCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeNameCell.identifier, for: indexPath) as? AddIncomeNameCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeCategoryCell.identifier, for: indexPath) as? AddIncomeCategoryCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .wallet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomeWalletCell.identifier, for: indexPath) as? AddIncomeWalletCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddIncomePlanningCell.identifier, for: indexPath) as? AddIncomePlanningCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .divider:
            return tableView.dequeueReusableCell(withIdentifier: "add-income-divider-cell", for: indexPath)
        }
    }
}

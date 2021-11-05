//
//  AddExpenseRecurrencyViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddExpenseRecurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let recurrencyTypes: [RecurrencyTypes] = RecurrencyTypes.allCases
    var selectedRecurrencyType: RecurrencyTypes = .never
    weak var recurrencyDelegate: RecurrencyTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recurrencyTypes.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recurrencyDelegate?.sendRecurrencyType(recurrencyType: selectedRecurrencyType)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recurrencyType = recurrencyTypes[indexPath.row]
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recurrencyType = recurrencyTypes[indexPath.row]
        
        // Reusing logic of RecurrencyTypeTableViewCell from Wallet Creation...
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recurrencyTypeCell", for: indexPath) as? RecurrencyTypeTableViewCell else {
            return UITableViewCell()
        }
        
        switch recurrencyType {
        case .never:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .everyDay:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .everyWeek:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachTwoWeeks:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachMonth:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachYear:
            cell.recurrencyTypeLabel.text = recurrencyType.rawValue
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        }
        return cell
    }
}

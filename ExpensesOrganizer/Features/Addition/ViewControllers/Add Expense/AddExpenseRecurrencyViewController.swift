//
//  AddExpenseRecurrencyViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddExpenseRecurrencyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let recurrencyTypes: [RecurrencyTypes] = RecurrencyTypes.allCases
    var selectedRecurrencyType: RecurrencyTypes = .never
    weak var recurrencyDelegate: RecurrencyTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AddExpenseRecurrencyViewController: UITableViewDelegate {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recurrencyDelegate?.sendRecurrencyType(recurrencyType: selectedRecurrencyType)
    }
}

extension AddExpenseRecurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recurrencyTypes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recurrencyType = recurrencyTypes[indexPath.row]
        selectedRecurrencyType = recurrencyType
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recurrencyType = recurrencyTypes[indexPath.row]
        
        // Reusing logic of RecurrencyTypeTableViewCell from Wallet Creation...
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recurrencyTypeCell", for: indexPath) as? RecurrencyTypeTableViewCell else {
            return UITableViewCell()
        }
        
        switch recurrencyType {
        case .never:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .everyDay:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .everyWeek:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachTwoWeeks:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachMonth:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        case .eachYear:
            cell.recurrencyTypeLabel.text = RecurrencyTypes.getTitleFor(title: recurrencyType)
            cell.recurrencyTypeCheckImage.alpha = selectedRecurrencyType == recurrencyType ? 1.0 : 0
        }
        return cell
    }
}

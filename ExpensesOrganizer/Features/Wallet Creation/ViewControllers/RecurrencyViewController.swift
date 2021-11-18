//
//  RecurrencyViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 04/11/21.
//

import UIKit

protocol RecurrencyTypeDelegate: AnyObject {
    func sendRecurrencyType(recurrencyType: RecurrencyTypes)
}

enum RecurrencyTypes: String, CaseIterable {
    case never = "Never",
         everyDay = "Daily",
         everyWeek = "Weekly",
         eachTwoWeeks = "EachTwoWeeks",
         eachMonth = "Monthly",
         eachYear = "Anually"
    
    static var allCases: [RecurrencyTypes] {
        return [.never, .everyDay, .everyWeek, .eachTwoWeeks, .eachMonth, .eachYear]
    }
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    static func getTitleFor(title: RecurrencyTypes) -> String {
        return title.localizedString()
    }
}

class RecurrencyViewController: UIViewController {

    @IBOutlet private weak var recurrencyOptionsTableView: UITableView!
    private let recurrencyTypes: [RecurrencyTypes] = RecurrencyTypes.allCases
    var selectedRecurrencyType: RecurrencyTypes = .never
    weak var recurrencyDelegate: RecurrencyTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recurrencyOptionsTableView.dataSource = self
        recurrencyOptionsTableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recurrencyDelegate?.sendRecurrencyType(recurrencyType: selectedRecurrencyType)
    }
    
}

extension RecurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recurrencyType = recurrencyTypes[indexPath.row]
        selectedRecurrencyType = recurrencyType
        self.dismiss(animated: true)
    }
}
extension RecurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recurrencyTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recurrencyType = recurrencyTypes[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recurrencyTypeCell", for: indexPath) as? RecurrencyTypeTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.recurrencyTypeLabel.textColor = UIColor(named: "WhiteStateColor")
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

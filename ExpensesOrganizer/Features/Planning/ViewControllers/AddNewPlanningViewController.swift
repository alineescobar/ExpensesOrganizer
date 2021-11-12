//
//  AddNewPlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 10/11/21.
//

import UIKit

enum NewPlanningCategories: CaseIterable {
    case name, payment, icon, button
    
    static var allCases: [NewPlanningCategories] {
        return [.name, .payment, .icon, .button]
    }
}

class AddNewPlanningViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private let newPlanningCategories: [NewPlanningCategories] = NewPlanningCategories.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: Navigation Visuals
        self.navigationItem.title = NSLocalizedString("AddPlanningTitle", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
        // MARK: Segmented Control
        segmentedControl.setTitle(NSLocalizedString("FirstSegmentedControl", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("SecondSegmentedControl", comment: ""), forSegmentAt: 1)
        let fontNormal = UIFont(name: "WorkSans-Regular", size: 14)
        let fontBold = UIFont(name: "WorkSans-SemiBold", size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontNormal as Any], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontBold as Any], for: .selected)
        
        // MARK: Cancel button
        cancelButton.layer.cornerRadius = 19
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        // MARK: Done button
        doneButton.layer.cornerRadius = 19
        doneButton.layer.borderWidth = 2
        doneButton.layer.backgroundColor = UIColor.black.cgColor
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        doneButton.tintColor = .white
    }

}

extension AddNewPlanningViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPlanningCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newPlanningCategory = newPlanningCategories[indexPath.row]
        
        switch newPlanningCategory {
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningName", for: indexPath) as? PlanningNAmeTableViewCell
                    
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        
        case .payment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningPayment", for: indexPath) as? PlannimgPaymentTableViewCell
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        case .icon:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningIcon", for: indexPath) as? PlanningIconTableViewCell
            else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newItenButton", for: indexPath) as? NewPlanningButtonTableViewCell
            else {
                return UITableViewCell()
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newPlanningCategory = newPlanningCategories[indexPath.row]
        
        switch newPlanningCategory {
        case .name:
            return 126
        case .payment:
            return 126
        case .icon:
            return 126
        case .button:
            return 81
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let
//    }
}

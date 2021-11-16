//
//  PlanningDetailViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 09/11/21.
//

import UIKit

enum PlanningDetailCategory: CaseIterable {
    case planningDetails, planningTotalBalance, planningItem
    
    static var allCases: [PlanningDetailCategory] {
        return [.planningDetails, .planningTotalBalance]
    }
    
    static var items: [PlanningDetailCategory] {
        return [.planningItem, .planningItem, .planningItem, .planningItem, .planningItem]
    }
}

class PlanningDetailViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var planningNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction private func cancelAction(_ sender: UIButton) {
        showCancelPlanningAlert()
    }
    @IBAction private func readyAction(_ sender: UIButton) {
        // TODO: Save Planning item on CoreData and set notifications
        self.dismiss(animated: true)
    }
    
    private let planningDetailCategories: [PlanningDetailCategory] = PlanningDetailCategory.allCases
    private let planningItems: [PlanningDetailCategory] = PlanningDetailCategory.items
    private let items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        presentationController?.delegate = self
        isModalInPresentation = true
        tableView.delegate = self
        tableView.dataSource = self
        readyButton.setTitle(NSLocalizedString("Ready", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    // TODO: Persist data on items array
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         guard let indexPath = sender as? IndexPath else {
//             return
//         }
         let itemViewController = segue.destination as? ItemViewController
//         itemViewController?.item = items[indexPath.row]
         itemViewController?.itemDelegate = self
         itemViewController?.isEditingItem = true
     }
    
    func showCancelPlanningAlert() {
        let alert = UIAlertController(title: NSLocalizedString("PlanningCreationCancelAlertTitle", comment: ""),
                                      message: NSLocalizedString("PlanningCreationCancelAlertDescription", comment: ""),
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
            // TODO: Delete Wallet object from CoreData
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("PlanningCreationKeepCreatingAction", comment: ""), style: .cancel, handler: { _ in
        }))

        self.present(alert, animated: true)
    }
    
}

extension PlanningDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let planningDetailCategory = planningDetailCategories[indexPath.row]
            
            switch planningDetailCategory {
            case .planningDetails:
                return 65
            default:
                return UITableView.automaticDimension
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(18)
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "planningItem", sender: indexPath)
        }
    }
}

extension PlanningDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return planningDetailCategories.count
        } else {
            return planningItems.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let planningDetailCategory = planningDetailCategories[indexPath.row]
            switch planningDetailCategory {
            case .planningDetails:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningEditionCell", for: indexPath) as? PlanningEditionTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.planningDescriptionTextField.text = NSLocalizedString("OptionalDescription", comment: "")
                return cell
                
            case .planningTotalBalance:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "totalPlanningBalanceCell", for: indexPath) as? TotalPlanningBalanceTableViewCell
                else {
                    return UITableViewCell()
                }
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            let planningItems = planningItems[indexPath.row]
            switch planningItems {
            case .planningItem:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningItemCell", for: indexPath) as? PlanningItemTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.planningItemDelegate = self
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        
    }
    
}

extension PlanningDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showCancelPlanningAlert()
    }
}

extension PlanningDetailViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PlanningDetailViewController: PlanningItemDelegate {
    func notificationSwitchDidChange(value: Bool, item: Item) {
        // TODO: Update item notification value
    }
}

extension PlanningDetailViewController: ItemDelegate {
    func updateItem() {
        tableView.reloadData()
    }
}

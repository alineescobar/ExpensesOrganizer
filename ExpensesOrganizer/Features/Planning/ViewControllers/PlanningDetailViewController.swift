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
}

class PlanningDetailViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var planningNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var templateName: String = ""
    private var templateDescription: String = ""
    
    @IBAction private func cancelAction(_ sender: UIButton) {
        showCancelPlanningAlert()
    }
    @IBAction private func readyAction(_ sender: UIButton) {
        if !templateName.isEmpty {
            // TODO: Set notifications
            guard let context = self.context else {
                return
            }
            
            template?.name = templateName
            template?.templateDescription = templateDescription
            template?.items = NSOrderedSet(array: items)
            
            do {
                try context.save()
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
                    DispatchQueue.main.async {
                        if !success {
                            print("Request Authorization Failed")
                            let alert = UIAlertController(title: NSLocalizedString("AccessDeniedNotificationsTitle", comment: ""),
                                                          message: NSLocalizedString("AccessDeniedNotificationsMessage", comment: ""),
                                                          preferredStyle: .alert)
                            
                            let notNowAction = UIAlertAction(title: NSLocalizedString("AccessDeniedNotificationsNotNow", comment: ""),
                                                             style: .cancel) {  _ in
                            }
                            alert.addAction(notNowAction)
                            
                            let openSettingsAction = UIAlertAction(title: NSLocalizedString("AccessDeniedOpenSettings", comment: ""),
                                                                   style: .default) { _ in
                                // Open app privacy settings
                                self.gotoAppPrivacySettings()
                            }
                            alert.addAction(openSettingsAction)
                            
                            self.present(alert, animated: true)
                        } else {
                            for item in self.deletedItems {
                                NotificationManager.shared.cancel(identifier: item.itemID?.uuidString ?? "Item")
                            }
                            
                            for item in self.items {
                                let recurrencyType: RecurrencyTypes = RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never
                                if item.sendsNotification {
                                    if recurrencyType == .everyDay {
                                        let itemValue: String = String(format: "%.2f", item.value).currencyInputFormatting()
                                        let itemName: String = item.name ?? "item"
                                        let paymentMethodName: String = item.paymentMethod?.name ?? NSLocalizedString("NoName", comment: "")
                                        
                                        let notificationBody: String = NSLocalizedString("NotificationDescription1", comment: "") +
                                        itemName + "! " + (Locale.current.currencySymbol ?? "$") +
                                        " " + itemValue + NSLocalizedString("NotificationDescription2", comment: "") + paymentMethodName + "."
                                        
                                        NotificationManager.shared.send(identifier: item.itemID?.uuidString ?? "Item",
                                                                        title: NSLocalizedString("NotificationTodayTitle", comment: "") + (item.name ?? "item") + "!",
                                                                        body: notificationBody,
                                                                        selectedDate: item.recurrenceDate ?? Date(),
                                                                        frequency: RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never)
                                    } else {
                                    let itemValue: String = String(format: "%.2f", item.value).currencyInputFormatting()
                                    let itemName: String = item.name ?? "item"
                                    let paymentMethodName: String = item.paymentMethod?.name ?? NSLocalizedString("NoName", comment: "")
                                    
                                    let notificationBody: String = NSLocalizedString("NotificationDescription1", comment: "") +
                                    itemName + NSLocalizedString("Tomorrow", comment: "") + (Locale.current.currencySymbol ?? "$") +
                                    " " + itemValue + NSLocalizedString("NotificationDescription2", comment: "") + paymentMethodName + "."
                                    
                                    NotificationManager.shared.send(identifier: item.itemID?.uuidString ?? "Item",
                                                                    title: NSLocalizedString("NotificationTomorrowTitle", comment: "") + (item.name ?? "item") + "!",
                                                                    body: notificationBody,
                                                                    selectedDate: item.recurrenceDate ?? Date(),
                                                                    frequency: RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never)
                                    }
                                } else {
                                    NotificationManager.shared.cancel(identifier: item.itemID?.uuidString ?? "Item")
                                }
                            }
                        }
                    }
                }
                modalHandlerDelegate?.modalDismissed()
                self.dismiss(animated: true)
            } catch {
                print(error.localizedDescription)
                return
            }
        } else {
            showEmptyNameAlert()
        }
        
    }
    
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    var template: Template?
    private let planningDetailCategories: [PlanningDetailCategory] = PlanningDetailCategory.allCases
    private var items: [Item] = []
    private var deletedItems: [Item] = []
    private var totalBalance: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        presentationController?.delegate = self
        isModalInPresentation = true
        tableView.delegate = self
        tableView.dataSource = self
        readyButton.setTitle(NSLocalizedString("Ready", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        guard let template = self.template else {
            return
        }
        planningNameLabel.text = template.name
        items = template.items?.array as? [Item] ?? []
        templateName = template.name ?? ""
        templateDescription = template.templateDescription ?? ""
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        
        /* Use for Scheduled Notifications debuging
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { notifications in
            print("Count: \(notifications.count)")
            for item in notifications {
                print("Title: " + item.content.title + ", Body: " + item.content.body)
                print(item.trigger)
            }
        }
        */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else {
            return
        }
        let itemViewController = segue.destination as? ItemViewController
        itemViewController?.item = items[indexPath.row]
        itemViewController?.itemDelegate = self
        itemViewController?.isEditingItem = true
    }
    
    func showCancelPlanningAlert() {
        let alert = UIAlertController(title: NSLocalizedString("PlanningEditionCancelAlertTitle", comment: ""),
                                      message: NSLocalizedString("PlanningCreationCancelAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("PlanningEditionKeepCreatingAction", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showEmptyNameAlert() {
        let alert = UIAlertController(title: NSLocalizedString("EmptyPlanningNameAlertTitle", comment: ""),
                                      message: NSLocalizedString("EmptyPlanningNameAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
}

extension PlanningDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return planningDetailCategories.count
        } else {
            return items.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let template = self.template else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            let planningDetailCategory = planningDetailCategories[indexPath.row]
            switch planningDetailCategory {
            case .planningDetails:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningEditionCell", for: indexPath) as? PlanningEditionTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.planningIcon.image = UIImage(named: template.templateIconName ?? "Atom")
                cell.planningTitleTextField.text = templateName
                cell.planningDescriptionTextField.text = templateDescription.isEmpty ? NSLocalizedString("OptionalDescription", comment: "") : templateDescription
                cell.planningEditionDelegate = self
                cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
                return cell
                
            case .planningTotalBalance:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "totalPlanningBalanceCell", for: indexPath) as? TotalPlanningBalanceTableViewCell
                else {
                    return UITableViewCell()
                }
                getTotalBalance()
                cell.balanceLabel.text = template.isExpense ? "-" + String(format: "%.2f", totalBalance).currencyInputFormatting()
                : "+" + String(format: "%.2f", totalBalance).currencyInputFormatting()
                cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            let item = items[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningItemCell", for: indexPath) as? PlanningItemTableViewCell
            else {
                return UITableViewCell()
            }
            cell.planningItemDelegate = self
            cell.itemNameLabel.text = item.name
            cell.itemValueLabel.text = template.isExpense ? "-" + String(format: "%.2f", item.value).currencyInputFormatting() : "+" + String(format: "%.2f", item.value).currencyInputFormatting()
            cell.itemRecurrencyLabel.text = RecurrencyTypes.getTitleFor(title: RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never)
            cell.notificationSwitch.setOn(item.sendsNotification, animated: false)
            cell.item = item
            cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Unschedule future Push Notifications
            deletedItems.append(items[indexPath.row])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func getTotalBalance() {
        totalBalance = 0.0
        for item in items {
            totalBalance += item.value
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
        item.sendsNotification.toggle()
        
        //        guard let context = self.context else {
        //            return
        //        }
        
        //        do {
        //            try context.save()
        //        } catch {
        //            print(error.localizedDescription)
        //            return
        //        }
    }
}

extension PlanningDetailViewController: ItemDelegate {
    func updateItem() {
        tableView.reloadData()
    }
}

extension PlanningDetailViewController: PlanningEditionDelegate {
    func didChangePlanningName(name: String) {
        templateName = name
    }
    
    func didChangePlanningDescription(description: String) {
        templateDescription = description
    }
}

extension PlanningDetailViewController {
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
                  assertionFailure("Not able to open App privacy settings")
                  return
              }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

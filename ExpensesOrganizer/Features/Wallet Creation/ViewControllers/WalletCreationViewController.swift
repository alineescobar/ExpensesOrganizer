//
//  WalletCreationViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 26/10/21.
//

import UIKit

enum WalletCreationCategory: CaseIterable {
    case currency, description, planning
    
    static var allCases: [WalletCreationCategory] {
        return [.currency, .description, .planning]
//        TODO: create logic behind the transactions cells.
    }
}

class WalletCreationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var readyButton: UIButton!
    private let walletCreationCategories: [WalletCreationCategory] = WalletCreationCategory.allCases
    
    @IBAction private func readyAction(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WalletCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let walletCreationCategory = walletCreationCategories[indexPath.row]
        
        switch walletCreationCategory {
        case .currency:
            return 81
        case .description:
            return 200
        case .planning:
            return 121
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let walletCreationCategory = walletCreationCategories[indexPath.row]
//
//        switch walletCreationCategory {
//        case .currency:
//
//            let magnitude: Double = isShowingGraphics ? 1 : -1
//            let height: Double = 150.0
//            let heightOffset: Double = magnitude * height
//            var indexPathToReload = indexPath
//            indexPathToReload.row += 1
//            UIView.animate(withDuration: isShowingGraphics ? 0.1 : 0.3) {
//                self.backgroundViewHeightConstraint.constant += heightOffset
//                self.initialBackgroundViewHeight += heightOffset
//                self.view.layoutIfNeeded()
//            }
//            mainTableView.reloadRows(at: [indexPath], with: .automatic)
//            mainTableView.reloadRows(at: [indexPathToReload], with: .automatic)
//
//        case .actionableCell:
//            performSegue(withIdentifier: "transactions", sender: nil)
//
//        default:
//            break
//        }
//    }
}

extension WalletCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletCreationCategory = walletCreationCategories[indexPath.row]
        
        switch walletCreationCategory {
        case .currency:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
            
        case .planning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planningCell", for: indexPath) as? PlanningTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletCreationCategories.count
    }
    
}

//
//  ViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 15/10/21.
//

import UIKit

enum DashboardCategory: CaseIterable {
    case profile, balance, graphics, buttons, wallets, actionableCell, transaction(transaction: Transaction)
    
    static var allCases: [DashboardCategory] {
        return [.profile, .balance, .graphics, .buttons, .wallets, .actionableCell]
    }
}

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    private var isShowingGraphics: Bool = false
    private var isShowingBalance: Bool = false
    private let dashboardCategories: [DashboardCategory] = DashboardCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dashboardCategory = dashboardCategories[indexPath.row]
        
        switch dashboardCategory {
        case .graphics:
            return isShowingGraphics ? 150 : 0

        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            isShowingGraphics = !isShowingGraphics
            mainTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dashboardCategory = dashboardCategories[indexPath.row]
        
        switch dashboardCategory {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell
            else {
                return UITableViewCell()
            }
            cell.nameLabel.text = "Hi, Aline"
            cell.dateLabel.text = "18 Out 2021"
            return cell
            
        case .balance:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell", for: indexPath) as? BalanceTableViewCell
            else {
                return UITableViewCell()
            }
            cell.balanceDelegate = self
            cell.showGraphicsButton.setImage(isShowingGraphics ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"), for: .normal)
            cell.hideBalanceButton.setImage(isShowingBalance ? UIImage(systemName: "eye") : UIImage(systemName: "eyebrow"), for: .normal)
            cell.currencyLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceRoundedLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceDecimalLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceStackView.backgroundColor = isShowingBalance ? UIColor.clear : UIColor.lightGray
            return cell
            
        case .graphics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "graphicsCell", for: indexPath) as? GraphicsTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
            
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as? ButtonsTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
                        
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardCategories.count
    }
    
}

extension DashboardViewController: BalanceCellDelegate {
    func didTapBalanceButton() {
        isShowingBalance = !isShowingBalance
        mainTableView.reloadData()
    }
    
    func didTapGraphicsButton() {
        isShowingGraphics = !isShowingGraphics
        backgroundViewHeightConstraint.constant = isShowingGraphics ? 549 : 399
        mainTableView.reloadData()
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem ?? UIView(),
                                  attribute: self.firstAttribute,
                                  relatedBy: self.relation,
                                  toItem: self.secondItem,
                                  attribute: self.secondAttribute,
                                  multiplier: multiplier,
                                  constant: self.constant)
    }
}

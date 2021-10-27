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
        return [.profile, .balance, .graphics, .buttons, .wallets, .actionableCell, .transaction(transaction: Transaction())]
    }
}

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    private let customCellId = "TransactionCell"
    private let graphicsCellId = "GraphicsTableViewCell"
    private var isShowingGraphics: Bool = false
    private var isShowingBalance: Bool = false
    private let dashboardCategories: [DashboardCategory] = DashboardCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        mainTableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        mainTableView.register(UINib.init(nibName: graphicsCellId, bundle: nil), forCellReuseIdentifier: graphicsCellId)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = sender as? DashboardSegueCategory else { return }

        switch destination {
        case .wallet:
            let timeToWaterViewController = segue.destination as?
        }

    }
 */
    
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dashboardCategory = dashboardCategories[indexPath.row]
        
        switch dashboardCategory {
        case .graphics:
            return isShowingGraphics ? 150 : 0
        case .wallets:
            return 140
        case .transaction(transaction: Transaction()):
            return 100
        default:
            break
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dashboardCategory = dashboardCategories[indexPath.row]
        
        switch dashboardCategory {
        case .balance:
            isShowingGraphics = !isShowingGraphics
            var indexPathToReload = indexPath
            indexPathToReload.row += 1
            UIView.animate(withDuration: 0.3) {
                self.backgroundViewHeightConstraint.constant = self.isShowingGraphics ? 549 : 399
                self.view.layoutIfNeeded()
            }
            mainTableView.reloadRows(at: [indexPath], with: .automatic)
            mainTableView.reloadRows(at: [indexPathToReload], with: .automatic)
        
        default:
            break
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
            cell.nameLabel.text = NSLocalizedString("GreetingsLabel", comment: "") + "Aline"
            return cell
            
        case .balance:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell", for: indexPath) as? BalanceTableViewCell
            else {
                return UITableViewCell()
            }
            cell.balanceDelegate = self
            cell.currencyLabel.text = Locale.current.localizedCurrencySymbol(forCurrencyCode: Locale.current.currencyCode ?? "R$")
            cell.showGraphicsImage.image = isShowingGraphics ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
            cell.hideBalanceButton.setImage(isShowingBalance ? UIImage(systemName: "eye") : UIImage(systemName: "eyebrow"), for: .normal)
            cell.currencyLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceRoundedLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceDecimalLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceStackView.backgroundColor = isShowingBalance ? UIColor.clear : UIColor.lightGray
            // TODO: Set balance value based on user's Locale
            // balance = ...
            return cell
            
        case .graphics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: graphicsCellId, for: indexPath) as? GraphicsTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
            
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as? ButtonsTableViewCell
            else {
                return UITableViewCell()
            }
            cell.buttonsDelegate = self
            
            return cell
        
        case .wallets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "walletsCell", for: indexPath) as? WalletsTableViewCell
            else {
                return UITableViewCell()
            }
            cell.walletsDelegate = self
            return cell

        case .transaction(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
                return UITableViewCell()
            }
            
            cell.layer.backgroundColor = UIColor.green.cgColor
            cell.transactionName.text = "Netflix"
            cell.transactionTag.text = "Assinatura"
            cell.transactionDate.text = "20 out"
            cell.transactionPrice.text = "-9,50"
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dashboardCategories.count)
        return dashboardCategories.count
    }
    
}

extension DashboardViewController: BalanceCellDelegate {
    func didTapBalanceButton() {
        isShowingBalance = !isShowingBalance
        mainTableView.reloadData()
    }
}

extension DashboardViewController: ButtonsCellDelegate {
    func didTapWalletButton() {
        performSegue(withIdentifier: "wallets", sender: nil)
    }
    
    func didTapGoalsButton() {
        performSegue(withIdentifier: "goals", sender: nil)
    }
    
    func didTapPlanningButton() {
        performSegue(withIdentifier: "plannings", sender: nil)
    }
    
    func didTapAddButton() {
        performSegue(withIdentifier: "add", sender: nil)
    }
}

extension DashboardViewController: WalletsCellDelegate {
    func didTapWallet(index: Int) {
        // TODO: Put Wallet object on sender (through its index)
        performSegue(withIdentifier: "walletDetail", sender: nil)
    }
    
    func didTapAddWallet() {
        performSegue(withIdentifier: "addWallet", sender: nil)
    }
}

//
//  ViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 15/10/21.
//

import Charts
import CoreData
import UIKit

enum DashboardCategory: CaseIterable {
    case profile, balance, graphics, buttons, wallets, actionableCell
    
    static var allCases: [DashboardCategory] {
        return [.profile, .balance, .graphics, .buttons, .wallets, .actionableCell]
    }
}

class DashboardViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    private var initialBackgroundViewHeight: Double = -1
    private let customCellId = "TransactionCell"
    private let graphicsCellId = "GraphicsTableViewCell"
    private let customCellHeader = "TransactionsHeaderCell"
    private let transactionsEmptyState = "TransactionEmptyStateTableViewCell"
    private var isShowingGraphics: Bool = false
    private var isShowingBalance: Bool = false
    private var isStatsBarHidden: Bool = false
    
    private let dashboardCategories: [DashboardCategory] = DashboardCategory.allCases
    private var transactions: [Transaction] = []
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var wallets: [Wallet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        setNeedsStatusBarAppearanceUpdate()
        
        mainTableView.register(UINib(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        mainTableView.register(UINib(nibName: customCellHeader, bundle: nil), forCellReuseIdentifier: customCellHeader)
        mainTableView.register(UINib(nibName: transactionsEmptyState, bundle: nil), forCellReuseIdentifier: transactionsEmptyState)
        initialBackgroundViewHeight = backgroundViewHeightConstraint.constant
        mainTableView.register(UINib(nibName: graphicsCellId, bundle: nil), forCellReuseIdentifier: graphicsCellId)
        
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>

            let statePredicate = NSPredicate(format: "wasDeleted == %@", NSNumber(value: false))
            
            request.predicate = statePredicate
            
            transactions = try context.fetch(request).reversed()
        } catch {
            print("erro ao carregar")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatsBarHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "add" {
            let additionViewController = segue.destination as? AdditionViewController
            additionViewController?.modalHandlerDelegate = self
            return
        }
        if segue.identifier == "wallets" {
            let walletsViewController = segue.destination as? WalletsViewController
            walletsViewController?.modalHandlerDelegate = self
            return
        }
        
        if segue.identifier == "transactions" {
            let transactionsViewController = segue.destination as? TransactionsViewController
            transactionsViewController?.transactionDelegate = self
            return
        }
        
        guard let index = sender as? Int else {
            let walletCreationViewController = segue.destination as? WalletCreationViewController
            walletCreationViewController?.modalHandlerDelegate = self
            return
        }
        
        let walletDetailViewController = segue.destination as? WalletDetailViewController
        walletDetailViewController?.wallet = wallets[index]
        walletDetailViewController?.modalHandlerDelegate = self
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let dashboardCategory = dashboardCategories[indexPath.row]
            
            switch dashboardCategory {
            case .graphics:
                return isShowingGraphics ? 150 : 0
            case .wallets:
                return 140
            default:
                break
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let dashboardCategory = dashboardCategories[indexPath.row]
            
            switch dashboardCategory {
            case .balance:
                isShowingGraphics.toggle()
                let magnitude: Double = isShowingGraphics ? 1 : -1
                let height: Double = 150.0
                let heightOffset: Double = magnitude * height
                var indexPathToReload = indexPath
                indexPathToReload.row += 1
                UIView.animate(withDuration: isShowingGraphics ? 0.1 : 0.3) {
                    self.backgroundViewHeightConstraint.constant += heightOffset
                    self.initialBackgroundViewHeight += heightOffset
                    self.view.layoutIfNeeded()
                }
                mainTableView.reloadRows(at: [indexPath], with: .automatic)
                mainTableView.reloadRows(at: [indexPathToReload], with: .automatic)
                
            case .actionableCell:
                if !transactions.isEmpty {
                    performSegue(withIdentifier: "transactions", sender: nil)
                }
                
            default:
                break
            }
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let dashboardCategory = dashboardCategories[indexPath.row]
            
            switch dashboardCategory {
            case .profile:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.nameLabel.text = NSLocalizedString("GreetingsLabel", comment: "") + (OnboardingPersistence.getUserName())
                return cell
                
            case .balance:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "balanceCell", for: indexPath) as? BalanceTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.balanceDelegate = self
                cell.showGraphicsImage.image = isShowingGraphics ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
                cell.hideBalanceButton.setImage(isShowingBalance ? UIImage(named: "Eye") : UIImage(named: "EyeClosed"), for: .normal)
                
                cell.balanceLabel.alpha = isShowingBalance ? 1 : 0
                cell.balanceStackView.setBackgroundColor(color: isShowingBalance ? UIColor.clear : UIColor.white.withAlphaComponent(0.5))
                cell.balanceStackView.layer.cornerRadius = 4
                
                var balance = 0.0
                for wallet in wallets {
                    balance += wallet.value
                }
                cell.balanceLabel.attributedText = getFormattedBalance(balance: balance, smallTextSize: 13.6, type: .screen)
                
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
                cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
                cell.fetchWallets()
                cell.walletsCollectionView.reloadData()
                return cell
                
            case .actionableCell:
                guard let cell = mainTableView.dequeueReusableCell(withIdentifier: customCellHeader, for: indexPath) as? TransactionsHeaderCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
                if transactions.isEmpty {
                    cell.transactionHeaderButton.isHidden = true
                } else {
                    cell.transactionHeaderButton.isHidden = false
                }
                cell.transactionsDelegate = self
                
                return cell
            }
        } else {
            if transactions.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: transactionsEmptyState, for: indexPath) as? TransactionEmptyStateTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
                    return UITableViewCell()
                }
                var date: String
                
                let today = Calendar.current.dateComponents([.day], from: Date())
                let transactionDay = Calendar.current.dateComponents([.day], from: transactions[indexPath.row].transactionDate ?? Date())
                
                if today.day == transactionDay.day {
                    date = transactions[indexPath.row].transactionDate?.shortTime ?? Date().shortTime
                } else {
                    let formatter = DateFormatter()
                    let format = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale.current)
                    formatter.dateFormat = format
                    date = formatter.string(from: transactions[indexPath.row].transactionDate ?? Date())
                }
                
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(named: "GraySuport3StateColor")
                cell.transactionName.text = transactions[indexPath.row].name
                cell.transactionTag.text = transactions[indexPath.row].category?.name ?? NSLocalizedString("Others", comment: "")
                cell.transactionDate.text = date
                cell.transactionPrice.text = transactions[indexPath.row].category?.isExpense ?? false ? "-" + String(format: "%.2f", transactions[indexPath.row].value).currencyInputFormatting() :
                "+" + String(format: "%.2f", transactions[indexPath.row].value).currencyInputFormatting()
                cell.transactionImage.image = UIImage(named: transactions[indexPath.row].category?.templateIconName ?? "Atom")
                return cell
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dashboardCategories.count
        } else {
            return transactions.isEmpty ? 1 : transactions.count
        }
    }
    
}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        isStatsBarHidden = yOffset > 0
        setNeedsStatusBarAppearanceUpdate()
        backgroundViewHeightConstraint.constant = initialBackgroundViewHeight - yOffset
        view.layoutIfNeeded()
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
        performSegue(withIdentifier: "walletDetail", sender: index)
    }
    
    func didTapAddWallet() {
        performSegue(withIdentifier: "addWallet", sender: nil)
    }
}

extension DashboardViewController: TransactionsHeaderDelegate {
    func didTapButton() {
        performSegue(withIdentifier: "transactions", sender: nil)
    }
}

extension DashboardViewController: ModalHandlerDelegate {
    func modalDismissed() {
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>

            let statePredicate = NSPredicate(format: "wasDeleted == %@", NSNumber(value: false))
            
            request.predicate = statePredicate
            
            transactions = try context.fetch(request).reversed()
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        } catch {
            print("error while loading table")
        }
    }
}

extension DashboardViewController: TransactionAttDelegate {
    func reloadTransactions() {
        guard let context = self.context else {
            return
        }
        
        do {
            let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>

            let statePredicate = NSPredicate(format: "wasDeleted == %@", NSNumber(value: false))
            
            request.predicate = statePredicate
            
            transactions = try context.fetch(request).reversed()
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

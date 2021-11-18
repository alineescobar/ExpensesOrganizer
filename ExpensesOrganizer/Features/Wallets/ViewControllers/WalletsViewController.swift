//
//  WalletsViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

enum WalletsCategory: CaseIterable {
    case balance, graphics, wallet, addWallet
    
    static var allCases: [WalletsCategory] {
        return [.balance, .graphics]
    }
}

class WalletsViewController: UIViewController {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @IBOutlet weak var backgroundConstrain: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var walletsTableView: UITableView!
    private let graphicsCellId = "GraphicsTableViewCell"
    private let walletsCategories: [WalletsCategory] = WalletsCategory.allCases
    private var isShowingBalance: Bool = false
    private var initialBackgroundViewHeight: Double = -1
    private var wallets: [Wallet] = []
    private var totalBalance: Double = 0.0
    let navigationFont = UIFont(name: "WorkSans-SemiBold", size: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        initialBackgroundViewHeight = backgroundConstrain.constant
        walletsTableView.register(UINib(nibName: graphicsCellId, bundle: nil), forCellReuseIdentifier: graphicsCellId)
        self.navigationItem.title = "Carteira"
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-SemiBold", size: 20) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white]
        guard let context = self.context else {
            return
        }
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            getTotalBalance()
        } catch {
            showWalletsFetchFailedAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    func showWalletsFetchFailedAlert() {
        let alert = UIAlertController(title: NSLocalizedString("WalletsFetchFailedAlertTitle", comment: ""),
                                      message: NSLocalizedString("WalletsFetchFailedAlertDescription", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
        }))
        
        self.present(alert, animated: true)
    }
    
    func getTotalBalance() {
        totalBalance = 0.0
        for wallet in wallets {
            totalBalance += wallet.value
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let pageCategory = walletsCategories[indexPath.row]
            switch pageCategory {
            case .graphics:
                return 150
            default:
                break
            }
        } else {
            if wallets.isEmpty {
                if indexPath.row == 0 {
                    return 120
                } else {
                    return UITableView.automaticDimension
                }
            }
            if indexPath.row != wallets.count {
                return 120
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(25)
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
            if wallets.isEmpty {
                return
            }
            if indexPath.row != wallets.count {
                self.performSegue(withIdentifier: "walletDetailSegue", sender: indexPath.row)
            }
        }
    }
}

extension WalletsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return walletsCategories.count
        } else {
            return wallets.isEmpty ? 2 : wallets.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let pageCategory = walletsCategories[indexPath.row]
            switch pageCategory {
            case .balance:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceInsideTableViewCellID", for: indexPath) as? BalanceInsideTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.balanceDelegate = self
                cell.currentBalanceButton.setImage(isShowingBalance ? UIImage(named: "Eye") : UIImage(named: "EyeClosed"), for: .normal)
                cell.balanceLabel.alpha = isShowingBalance ? 1 : 0
                cell.stackJustForBalance.setBackgroundColor(color: isShowingBalance ? UIColor.clear : UIColor.white.withAlphaComponent(0.5))
                cell.stackJustForBalance.layer.cornerRadius = 4
                cell.balanceLabel.attributedText = getFormattedBalance(balance: totalBalance, smallTextSize: 13.6, type: .screen)
                cell.selectionStyle = .none
                return cell
            case .graphics:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: graphicsCellId, for: indexPath) as? GraphicsTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            if wallets.isEmpty {
                if indexPath.row == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddWalletInsideTableViewCellID", for: indexPath) as? AddWalletInsideTableViewCell
                    else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletEmptyStateTableViewCellID", for: indexPath) as? WalletEmptyStateTableViewCell
                    else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            }
            
            if indexPath.row == wallets.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddWalletInsideTableViewCellID", for: indexPath) as? AddWalletInsideTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletsInsideTableViewCellID", for: indexPath) as? WalletsInsideTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.walletNameLabel.text = wallets[indexPath.row].name
                cell.balanceInsideLabel.attributedText = getFormattedBalance(balance: wallets[indexPath.row].value, smallTextSize: 13.6, type: .card)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension WalletsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        backgroundConstrain.constant = initialBackgroundViewHeight - yOffset
        view.layoutIfNeeded()
    }
}

extension WalletsViewController: BalanceCellDelegate {
    func didTapBalanceButton() {
        isShowingBalance = !isShowingBalance
        walletsTableView.reloadData()
    }
}

extension WalletsViewController: ModalHandlerDelegate {
    func modalDismissed() {
        guard let context = self.context else {
            return
        }
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            DispatchQueue.main.async {
                self.getTotalBalance()
                self.walletsTableView.reloadData()
            }
        } catch {
            showWalletsFetchFailedAlert()
        }
    }
}

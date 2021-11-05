//
//  WalletsViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

enum WalletsCategory: CaseIterable {
    case balance, graphics, wallets, addWallet
    
    static var allCases: [WalletsCategory] {
        return [.balance, .graphics, .wallets,.wallets,.wallets,.wallets, .addWallet]
//        TODO: create logic behind the transactions cells.
    }
}

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var walletsTableView: UITableView!
    private let graphicsCellId = "GraphicsTableViewCell"
    private let walletsCategories: [WalletsCategory] = WalletsCategory.allCases
    private var isShowingBalance: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        walletsTableView.register(UINib(nibName: graphicsCellId, bundle: nil), forCellReuseIdentifier: graphicsCellId)
        self.navigationItem.title = "Carteira"
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.gray
    }
}

extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let walletsCategory = walletsCategories[indexPath.row]

        switch walletsCategory {
        case .graphics:
            return 250
        case .wallets:
            return 120
        default:
            break
        }
        return UITableView.automaticDimension
    }
}

extension WalletsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        walletsCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletsCategory = walletsCategories[indexPath.row]
        
        switch walletsCategory {
        case .balance:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceInsideTableViewCellID", for: indexPath) as? BalanceInsideTableViewCell
            else {
                return UITableViewCell()
            }
            cell.balanceDelegate = self
            cell.currentBalanceButton.setImage(isShowingBalance ? UIImage(systemName: "eye") : UIImage(systemName: "eyebrow"), for: .normal)
            cell.balanceLabel.alpha = isShowingBalance ? 1 : 0
            cell.balanceLabel.backgroundColor = isShowingBalance ? UIColor.clear : UIColor.lightGray
            let balance = 2234.5
            cell.balanceLabel.attributedText = getFormattedBalance(balance: balance, smallTextSize: 13.6, type: .screen)
            cell.selectionStyle = .none
            return cell
        case .graphics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: graphicsCellId, for: indexPath) as? GraphicsTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
        case .wallets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletsInsideTableViewCellID", for: indexPath) as? WalletsInsideTableViewCell
            else {
                return UITableViewCell()
            }
            let balance = 2234.5
            cell.walletNameLabel.text = "No meu bolso"
            cell.walletsDelegate = self
            cell.balanceInsideLabel.attributedText = getFormattedBalance(balance: balance, smallTextSize: 13.6, type: .screen)
            cell.selectionStyle = .none
            return cell
        case .addWallet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddWalletInsideTableViewCellID", for: indexPath) as? AddWalletInsideTableViewCell
            else {
                return UITableViewCell()
            }
            cell.walletsDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension WalletsViewController: WalletsCellDelegate {
    func didTapWallet(index: Int) {
        // TODO: Put Wallet object on sender (through its index)
        performSegue(withIdentifier: "walletDetail", sender: nil)
    }
    
    func didTapAddWallet() {
        performSegue(withIdentifier: "addWallet", sender: nil)
    }
}

extension WalletsViewController: BalanceCellDelegate {
    func didTapBalanceButton() {
        isShowingBalance = !isShowingBalance
        walletsTableView.reloadData()
    }
}

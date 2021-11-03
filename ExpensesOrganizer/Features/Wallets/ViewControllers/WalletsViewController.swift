//
//  WalletsViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

enum WalletsCategory: CaseIterable {
    case balance, graphics, wallets
    
    static var allCases: [WalletsCategory] {
        return [.balance, .graphics, .wallets]
//        TODO: create logic behind the transactions cells.
    }
}

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var walletsTableView: UITableView!
    private let walletsCategories: [WalletsCategory] = WalletsCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
    }
}

extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let walletsCategory = walletsCategories[indexPath.row]

        switch walletsCategory {
        case .graphics:
            return 240
        case .wallets:
            return 250
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
            return cell
        case .graphics:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GraphicsInsideTableViewCellID", for: indexPath) as? GraphicsInsideTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
        case .wallets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletsListTableViewCellID", for: indexPath) as? WalletsListTableViewCell
            else {
                return UITableViewCell()
            }
            cell.walletsDelegate = self
            return cell
            }
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

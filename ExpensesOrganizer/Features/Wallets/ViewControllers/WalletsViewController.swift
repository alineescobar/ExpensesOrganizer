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
        return [.balance, .graphics]
        //        TODO: create logic behind the transactions cells.
    }
    
    static var walletsCases: [WalletsCategory] {
        return [.wallets,.wallets,.wallets,.wallets,.addWallet]
    }
}

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var backgroundConstrain: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var walletsTableView: UITableView!
    private let graphicsCellId = "GraphicsTableViewCell"
    private let walletsCategories: [WalletsCategory] = WalletsCategory.allCases
    private let numberOfWalletsCategories: [WalletsCategory] = WalletsCategory.walletsCases
    private var isShowingBalance: Bool = false
    private var initialBackgroundViewHeight: Double = -1
    
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
        if indexPath.section == 0 {
            let pageCategory = walletsCategories[indexPath.row]
            switch pageCategory {
            case .graphics:
                return 200
            default:
                break
            }
        } else {
            let walletsCategory = numberOfWalletsCategories[indexPath.row]
            switch walletsCategory {
            case .wallets:
                return 120
            default:
                break
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
            let pageCategory = walletsCategories[indexPath.row]
            switch pageCategory {
            case .balance:
                let height: Double = 150.0
                let heightOffset: Double = -1 * height
                var indexPathToReload = indexPath
                indexPathToReload.row += 1
                UIView.animate(withDuration: 0.1) {
                    self.backgroundConstrain.constant += heightOffset
                    self.initialBackgroundViewHeight += heightOffset
                    self.view.layoutIfNeeded()
                }
                walletsTableView.reloadRows(at: [indexPath], with: .automatic)
                walletsTableView.reloadRows(at: [indexPathToReload], with: .automatic)
            default:
                break
 //           }
//        } else {
//            let walletsCategory = numberOfWalletsCategories[indexPath.row]
//            switch walletsCategory {
//            case .wallets:
//                let height: Double = 150.0
//                let heightOffset: Double = -1 * height
//                var indexPathToReload = indexPath
//                indexPathToReload.row += 1
//                UIView.animate(withDuration: 0.1) {
//                    self.backgroundConstrain.constant += heightOffset
//                    self.initialBackgroundViewHeight += heightOffset
//                    self.view.layoutIfNeeded()
//                }
//                walletsTableView.reloadRows(at: [indexPath], with: .automatic)
//                walletsTableView.reloadRows(at: [indexPathToReload], with: .automatic)
//            default:
//                break
//            }
       }
    }
    }
    
    extension WalletsViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return walletsCategories.count
            } else {
                return numberOfWalletsCategories.count
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
                    cell.currentBalanceButton.setImage(isShowingBalance ? UIImage(systemName: "eye") : UIImage(systemName: "eyebrow"), for: .normal)
                    cell.balanceLabel.alpha = isShowingBalance ? 1 : 0
                    cell.stackJustForBalance.setBackgroundColor(color: isShowingBalance ? UIColor.clear : UIColor.lightGray)
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
                default:
                    return UITableViewCell()
                }
            } else {
                let walletsCategory = numberOfWalletsCategories[indexPath.row]
                switch walletsCategory {
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
                default:
                    return UITableViewCell()
                }
                
            }
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 20
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
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

//
//  ViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 15/10/21.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    private var isShowingGraphics: Bool = false
    private var isShowingBalance: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 51
        } else if indexPath.row == 1 {
            return 130
        } else if indexPath.row == 2 {
            return isShowingGraphics ? 150 : 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            isShowingGraphics = !isShowingGraphics
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell
            else {
                return UITableViewCell()
            }
            cell.nameLabel.text = "Hi, Aline"
            cell.dateLabel.text = "18 Out 2021"
            return cell
        } else if indexPath.row == 1 {
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
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "graphicsCell", for: indexPath) as? GraphicsTableViewCell
            else {
                return UITableViewCell()
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension DashboardViewController: BalanceCellDelegate {
    func didTapBalanceButton() {
        isShowingBalance = !isShowingBalance
        mainTableView.reloadData()
    }
    
    func didTapGraphicsButton() {
        isShowingGraphics = !isShowingGraphics
        let newConstraint = backgroundViewHeightConstraint.constraintWithMultiplier(isShowingGraphics ? 0.65 : 0.48)
        view.removeConstraint(backgroundViewHeightConstraint)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        backgroundViewHeightConstraint = newConstraint
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

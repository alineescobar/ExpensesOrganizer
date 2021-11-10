//
//  AddExpensePaymentTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddExpensePaymentCell: UITableViewCell {
    static var identifier: String = "add-expense-payment-cell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("addition-expense-wallet", comment: "")
        // selectionLabel.text = NSLocalizedString("", comment: "")
        
        contentStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        contentStack.isLayoutMarginsRelativeArrangement = true
    }
}

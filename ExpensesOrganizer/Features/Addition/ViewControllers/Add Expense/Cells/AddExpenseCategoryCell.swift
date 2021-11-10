//
//  AddExpenseCategoryTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

class AddExpenseCategoryCell: UITableViewCell {
    static var identifier: String = "add-expense-category-cell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var selectionStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("addition-expense-category", comment: "")
        // selectionLabel.text = NSLocalizedString("", comment: "")
        
        selectionStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        selectionStack.isLayoutMarginsRelativeArrangement = true
    }
}

//
//  AddIncomeCategoryCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 03/11/21.
//

import UIKit

protocol CollectionDelegate: AnyObject {
    func openCollection()
}

class AddIncomeCategoryCell: UITableViewCell {
    static let identifier: String = "add-income-category-cell"
    weak var planningDelegate: CollectionDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("addition-expense-category", comment: "")
        // selectionLabel.text = NSLocalizedString("", comment: "")
        
        categoryStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        setTapGesture()
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openTable(_:)))
        categoryStackView.addGestureRecognizer(tapGesture)
    }

    @objc
    func openTable(_ sender: UITapGestureRecognizer) {
        planningDelegate?.openCollection()
    }
}

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

    @IBOutlet weak var categoryStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTapGesture()
    }
    
    func setTapGesture() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openTable(_:)))
        categoryStackView.addGestureRecognizer(tapGesture)
    }

    @objc func openTable(_ sender: UITapGestureRecognizer) {
        planningDelegate?.openCollection()
    }
}

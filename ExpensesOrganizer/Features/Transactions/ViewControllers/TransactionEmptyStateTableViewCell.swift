//
//  TransactionEmptyStateTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 23/11/21.
//

import UIKit

class TransactionEmptyStateTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateDescription: UILabel!
    @IBOutlet weak var emptyStateTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyStateImage.image = UIImage(named: "SmileyMeh")
        emptyStateTitle.text = NSLocalizedString("EmptyStateTransactionsTitle", comment: "")
        emptyStateDescription.text = NSLocalizedString("EmptyStateTransactionsDescription", comment: "")
        
        background.layer.cornerRadius = 8
        background.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

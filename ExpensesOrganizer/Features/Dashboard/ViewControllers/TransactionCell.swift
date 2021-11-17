//
//  TransactionCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 25/10/21.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionTag: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.makeShadow(color: UIColor.black, width: 1, height: 2, radius: 2, opacity: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

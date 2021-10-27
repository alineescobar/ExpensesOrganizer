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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  RecurrencyTypeTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 04/11/21.
//

import UIKit

class RecurrencyTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var recurrencyTypeLabel: UILabel!
    @IBOutlet weak var recurrencyTypeCheckImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

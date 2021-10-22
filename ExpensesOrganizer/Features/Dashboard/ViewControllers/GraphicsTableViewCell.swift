//
//  GraphicsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 21/10/21.
//

import UIKit

class GraphicsTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

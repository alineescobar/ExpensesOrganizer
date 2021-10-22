//
//  ButtonsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 21/10/21.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var walletStackView: UIStackView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var goalsStackView: UIStackView!
    @IBOutlet weak var goalsView: UIView!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var planningStackView: UIStackView!
    @IBOutlet weak var planningView: UIView!
    @IBOutlet weak var planningLabel: UILabel!
    @IBOutlet weak var addStackView: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        walletLabel.adjustsFontSizeToFitWidth = true
        walletLabel.minimumScaleFactor = 0.2
        
        goalsLabel.adjustsFontSizeToFitWidth = true
        goalsLabel.minimumScaleFactor = 0.2
        
        planningLabel.adjustsFontSizeToFitWidth = true
        planningLabel.minimumScaleFactor = 0.2
        
        addLabel.adjustsFontSizeToFitWidth = true
        addLabel.minimumScaleFactor = 0.2
        
       // contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        walletView.layer.cornerRadius = walletLabel.frame.size.width / 2
        goalsView.layer.cornerRadius = walletLabel.frame.size.width / 2
        planningView.layer.cornerRadius = walletLabel.frame.size.width / 2
        
        addView.layer.cornerRadius = walletLabel.frame.size.width / 2
        walletView.layer.shadowColor = UIColor.black.cgColor
        walletView.layer.shadowOffset = CGSize(width: 1, height: 2)
        walletView.layer.shadowRadius = 2
        walletView.layer.shadowOpacity = 0.2
        
        goalsView.layer.shadowColor = UIColor.black.cgColor
        goalsView.layer.shadowOffset = CGSize(width: 1, height: 2)
        goalsView.layer.shadowRadius = 2
        goalsView.layer.shadowOpacity = 0.2
        
        planningView.layer.shadowColor = UIColor.black.cgColor
        planningView.layer.shadowOffset = CGSize(width: 1, height: 2)
        planningView.layer.shadowRadius = 2
        planningView.layer.shadowOpacity = 0.2
        
        addView.layer.shadowColor = UIColor.black.cgColor
        addView.layer.shadowOffset = CGSize(width: 1, height: 2)
        addView.layer.shadowRadius = 2
        addView.layer.shadowOpacity = 0.2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

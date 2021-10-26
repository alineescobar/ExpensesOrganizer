//
//  ProfileTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 20/10/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBAction private func profileAction(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        dateLabel.text = formatter.string(from: Date())
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

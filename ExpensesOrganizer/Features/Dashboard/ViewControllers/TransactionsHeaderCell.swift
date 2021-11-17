//
//  TransactionsHeaderCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 26/10/21.
//

import UIKit

class TransactionsHeaderCell: UITableViewCell {
    
    @IBAction private func transactionHeaderAction(_ sender: UIButton) {
        transactionsDelegate?.didTapButton()
    }
    
    @IBOutlet weak var transactionsHeaderLabel: UILabel!
    @IBOutlet weak var transactionHeaderButton: UIButton!
    weak var transactionsDelegate: TransactionsHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: Transaction Button Visuals
        transactionHeaderButton.layer.backgroundColor = UIColor.white.cgColor
        transactionHeaderButton.layer.cornerRadius = 16
        transactionHeaderButton.layer.borderWidth = 0.5
        transactionHeaderButton.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.776, alpha: 1).cgColor
        
        // MARK: Transaction Header Localization
        transactionsHeaderLabel.text = NSLocalizedString("TransactionsHeader", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol TransactionsHeaderDelegate: AnyObject {
    func didTapButton()
}

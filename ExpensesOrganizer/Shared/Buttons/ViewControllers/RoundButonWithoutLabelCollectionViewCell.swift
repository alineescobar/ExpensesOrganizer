//
//  RoundButonWithoutLabelCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 12/11/21.
//

import UIKit

class RoundButonWithoutLabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    private let imageName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = background.frame.size.width / 2
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowRadius = 2
        background.layer.shadowOpacity = 0.2
        background.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        iconImage.image = UIImage(named: imageName)
    }

}

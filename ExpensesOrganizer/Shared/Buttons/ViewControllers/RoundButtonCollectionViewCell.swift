//
//  RoundButtonCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 05/11/21.
//

import UIKit

class RoundButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
//    private let imageName: String = "house-icon"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = background.frame.size.width / 2
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowRadius = 1
        background.layer.shadowOpacity = 0.2
        background.layer.shadowOffset = CGSize(width: 1, height: 2)
        categoryImage.image = UIImage(named: "house-icon")
    }

}

//
//  OnboardingCollectionViewCell.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 10/11/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    func setup(_ slide:OnboardingSlide) {
            slideImage.image = slide.image
            titleLabel.text = slide.title
            descriptionLabel.text = slide.description
    }
    
    override func awakeFromNib() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = gradientView.bounds
//        gradientLayer.colors = [
//            UIColor.clear,
//            UIColor.white.cgColor
//        ]
//        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
}

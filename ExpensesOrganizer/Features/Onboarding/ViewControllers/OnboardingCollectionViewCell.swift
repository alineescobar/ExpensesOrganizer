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
    
    func setup(_ slide:OnboardingSlide) {
        slideImage.image = slide.image
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
    }
}

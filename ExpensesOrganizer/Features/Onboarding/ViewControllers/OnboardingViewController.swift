//
//  OnboardingViewController.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 10/11/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nextButton.layer.cornerRadius = 8
        
        guard let image1 = UIImage(named: "Onboarding-6") else {
            return }
        guard let image2 = UIImage(named: "Onboarding-4") else {
            return }
        guard let image3 = UIImage(named: "Onboarding") else {
            return }

        slides = [
            OnboardingSlide(title: NSLocalizedString("Control", comment: ""), description: NSLocalizedString("ControlDescription", comment: ""), image: image1),
            OnboardingSlide(title: NSLocalizedString("Plan", comment: ""), description: NSLocalizedString("PlanDescription", comment: ""), image: image2),
            OnboardingSlide(title: NSLocalizedString("Save", comment: ""), description: NSLocalizedString("SaveDescription", comment: ""), image: image3)
        ]
        nextButton.setTitle(NSLocalizedString("NextButton", comment: ""), for: .normal)
    }
    
    @IBAction private func nextButtonAction(_ sender: UIButton) {
        if currentPage == 2 {
            performSegue(withIdentifier: "onboarding-done", sender: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCellID", for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

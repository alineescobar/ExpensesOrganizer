//
//  OnboardingViewController.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 10/11/21.
//

import UIKit

class OnboardingViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
         didSet {
             pageControl.currentPage = currentPage
             if currentPage == slides.count - 1 {
                 nextButton.setTitle("Get Started", for: .normal)
             } else {
                 nextButton.setTitle("Next", for: .normal)
             }
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        slides = [
            OnboardingSlide(title: "controle", description: "Aqui voce pode controlar seus gastos registrando cada entrada e saida de valores.", image: UIImage(named:"Onboarding-4")!),
            OnboardingSlide(title: "planeje", description: "Nunca foi tão facil se planejar, aqui voce pode adicionar seus próprios itens em diferentes planejamentos e aproveitar os nossos prontos também!", image: UIImage(named:"Onboarding-7")!),
            OnboardingSlide(title: "economize", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Convallis vestibulum augue massa sed aenean.", image: UIImage(named:"Onboarding")!)
        ]
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
                    let controller = storyboard?.instantiateViewController(identifier: "HomeNC") as! UINavigationController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .flipHorizontal
                    UserDefaults.standard.hasOnboarded = true
                    present(controller, animated: true, completion: nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCellID", for: indexPath) as! OnboardingCollectionViewCell
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

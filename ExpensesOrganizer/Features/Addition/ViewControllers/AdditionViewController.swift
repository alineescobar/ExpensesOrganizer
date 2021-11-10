//
//  AdditionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

class AdditionViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitle(NSLocalizedString("addition-expense-segmented-title", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("addition-income-segmented-title", comment: ""), forSegmentAt: 1)
        
        let font: Any = UIFont(name: "WorkSans-Medium", size: 14) as Any
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

    }
    
    @IBAction private func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            firstView.isHidden = true
            secondView.isHidden = false
        } else {
            firstView.isHidden = false
            secondView.isHidden = true
        }
    }
}

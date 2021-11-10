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

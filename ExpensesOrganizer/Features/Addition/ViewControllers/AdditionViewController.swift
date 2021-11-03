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

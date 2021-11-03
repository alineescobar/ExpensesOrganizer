//
//  AdditionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

class AdditionViewController: UIViewController {
    @IBOutlet weak var viewContainer: UIView!
    var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        views = []
        views.append(AddExpenseTableViewController().view)
        views.append(AddIncomeTableViewController().view)
        
        for view in views {
            viewContainer.addSubview(view)
        }
        
        viewContainer.bringSubviewToFront(views[0])
    }

    @IBAction private func switchViewAction(_ sender: UISegmentedControl) {
        viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
}

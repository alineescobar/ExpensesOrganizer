//
//  AddExpenseAllDoneViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddExpenseAllDoneViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.layer.cornerRadius = 8
        doneButton.setTitle(NSLocalizedString("OKConfirmation", comment: ""), for: .normal)
        
        titleLabel.text = NSLocalizedString("addition-expense-done-header", comment: "")
        bodyLabel.text = NSLocalizedString("addition-expense-done-body", comment: "")
        
        if let pvc = navigationController?.parent as? AdditionViewController {
            pvc.segmentedControl.isHidden = true
        }
    }
    
    @IBAction private func doneAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

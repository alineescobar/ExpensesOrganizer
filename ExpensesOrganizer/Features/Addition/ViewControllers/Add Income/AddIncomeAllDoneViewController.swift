//
//  AddIncomeAllDoneViewController.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 05/11/21.
//

import UIKit

class AddIncomeAllDoneViewController: UIViewController {

    @IBOutlet private weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.layer.cornerRadius = 8
    }
    
    @IBAction private func doneAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//
//  LastOnboardingScreenViewController.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 11/11/21.
//

import UIKit

class LastOnboardingScreenViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var insertNameField: UITextField!
    @IBOutlet weak var readyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("LetsGo", comment: "")
        descriptionLabel.text = NSLocalizedString("LetsGoDescription", comment: "")
        nameLabel.text = NSLocalizedString("Name", comment: "")
//        insertNameField.text = NSLocalizedString("FieldDescription", comment: "")
        readyButton.setTitle(NSLocalizedString("DoneButton", comment: ""), for: .normal)
        readyButton.layer.cornerRadius = 8
        insertNameField.placeholder = NSLocalizedString("FieldDescription", comment: "")
        insertNameField.delegate = self
        hideKeyboardWhenTappedAround()
    }

    @IBAction private func readyButtonAction(_ sender: UIButton) {
        OnboardingPersistence.setUserName(insertNameField.text ?? "[user]")
        OnboardingPersistence.setOnboardingCompleted(true)

        performSegue(withIdentifier: "dashboardSegue", sender: nil)
        
    }
}

extension LastOnboardingScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension LastOnboardingScreenViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  LastOnboardingScreenViewController.swift
//  ExpensesOrganizer
//
//  Created by Julia Alberti Maia on 11/11/21.
//

import UIKit

class LastOnboardingScreenViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var insertNameField: UITextField!
    @IBOutlet weak var readyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
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
        
        guard let context = self.context else {
            performSegue(withIdentifier: "dashboardSegue", sender: nil)
            return
        }
        
        setPropertyTemplate(context: context)
        setCarTemplate(context: context)
        setLeisureTemplate(context: context)
        setStudyTemplate(context: context)
        setBusinessTemplate(context: context)
        setPetsTemplate(context: context)
        setEmptyExpenseTemplate(context: context)
        setSalaryTemplate(context: context)
        setProfitTemplate(context: context)
        setEmptyIncomeTemplate(context: context)
        
        do {
            try context.save()
            performSegue(withIdentifier: "dashboardSegue", sender: nil)
        } catch {
            return
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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

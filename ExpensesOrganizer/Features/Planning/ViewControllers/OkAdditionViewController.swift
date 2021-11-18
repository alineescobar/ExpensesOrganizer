//
//  OkAdditionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 18/11/21.
//

import UIKit

class OkAdditionViewController: UIViewController {
    weak var modalHandlerDelegate: ModalHandlerDelegate?
    var allDoneText: String = ""
    var allDoneDescriptionText: String = ""
    @IBOutlet weak var allDoneLabel: UILabel!
    @IBOutlet weak var allDoneDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var readyButton: UIButton!
    
    @IBAction private func readyAction(_ sender: UIButton) {
        modalHandlerDelegate?.modalDismissed()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allDoneLabel.text = allDoneText
        allDoneDescription.text = allDoneDescriptionText
        readyButton.setTitle(NSLocalizedString("OKConfirmation", comment: ""), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

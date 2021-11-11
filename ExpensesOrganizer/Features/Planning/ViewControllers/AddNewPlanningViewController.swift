//
//  AddNewPlanningViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 10/11/21.
//

import UIKit

class AddNewPlanningViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Navigation Visuals
        self.navigationItem.title = NSLocalizedString("AddPlanningTitle", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 20) as Any]
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withInsets(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 0))
        
        // MARK: Segmented Control
        segmentedControl.setTitle(NSLocalizedString("FirstSegmentedControl", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("SecondSegmentedControl", comment: ""), forSegmentAt: 1)
        let fontNormal = UIFont(name: "WorkSans-Regular", size: 14)
        let fontBold = UIFont(name: "WorkSans-SemiBold", size: 14)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontNormal as Any], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: fontBold as Any], for: .selected)
        
        // MARK: Cancel button
        cancelButton.layer.cornerRadius = 19
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        // MARK: Done button
        doneButton.layer.cornerRadius = 19
        doneButton.layer.borderWidth = 2
        doneButton.layer.backgroundColor = UIColor.black.cgColor
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        doneButton.tintColor = .white
    }

}

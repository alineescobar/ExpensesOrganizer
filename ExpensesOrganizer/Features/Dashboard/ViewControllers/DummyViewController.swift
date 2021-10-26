//
//  DummyViewController.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 25/10/21.
//

import UIKit

class DummyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewDummy: UITableView!
    private let customCellId = "TransactionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDummy.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableViewDummy.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewDummy.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        cell.transactionName.text = "Netflix"
        cell.transactionTag.text = "Assinatura"
        cell.transactionDate.text = "20 out"
        cell.transactionPrice.text = "-9,50"
        
        return cell
    }
    
}

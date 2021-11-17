//
//  AdditionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import CoreData
import UIKit

class AdditionViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitle(NSLocalizedString("addition-expense-segmented-title", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("addition-income-segmented-title", comment: ""), forSegmentAt: 1)
        
        let font: Any = UIFont(name: "WorkSans-Medium", size: 14) as Any
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                                 NSAttributedString.Key.foregroundColor: UIColor(named: "TertiaryBrandColor") as Any], for: .normal)
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

    // swiftlint:disable force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    func fetchItem(name: String) -> Item? {
        do {
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "name == %@", name)
            
            request.predicate = predicate

            let item = try context.fetch(request)
            return item.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchTemplate(name: String) -> Template? {
        do {
            let request = Template.fetchRequest() as NSFetchRequest<Template>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "name == %@", name)
            
            request.predicate = predicate

            let template = try context.fetch(request)
            return template.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //    swiftlint:disable function_parameter_count
    func createItem(name: String, value: Double, recurrence: Int16, template: Template?, itemID: UUID, recurrenceDate: Date) {
        let newItem = Item(context: context)
        newItem.name = name
        newItem.value = value
        newItem.recurrence = recurrence
        newItem.template = template
        newItem.itemID = itemID
        newItem.itemRecurrenceDate = recurrenceDate
        template?.addToItems(newItem)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    // swiftlint: enable function_parameter_count
    func createTemplate(name: String, templateDescription: String?, item: Item?, templateID: UUID) {
        let newTemplate = Template(context: context)
        newTemplate.name = name
        newTemplate.templateDescription = templateDescription
        newTemplate.templateID = templateID
        if let item = item {
            newTemplate.addToItems(item)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createTransaction(destination: UUID, value: Double, origem: UUID?) {
        let newTransaction = Transaction(context: context)
        newTransaction.destination = destination
        newTransaction.value = value
        newTransaction.origem = origem
        newTransaction.transactionDate = Date()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

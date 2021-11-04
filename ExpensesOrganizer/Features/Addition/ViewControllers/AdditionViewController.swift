//
//  AdditionViewController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import CoreData
import UIKit

class AdditionViewController: UIViewController {
    //    swiftlint:disable force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchItem(name: String) -> Item? {
        do {
            let request = Item.fetchRequest() as NSFetchRequest<Item>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "name == %@")
            
            request.predicate = predicate

            let item = try context.fetch(request)
            return item.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchCategory(name: String) -> Template? {
        do {
            let request = Template.fetchRequest() as NSFetchRequest<Template>
            request.fetchLimit = 1
            
            let predicate = NSPredicate(format: "name == %@")
            
            request.predicate = predicate

            let category = try context.fetch(request)
            return category.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func createItem(name: String, value: Double, recurrence: Bool, category: Template?, itemID: UUID) {
        let newItem = Item(context: context)
        newItem.name = name
        newItem.value = value
        newItem.recurrence = recurrence
        newItem.template = category
        newItem.itemID = itemID
        do {
            try context.save()
        } catch {
            print("saving failed")
            print(error.localizedDescription)
        }
    }
    
    func createTemplate(name: String, templateDescription: String?, item: Item?, templateID: UUID) {
        let newTemplate = Template(context: context)
        newTemplate.name = name
        newTemplate.templateDescription = templateDescription
        newTemplate.templateID = templateID
        newTemplate.items?.adding(item as Any)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
//    swiftlint:enable force_cast

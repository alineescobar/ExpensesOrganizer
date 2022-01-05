//
//  SceneDelegate.swift
//  ExpensesOrganizer
//
//  Created by Aline Osana Escobar on 15/10/21.
//

import CoreData
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if OnboardingPersistence.getOnboardingCompleted() {
            let storyboard = UIStoryboard(name: "Dashboard", bundle: .main)
            window.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            UserDefaults.standard.set(Date(), forKey: "lastOpeningDate")
            let storyboard = UIStoryboard(name: "Onboarding", bundle: .main)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
        
        let lastOpeningDate = UserDefaults.standard.object(forKey: "lastOpeningDate") as! Date
        let lastOpeningDay = Calendar.current.dateComponents([.day, .month, .year], from: lastOpeningDate).day ?? 0
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date()).day ?? 0
        
        if lastOpeningDay < today {
            UserDefaults.standard.set(Date(), forKey: "lastOpeningDate")
            let recurrence: Recurrence = Recurrence()
            var templates: [Template] = []
            var wallets: [Wallet] = []
            var alertMessages: [String] = []
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            guard let context = context else {
                return
            }
            
            //            if UserDefaults.standard.bool(forKey: "firstTimeOpenTheAppToday") == false {
            var items: [Item] = []
            do {
                let templatesRequest = Template.fetchRequest() as NSFetchRequest<Template>
                templates = try context.fetch(templatesRequest)
                
                let walletsRequest = Wallet.fetchRequest() as NSFetchRequest<Wallet>
                wallets = try context.fetch(walletsRequest)
            } catch {
                print("caiu no erro")
            }
            
            for template in templates {
                items = template.items?.array as? [Item] ?? []
                
                for item in items {
                    //                    guard let itemsTemplate = items.template else { return }
                    guard let walletItem = item.paymentMethod else { continue }
                    if template.isExpense { //ver se é decrementar ou incrementar na carteira, isExpense
                        if !(recurrence.recurrenceCounterDec(recurrenceType: RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never, transactionDate: item.recurrenceDate ?? Date(), wallet: walletItem, item: item)) {
                            let transactionName: String = NSLocalizedString("InsufficientBalanceAlertDescriptionDetailed1", comment: "") + (item.name ?? NSLocalizedString("NoName", comment: ""))
                            let transactionValue: String = NSLocalizedString("InsufficientBalanceAlertDescriptionDetailed2", comment: "") + String(format: "%.2f", item.value).currencyInputFormatting()
                            let walletValue: String = NSLocalizedString("InsufficientBalanceAlertDescriptionDetailed3", comment: "") + String(format: "%.2f", walletItem.value).currencyInputFormatting() + NSLocalizedString("InsufficientBalanceAlertDescriptionDetailed4", comment: "") + String(walletItem.name ?? NSLocalizedString("NoName", comment: "")) + "\"."
                            let alertMessage: String = transactionName + transactionValue + walletValue
                            alertMessages.append(alertMessage)
                        }
                    } else {
                        recurrence.recurrenceCounterInc(recurrenceType: RecurrencyTypes(rawValue: item.recurrenceType ?? "Never") ?? .never, transactionDate: item.recurrenceDate ?? Date(), wallet: walletItem, item: item)
                    }
                }
            }
            
            for wallet in wallets {
                if RecurrencyTypes(rawValue: wallet.recurrencyType ?? "Never") ?? .never != .never {
                    recurrence.recurrenceCounterIncWallets(recurrenceType: RecurrencyTypes(rawValue: wallet.recurrencyType ?? "Never") ?? .never, transactionDate: wallet.recurrenceDate ?? Date(), wallet: wallet)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("erro")
                return
            }
            
            showAlert(receivedMessages: alertMessages)
        }
    }
    
    private func showAlert(receivedMessages: [String]) {
        var messages = receivedMessages
        guard messages.count > 0 else { return }
        
        let message = messages.first
        
        func removeAndShowNextMessage() {
            messages.removeFirst()
            showAlert(receivedMessages: messages)
        }
        
        let alert = UIAlertController(title: NSLocalizedString("InsufficientBalanceAlertTitle", comment: ""), message: message, preferredStyle: .alert)
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default){ (action) in
            print("pressed yes")
            removeAndShowNextMessage()
            
        })
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

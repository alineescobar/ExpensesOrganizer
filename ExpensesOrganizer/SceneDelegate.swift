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
    var recurrence: Recurrence = Recurrence()
    var templates: [Template] = []
    
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
            UserDefaults.standard.bool(forKey: "firstTimeOpenTheAppToday")
            UserDefaults.standard.set(false, forKey: "firstTimeOpenTheAppToday")
            let storyboard = UIStoryboard(name: "Onboarding", bundle: .main)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
        
        var currentDate = Date()
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let context = context else {
            return
        }
        
        if UserDefaults.standard.bool(forKey: "firstTimeOpenTheAppToday") == false {
            var items: [Item] = []
            do {
                let request = Template.fetchRequest() as NSFetchRequest<Template>
                templates = try context.fetch(request)
            } catch {
                print("caiu no erro")
            }
            
            for template in templates {
                items = template.items?.array as? [Item] ?? []
                
                for items in items {
                    guard let itemsTemplate = items.template else { return }
                    guard let walletItem = items.paymentMethod else { continue }
                    if itemsTemplate.isExpense { //ver se é decrementar ou incrementar na carteira, isExpense
                        recurrence.recurrenceCounterDec(recurrenceType: RecurrencyTypes(rawValue: items.recurrenceType ?? "Never") ?? .never, transactionDate: items.recurrenceDate ?? Date(), wallet: walletItem, item: items)
                    } else {
                        recurrence.recurrenceCounterInc(recurrenceType: RecurrencyTypes(rawValue: items.recurrenceType ?? "Never") ?? .never, transactionDate: items.recurrenceDate ?? Date(), wallet: walletItem, item: items)
                    }
                }
            }
            UserDefaults.standard.set(true, forKey: "firstTimeOpenTheAppToday")
        }
        let lastCurrentDate = currentDate
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        
        if currentDate == lastCurrentDate {
            UserDefaults.standard.set(true, forKey: "firstTimeOpenTheAppToday")
        } else {
            UserDefaults.standard.set(false, forKey: "firstTimeOpenTheAppToday")
        }
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

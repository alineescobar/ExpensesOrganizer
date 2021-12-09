//
//  NotificationManager.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 06/12/21.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static let shared = NotificationManager()
    
    private let calendar = Calendar.current
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    func getAuthorization() {
        notificationCenter.requestAuthorization(options: options) { allowed, error in
            if !allowed {
                print(error?.localizedDescription ?? "User didn't allowed notifications")
            }
        }
    }
    
    func content(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 0
        
        return content
    }
    
    func schedule(selectedDate: Date, hour: Int, minute: Int, frequency: RecurrencyTypes) -> Any {
        
        switch frequency {
        case .everyDay:
            let nextTriggerDate = selectedDate.adding(days: 1) ?? Date()
            var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: nextTriggerDate)
            dateComponents.hour = 9
            dateComponents.minute = 0
            dateComponents.second = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            return trigger
            
        case .everyWeek:
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            dateComponents.minute = 0
            dateComponents.second = 0
            dateComponents.weekday = Calendar.current.dateComponents([.weekday], from: selectedDate.adding(days: -1) ?? Date()).weekday
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            return trigger
            
        case .eachMonth:
            let dateAdvanced: Date = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            dateComponents.minute = 0
            dateComponents.second = 0
            dateComponents.day = Calendar.current.dateComponents([.day], from: dateAdvanced.adding(days: -1) ?? dateAdvanced).day
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            return trigger
            
        case .eachYear:
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            dateComponents.minute = 0
            dateComponents.second = 0
            dateComponents.month = Calendar.current.dateComponents([.month], from: selectedDate).month
            dateComponents.day = Calendar.current.dateComponents([.day], from: selectedDate.adding(days: -1) ?? selectedDate).day
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            return trigger
            
        case .eachTwoWeeks:
            let timeIntervalFromDateToNow = selectedDate.timeIntervalSince(selectedDate)
            let timeIntervalFor2Weeks = 1123200.0 - timeIntervalFromDateToNow
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeIntervalFor2Weeks, repeats: true)
            return trigger
            
        case .never:
            return RecurrencyTypes.never
        }
        
    }
    
    func send(identifier: String, title: String, body: String, selectedDate: Date, frequency: RecurrencyTypes) {
        let hour = selectedDate.get(.hour)
        let minute = selectedDate.get(.minute)
        
        if let trigger = schedule(selectedDate: selectedDate, hour: hour, minute: minute, frequency: frequency) as? UNCalendarNotificationTrigger {
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content(title: title, body: body),
                                                trigger: trigger)
            notificationCenter.add(request, withCompletionHandler: nil)
            return
        }
        
        if let trigger = schedule(selectedDate: selectedDate, hour: hour, minute: minute, frequency: frequency) as? UNTimeIntervalNotificationTrigger {
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content(title: title, body: body),
                                                trigger: trigger)
            notificationCenter.add(request, withCompletionHandler: nil)
            return
        }
    }
    
    func cancel(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}

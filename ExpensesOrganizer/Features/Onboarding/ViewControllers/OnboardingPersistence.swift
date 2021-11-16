//
//  OnboardingPersistence.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 16/11/21.
//

import Foundation

class OnboardingPersistence {
    static let defaults = UserDefaults.standard
    private static let showOnboardingKey = "onboarding-completed"
    private static let userNameKey = "user-name"
    
    static func getOnboardingCompleted() -> Bool {
        return defaults.bool(forKey: showOnboardingKey)
    }
    
    static func setOnboardingCompleted(_ show: Bool) {
        defaults.set(show, forKey: showOnboardingKey)
    }
    
    static func getUserName() -> String? {
        return defaults.string(forKey: userNameKey)
    }
    
    static func setUserName(_ name: String?) {
        defaults.set(name?.isEmpty ?? true ? nil : name, forKey: userNameKey)
    }
}

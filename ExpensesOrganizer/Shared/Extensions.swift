//
//  Extensions.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

extension UIView {
    func makeCircle() {
        layer.cornerRadius = frame.size.width / 2
    }
    
    func makeShadow(color: UIColor, width: Int, height: Int, radius: CGFloat, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}

extension UILabel {
    func setAdjustableFontSize(scaleFactor: CGFloat) {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = scaleFactor
    }
}

extension Locale {
    func localizedCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
        guard let languageCode = languageCode, let regionCode = regionCode
        else {
            return nil
        }

        /*
         Each currency can have a symbol ($, £, ¥),
         but those symbols may be shared with other currencies.
         For example, in Canadian and American locales,
         the $ symbol on its own implicitly represents CAD and USD, respectively.
         Including the language and region here ensures that
         USD is represented as $ in America and US$ in Canada.
        */
        let components: [String: String] = [
            NSLocale.Key.languageCode.rawValue: languageCode,
            NSLocale.Key.countryCode.rawValue: regionCode,
            NSLocale.Key.currencyCode.rawValue: currencyCode
        ]

        let identifier = Locale.identifier(fromComponents: components)

        return Locale(identifier: identifier).currencySymbol
    }
}

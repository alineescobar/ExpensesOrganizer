//
//  Extensions.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 23/10/21.
//

import UIKit

enum UIType {
    case card, screen
}

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

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (ran: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, ran.lowerBound)),
                                            upper: min(length, max(0, ran.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

func getFormattedBalance(balance: Double, smallTextSize: CGFloat, type: UIType) -> NSAttributedString {
    let currency: String = Locale.current.localizedCurrencySymbol(forCurrencyCode: Locale.current.currencyCode ?? "R$") ?? ""
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    
    if var formattedBalance = formatter.string(from: balance as NSNumber) {
        
        if Character(formattedBalance[currency.count]).isNumber {
            let index = formattedBalance.index(formattedBalance.startIndex, offsetBy: currency.count)
            formattedBalance.insert(" ", at: index)
        }
        
        if type == .screen {
            let index = formattedBalance.index(formattedBalance.startIndex, offsetBy: formattedBalance.count - 2)
            formattedBalance.insert(" ", at: index)
        }
        
        let amountText = NSMutableAttributedString(string: formattedBalance)
        
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallTextSize, weight: .light),
                                      NSAttributedString.Key.foregroundColor: UIColor.black],
                                 range: NSRange(location: 0, length: currency.count + 1))
        
        amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallTextSize, weight: .light),
                                      NSAttributedString.Key.foregroundColor: UIColor.black],
                                 range: NSRange(location: formattedBalance.count - 3, length: 3))
       return amountText
    }
    
    return NSAttributedString()
}

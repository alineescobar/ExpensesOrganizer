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

func getFormattedBalance(balance: Double, smallTextSize: CGFloat, type: UIType, color: UIColor = UIColor.black) -> NSAttributedString {
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
        
        amountText.setAttributes([NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: smallTextSize) ?? UIFont.systemFont(ofSize: smallTextSize, weight: .light),
                                  NSAttributedString.Key.foregroundColor: type == .screen ? UIColor.white : UIColor(named: "TertiaryBrandColor") as Any],
                                 range: NSRange(location: 0, length: currency.count + 1))
        
        amountText.setAttributes([NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: smallTextSize) ?? UIFont.systemFont(ofSize: smallTextSize, weight: .light),
                                  NSAttributedString.Key.foregroundColor: type == .screen ? UIColor.white : UIColor(named: "TertiaryBrandColor") as Any],
                                 range: NSRange(location: formattedBalance.count - 3, length: 3))
        return amountText
    }
    
    return NSAttributedString()
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex?.stringByReplacingMatches(in: amountWithPrefix,
                                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                           range: NSRange(location: 0, length: self.count),
                                                           withTemplate: "") ?? ""
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        var formattedString = formatter.string(from: number) ?? ""
        if !Character(formattedString[0]).isNumber {
            formattedString = formattedString.substring(fromIndex: 1)
        }
        return formattedString
    }
}

extension UIStackView {
    private func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.tag = -1
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func setBackgroundColor(color: UIColor) {
        if #available(iOS 14, *) {
            backgroundColor = color
        } else {
            guard let backgroundView = viewWithTag(-1) else {
                addBackground(color: color)
                return
            }
            backgroundView.backgroundColor = color
        }
    }
}

extension UIImage {
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)
}

extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    
    var localizedDescription: String { localizedDescription() }
    
    var fullDate: String { localizedDescription(dateStyle: .full, timeStyle: .none) }
    
    var longDate: String { localizedDescription(dateStyle: .long, timeStyle: .none) }
    
    var mediumDate: String { localizedDescription(dateStyle: .medium, timeStyle: .none) }
    
    var shortDate: String { localizedDescription(dateStyle: .short, timeStyle: .none) }
    
    var fullTime: String { localizedDescription(dateStyle: .none, timeStyle: .full) }
    
    var longTime: String { localizedDescription(dateStyle: .none, timeStyle: .long) }
    
    var mediumTime: String { localizedDescription(dateStyle: .none, timeStyle: .medium) }
    
    var shortTime: String { localizedDescription(dateStyle: .none, timeStyle: .short) }
    
    var fullDateTime: String { localizedDescription(dateStyle: .full, timeStyle: .full) }
    
    var longDateTime: String { localizedDescription(dateStyle: .long, timeStyle: .long) }
    
    var mediumDateTime: String { localizedDescription(dateStyle: .medium, timeStyle: .medium) }
    
    var shortDateTime: String { localizedDescription(dateStyle: .short, timeStyle: .short) }
}

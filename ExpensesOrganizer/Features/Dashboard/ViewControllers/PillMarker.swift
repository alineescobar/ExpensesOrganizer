//
//  PillMarker.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 28/10/21.
//

import Charts
import UIKit

class PillMarker: MarkerImage {

    private (set) var color: UIColor
    private (set) var font: UIFont
    private (set) var textColor: UIColor
    private var labelText: String = ""
    private var attrs: [NSAttributedString.Key: AnyObject]!

    init(color: UIColor, font: UIFont, textColor: UIColor) {
        self.color = color
        self.font = font
        self.textColor = textColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        // custom padding around text
        let labelWidth = labelText.size(withAttributes: attrs).width + 10
        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
        let labelHeight = labelText.size(withAttributes: attrs).height + 4
        
        // place pill above the marker, centered along x
        var rectangle = CGRect(x: point.x, y: point.y, width: labelWidth, height: labelHeight)
        rectangle.origin.x = point.x > (UIScreen.main.bounds.width - rectangle.width) ? rectangle.origin.x - rectangle.width
        : point.x < rectangle.width ? rectangle.origin.x + (rectangle.width / 4.0)
        : rectangle.origin.x - (rectangle.width / 2.0)
        let spacing: CGFloat = 20
        rectangle.origin.y = point.y < 41 ? rectangle.origin.y + rectangle.height : rectangle.origin.y - (rectangle.height + spacing)

        // rounded rect
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
        context.addPath(clipPath)
        context.setFillColor(UIColor.black.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // add the text
        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        let circleRect = CGRect(x: point.x - 4, y: point.y - 4, width: 4 * 2, height: 4 * 2)
                context.setFillColor(color.cgColor)
                context.fillEllipse(in: circleRect)
                
                context.restoreGState()
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        labelText = customString(entry.y)
    }

    private func customString(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
    
}

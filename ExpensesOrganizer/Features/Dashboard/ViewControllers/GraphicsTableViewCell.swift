//
//  GraphicsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 27/10/21.
//

import Charts
import UIKit

class GraphicsTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: LineChartView!
    
    var yValues: [ChartDataEntry] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.backgroundColor = .systemGray5
        chartView.rightAxis.enabled = false
        chartView.gridBackgroundColor = .systemGray5
        
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.xAxis.drawAxisLineEnabled = false
//        chartView.drawGridBackgroundEnabled = false
//        chartView.leftAxis.drawAxisLineEnabled = false
//
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.xAxis.gridColor = .clear
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.gridColor = .clear
        
        for i in 0..<20 {
            yValues += [ChartDataEntry(x: Double(i), y: Double.random(in: 0..<50))]
        }
        
        setData()
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Rendimento")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.darkGray)
        set1.circleColors = [.darkGray]
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

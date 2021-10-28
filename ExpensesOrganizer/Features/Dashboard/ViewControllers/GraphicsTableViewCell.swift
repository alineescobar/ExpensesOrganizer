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
        chartView.gridBackgroundColor = .systemGray5
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.gridColor = .clear
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.gridColor = .clear
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.granularity = 1
        
        // Mock
        for i in 6..<12 {
            yValues += [ChartDataEntry(x: Double(i), y: Double.random(in: 0..<50))]
        }
        
        setData()
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Rendimento")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.drawCirclesEnabled = false
        set1.setColor(.darkGray)
        set1.circleColors = [.darkGray]
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
}

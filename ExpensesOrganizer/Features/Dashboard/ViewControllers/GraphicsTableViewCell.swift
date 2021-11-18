//
//  GraphicsTableViewCell.swift
//  ExpensesOrganizer
//
//  Created by Anderson Sprenger on 27/10/21.
//

import Charts
import UIKit

class GraphicsTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak var chartView: LineChartView!
    
    var yValues: [ChartDataEntry] = []
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        chartView.delegate = self
        
        chartView.backgroundColor = .clear
        chartView.gridBackgroundColor = .clear
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .clear
        chartView.xAxis.gridColor = .clear
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.gridColor = .clear
        chartView.xAxis.labelFont = UIFont(name: "WorkSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.granularity = 1
        chartView.xAxis.centerAxisLabelsEnabled = true
        
        let marker = PillMarker(color: .white, font: UIFont.boldSystemFont(ofSize: 14), textColor: .white)
        chartView.marker = marker
        
        // Mock
        for i in 5..<12 {
            yValues += [ChartDataEntry(x: Double(i), y: Double.random(in: 0..<50))]
        }
        
        setData()
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Rendimento")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.drawCirclesEnabled = false
        set1.setColor(.white)
        set1.circleColors = [.white]
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawValuesEnabled = false
        let data = LineChartData(dataSet: set1)
        chartView.data = data
    }
}

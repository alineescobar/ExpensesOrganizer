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
        
        chartView.delegate = self
        
        chartView.backgroundColor = .systemGray5
        chartView.gridBackgroundColor = .systemGray5
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .clear
        chartView.xAxis.gridColor = .clear
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.gridColor = .clear
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.granularity = 1
        
        let marker = PillMarker(color: .white, font: UIFont.boldSystemFont(ofSize: 14), textColor: .white)
        chartView.marker = marker
        
        // Mock
        for i in 6..<12 {
            yValues += [ChartDataEntry(x: Double(i), y: Double.random(in: 0..<50))]
        }
        
        setData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    class MarkerView: UIView {
        @IBOutlet var valueLabel: UILabel!
        @IBOutlet var metricLabel: UILabel!
        @IBOutlet var dateLabel: UILabel!
    }
    
    let markerView = MarkerView()
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Rendimento")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.drawCirclesEnabled = false
        set1.setColor(.darkGray)
        set1.circleColors = [.darkGray]
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawValuesEnabled = false
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
}

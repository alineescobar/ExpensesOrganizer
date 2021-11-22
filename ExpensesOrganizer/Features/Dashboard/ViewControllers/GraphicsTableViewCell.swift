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
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var transactions: [Transaction] = []
    private var wallets: [Wallet] = []
    
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
        
        loadData()
        
        setData()
    }
    
    private func loadData() {
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            transactions = try context.fetch(Transaction.fetchRequest())
        } catch {
            print("erro ao carregar")
        }
        
        let today = Calendar.current.dateComponents([.month, .year], from: Date())
        
        var lastBalance: Double = wallets.reduce(0) { partial, wallet in
            return partial + wallet.value
        }
        print(lastBalance, "\n\n\n\n\n\n")
        
        var lastMonth = today.month
        
        var balanceHistory: [(Double, Double)] = []
        
        for _ in 0..<6 {
            let lastTransactions = transactions.filter { transaction in
                if let date = transaction.transactionDate {
                    return Calendar.current.dateComponents([.month], from: date).month == lastMonth
                }
                
                return false
            }
            
            if let lastMonth = lastMonth {
                let monthBalance = lastTransactions.reduce(lastBalance) { partialResult, transaction in
                    if transaction.category?.isExpense ?? true {
                        return partialResult + transaction.value
                    } else {
                        return partialResult - transaction.value
                    }
                }
                
                lastBalance = monthBalance
                balanceHistory = [(Double(lastMonth), monthBalance)] + balanceHistory
                
            }
            
            if lastMonth == 0 {
                lastMonth = 11
            } else {
                lastMonth? -= 1
            }
        }
        
        for balance in balanceHistory {
            yValues += [ChartDataEntry(x: balance.0, y: balance.1)]
        }
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

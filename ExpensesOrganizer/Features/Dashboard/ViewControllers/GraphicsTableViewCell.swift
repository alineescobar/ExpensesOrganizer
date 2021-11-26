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
    var dataset = LineChartDataSet(entries: [], label: "Amount")
    let months = [NSLocalizedString("Jan", comment: ""),
                  NSLocalizedString("Feb", comment: ""),
                  NSLocalizedString("Mar", comment: ""),
                  NSLocalizedString("Apr", comment: ""),
                  NSLocalizedString("May", comment: ""),
                  NSLocalizedString("Jun", comment: ""),
                  NSLocalizedString("Jul", comment: ""),
                  NSLocalizedString("Aug", comment: ""),
                  NSLocalizedString("Sep", comment: ""),
                  NSLocalizedString("Oct", comment: ""),
                  NSLocalizedString("Nov", comment: ""),
                  NSLocalizedString("Dec", comment: ""),
                  NSLocalizedString("Jan", comment: ""),
                  NSLocalizedString("Feb", comment: ""),
                  NSLocalizedString("Mar", comment: ""),
                  NSLocalizedString("Apr", comment: ""),
                  NSLocalizedString("May", comment: ""),
                  NSLocalizedString("Jun", comment: ""),
                  NSLocalizedString("Jul", comment: ""),
                  NSLocalizedString("Aug", comment: ""),
                  NSLocalizedString("Sep", comment: ""),
                  NSLocalizedString("Oct", comment: ""),
                  NSLocalizedString("Nov", comment: ""),
                  NSLocalizedString("Dec", comment: "")]
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var transactions: [Transaction] = []
    private var wallets: [Wallet] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        chartView.delegate = self
        
        chartView.backgroundColor = .clear
        chartView.gridBackgroundColor = .clear
        
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
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
        
        dataset = LineChartDataSet(entries: yValues, label: "Amount")
        
        //dataset.mode = .cubicBezier
        dataset.lineWidth = 3
        dataset.drawCirclesEnabled = false
        dataset.setColor(.white)
        dataset.circleColors = [.white]
        dataset.drawVerticalHighlightIndicatorEnabled = false
        dataset.drawHorizontalHighlightIndicatorEnabled = false
        dataset.drawValuesEnabled = false
        let data = LineChartData(dataSet: dataset)
        
//        chartView?.data?.dataSets.removeAll(keepingCapacity: false)
        chartView?.data = data
//        chartView?.notifyDataSetChanged()
    }
    
    func loadData() {
        guard let context = self.context else {
            return
        }
        
        do {
            wallets = try context.fetch(Wallet.fetchRequest())
            transactions = try context.fetch(Transaction.fetchRequest())
        } catch {
            print("Erro ao carregar dados do Core Data.", error.localizedDescription)
        }
        
        var lastBalance: Double = wallets.reduce(0) { $0 + $1.value }
        
        let today = Calendar.current.dateComponents([.month, .year], from: Date())
        var lastMonth = (month: today.month, year: today.year)
        
        var balanceHistory: [(x: Double, y: Double)] = []
        
        if let month = today.month {
            balanceHistory += [(Double(month + 1), lastBalance)]
        }
        
        var walletTransactions: [(date: Date, value: Double)] = []
        
        for wallet in wallets {
            if let date: Date = wallet.recurrenceDate {
                var value: Double = wallet.value
                
                for transaction in transactions where transaction.transactionDestination == wallet.walletID {
                    if transaction.category?.isExpense ?? true {
                        value += transaction.value
                    } else {
                        value -= transaction.value
                    }
                }
                
                walletTransactions += [(date, value)]
            }
        }
        
        print(walletTransactions)
        
        for _ in 0..<6 {
            let lastTransactions = transactions.filter { transaction in
                if let date = transaction.transactionDate {
                    let transactionDate = Calendar.current.dateComponents([.month, .year], from: date)
                    return transactionDate.month == lastMonth.month && transactionDate.year == lastMonth.year
                }
                
                return false
            }
            
            let lastWalletTransactions = walletTransactions.filter { transaction in
                let transactionDate = Calendar.current.dateComponents([.month, .year], from: transaction.date)
                
                return transactionDate.month == lastMonth.month && transactionDate.year == lastMonth.year
            }
            
            if let month = lastMonth.month {
                var monthBalance = lastTransactions.reduce(lastBalance) { partialResult, transaction in
                    if transaction.category?.isExpense ?? true {
                        return partialResult + transaction.value
                    } else {
                        return partialResult - transaction.value
                    }
                }
                
                monthBalance = lastWalletTransactions.reduce(monthBalance) { $0 - $1.value }
                
                lastBalance = monthBalance
                balanceHistory = [(Double(month), monthBalance)] + balanceHistory
            }
            
            if lastMonth.month == 1 {
                lastMonth.month = 12
                lastMonth.year? -= 1
            } else {
                lastMonth.month? -= 1
            }
        }
        
        balanceHistory = fixData(balanceHistory)
        
        print(balanceHistory)
        
        for balance in balanceHistory {
            yValues += [ChartDataEntry(x: balance.x, y: balance.y)]
        }
    }
    
    private func fixData(_ data: [(Double, Double)]) -> [(Double, Double)] {
        let month = data[0].0 - 1
        
        var fixedData = data
        
        for index in 0..<data.count {
            fixedData[index].0 = month + Double(index)
        }
        
        return fixedData
    }
    
//    func setData() {
//        let set1 = LineChartDataSet(entries: yValues, label: "Rendimento")
//
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadData()
        dataset.removeAll(keepingCapacity: true)
        for index in dataset.count..<yValues.count {
            print(#function, dataset.count..<yValues.count, yValues.count, yValues[index])
            _ = dataset.addEntryOrdered(yValues[index])
        }
        chartView.notifyDataSetChanged()
//        chartView.clear()
    }
}

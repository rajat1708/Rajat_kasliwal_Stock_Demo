//
//  StocksViewModel.swift
//  Delete
//
//  Created by Rajat Kasliwal on 15/08/25.
//

import UIKit
import Foundation

protocol StocksViewModelDelegate: AnyObject {
    func didUpdateStocks()
}

class StocksViewModel {
    private(set) var stocks: [UserHolding] = []
    private(set) var isExpanded: Bool = false
    private var networkManager: NetworkManager?
    private weak var delegate: StocksViewModelDelegate?
    
    init(delegate: StocksViewModelDelegate?) {
        self.delegate = delegate
        networkManager = NetworkManager(delegate: self)
    }
    
    func toggleExpand() {
        isExpanded.toggle()
    }
    
    func stockCount() -> Int {
        return stocks.count
    }
    
    func formattedLTP(_ stock: UserHolding) -> String {
        return "₹\(String(format: "%.2f", stock.ltp))"
    }
    
    func formattedQuantity(_ stock: UserHolding) -> String {
        return "\(stock.quantity)"
    }
    
    func formattedPnL(_ stock: UserHolding) -> (String, UIColor) {
        let pnlString = "₹\(String(format: "%.2f", abs(stock.pnl)))"
        let color: UIColor = stock.pnl < 0 ? .red : .systemGreen
        return (stock.pnl < 0 ? "-\(pnlString)" : pnlString, color)
    }
    
    func stockNameAtIndex(_ index: Int) -> String {
        return stocks[index].symbol
    }
    
    func stockLTPAtIndex(_ index: Int) -> String {
        return formattedLTP(stocks[index])
    }
    
    func stockQuantityAtIndex(_ index: Int) -> String {
        return formattedQuantity(stocks[index])
    }
    
    func stockPnLAtIndex(_ index: Int) -> (String, UIColor) {
        return formattedPnL(stocks[index])
    }
    
    func fetchStockList() {
        // Simulate network fetch or database query
        // In a real app, this would be an async operation
        networkManager?.hitNetwork(for: StockRequest())
    }
    
    private func currentValueDouble() -> Double {
        return stocks.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }
    
    func currentValue() -> String {
        "₹\(String(format: "%.2f", currentValueDouble()))"
    }
    
    func totalPnLDouble() -> Double {
        let totalPl = currentValueDouble() - totalInvestmentDouble()
        return Double(round(1000000 * totalPl) / 1000000)
    }
    
    func totalPnL() -> String {
        "₹\(String(format: "%.2f", totalPnLDouble()))"
    }
    
    func totalPnLColour() -> UIColor {
        let totalPnl = totalPnLDouble()
        if totalPnl == 0 {
            return .black
        }
        return totalPnl < 0 ? .red : .systemGreen
    }
    
    func totalInvestmentDouble() -> Double {
        let totalInvestment = stocks.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        // send upto 6 decimal place
        return Double(round(1000000 * totalInvestment) / 1000000)
    }
    
    func totalInvestment() -> String {
        "₹\(String(format: "%.2f", totalInvestmentDouble()))"
    }
    
    private func todayChangeDouble() -> Double {
        let todayChange =  stocks.reduce(0) { $0 + ($1.close - $1.ltp) * Double($1.quantity) }
        // send upto 6 decimal place
        return Double(round(1000000 * todayChange) / 1000000)
    }
    
    func todayChange() -> String {
        "₹\(String(format: "%.2f", todayChangeDouble()))"
    }
    
    func todayChangeColor() -> UIColor {
        let change = todayChangeDouble()
        if change == 0 {
            return .black
        }
        return change < 0 ? .red : .systemGreen
    }
}

extension StocksViewModel: NetworkManagerDelegate {
    func didReceiveData(_ data: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let stocksData = try jsonDecoder.decode(StockDetails.self, from: data)
            print(stocksData)
            stocks = stocksData.data?.userHolding ?? []
            delegate?.didUpdateStocks()
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func didFailWithError(_ error: any Error) {
        //
    }
}

#if DEBUG
extension StocksViewModel {
    func setStocksForTesting(_ stocks: [UserHolding]) {
        self.stocks = stocks
    }
}
#endif

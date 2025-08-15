//
//  MockDelegate.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//


import XCTest
@testable import Rajat_kasliwal_Stock_Demo

class MockDelegate: StocksViewModelDelegate {
    var didUpdateStocksCalled = false
    func didUpdateStocks() {
        didUpdateStocksCalled = true
    }
}

class StocksViewModelTests: XCTestCase {
    var viewModel: StocksViewModel!
    var mockDelegate: MockDelegate!

    override func setUp() {
        super.setUp()
        mockDelegate = MockDelegate()
        viewModel = StocksViewModel(delegate: mockDelegate)
        let stocks = [
            UserHolding(symbol: "AAPL", quantity: 2, ltp: 150.0, avgPrice: 145.0, close: 148.0),
            UserHolding(symbol: "GOOG", quantity: 1, ltp: 100.0, avgPrice: 105.0, close: 102.0)
        ]
        viewModel.setStocksForTesting(stocks)
        
    }

    func testToggleExpand() {
        let initial = viewModel.isExpanded
        viewModel.toggleExpand()
        XCTAssertNotEqual(viewModel.isExpanded, initial)
    }

    func testStockCount() {
        XCTAssertEqual(viewModel.stockCount(), 2)
    }

    func testFormattedLTP() {
        let ltp = viewModel.formattedLTP(viewModel.stocks[0])
        XCTAssertEqual(ltp, "₹150.00")
    }

    func testFormattedQuantity() {
        let qty = viewModel.formattedQuantity(viewModel.stocks[0])
        XCTAssertEqual(qty, "2")
    }

    func testFormattedPnL_Positive() {
        let (pnl, color) = viewModel.formattedPnL(viewModel.stocks[0])
        XCTAssertEqual(pnl, "₹10.00")
        XCTAssertEqual(color, .systemGreen)
    }

    func testFormattedPnL_Negative() {
        let (pnl, color) = viewModel.formattedPnL(viewModel.stocks[1])
        XCTAssertEqual(pnl, "-₹5.00")
        XCTAssertEqual(color, .red)
    }

    func testCurrentValue() {
        XCTAssertEqual(viewModel.currentValue(), "₹400.00")
    }

    func testTotalPnL() {
        XCTAssertEqual(viewModel.totalPnL(), "₹5.00")
    }

    func testTotalInvestment() {
        XCTAssertEqual(viewModel.totalInvestment(), "₹395.00")
    }

    func testTodayChange() {
        XCTAssertEqual(viewModel.todayChange(), "₹-2.00")
    }

    func testTotalPnLColour_Positive() {
        XCTAssertEqual(viewModel.totalPnLColour(), .systemGreen)
    }

    func testTotalPnLColour_Zero() {
        viewModel.setStocksForTesting([])
        XCTAssertEqual(viewModel.totalPnLColour(), .black)
    }

    func testTodayChangeColor_Zero() {
        XCTAssertEqual(viewModel.todayChangeColor(), .red)
    }

    func testDelegateCalledOnDataReceive() {
        let json = """
        {
            "data": {
                "userHolding": [
                    {"symbol": "AAPL", "ltp": 150.0, "quantity": 2, "avgPrice": 145.0, "close": 148.0}
                ]
            }
        }
        """.data(using: .utf8)!
        viewModel.didReceiveData(json)
        XCTAssertTrue(mockDelegate.didUpdateStocksCalled)
        XCTAssertEqual(viewModel.stocks.count, 1)
    }
}

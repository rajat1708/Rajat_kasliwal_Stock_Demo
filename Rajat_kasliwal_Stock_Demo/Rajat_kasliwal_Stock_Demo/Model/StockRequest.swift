//
//  StockRequest.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//

struct StockRequest : NetworkRequestProtocol {
    var requestURLString: String {
        return "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/stocks"
    }
}

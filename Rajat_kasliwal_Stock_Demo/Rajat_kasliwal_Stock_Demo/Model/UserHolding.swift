import Foundation

struct UserHolding : Codable {
    let symbol : String
    let quantity : Int
    let ltp : Double
    let avgPrice : Double
    let close : Double
    
    init(symbol: String = UserHoldingDefaultValues.symbol, quantity: Int = UserHoldingDefaultValues.quantity, ltp: Double = UserHoldingDefaultValues.ltp, avgPrice: Double = UserHoldingDefaultValues.avgPrice, close: Double = UserHoldingDefaultValues.close) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.avgPrice = avgPrice
        self.close = close
    }
    
    var pnl: Double {
        return (ltp - avgPrice) * Double(quantity)
    }
    
    enum CodingKeys: String, CodingKey {
        
        case symbol = "symbol"
        case quantity = "quantity"
        case ltp = "ltp"
        case avgPrice = "avgPrice"
        case close = "close"
    }
    
    
    struct UserHoldingDefaultValues {
        static let symbol = ""
        static let quantity = 0
        static let ltp = 0.0
        static let avgPrice = 0.0
        static let close = 0.0
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol) ?? UserHoldingDefaultValues.symbol
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity) ?? UserHoldingDefaultValues.quantity
        ltp = try values.decodeIfPresent(Double.self, forKey: .ltp) ?? UserHoldingDefaultValues.ltp
        avgPrice = try values.decodeIfPresent(Double.self, forKey: .avgPrice) ?? UserHoldingDefaultValues.avgPrice
        close = try values.decodeIfPresent(Double.self, forKey: .close) ?? UserHoldingDefaultValues.close
    }
    
}

import Foundation
struct StockDetails : Codable {
    let data : UserHoldingData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(UserHoldingData.self, forKey: .data)
    }
}

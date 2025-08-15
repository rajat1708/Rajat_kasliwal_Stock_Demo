import Foundation
struct UserHoldingData : Codable {
    let userHolding : [UserHolding]?
    
    enum CodingKeys: String, CodingKey {
        
        case userHolding = "userHolding"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userHolding = try values.decodeIfPresent([UserHolding].self, forKey: .userHolding)
    }
    
}

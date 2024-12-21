import SwiftUI

@Observable
class OrderState: Codable {
    static let orderTypes = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    enum CodingKeys: String, CodingKey {
        case _orderType = "orderType"
        case _orderQuantity = "orderQuantity"
        case _hasSpecialRequests = "hasSpecialRequests"
        case _addExtraFrosting = "addExtraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zipCode = "zipCode"
    }
    var orderType = 0
    var orderQuantity = 3
    var hasSpecialRequests = false {
        didSet {
            if !hasSpecialRequests {
                addExtraFrosting = false
                addSprinkles = false
            }
        }
    }
    var addExtraFrosting = false
    var addSprinkles = false
    var name = ""
    var streetAddress = "" {
        didSet {
            deliveryAddress["streetAddress"] = streetAddress
        }
    }
    var city = "" {
        didSet {
            deliveryAddress["city"] = city
        }
    }
    var zipCode = "" {
        didSet {
            deliveryAddress["zipCode"] = zipCode
        }
    }
    var deliveryAddress: [String: String] = [:] {
        didSet {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(deliveryAddress) {
                UserDefaults.standard.set(encodedData, forKey: "deliveryAddress")
            }
        }
    }
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zipCode.isEmpty {
            return false
        }
        if name.isWhiteSpaceOnly || streetAddress.isWhiteSpaceOnly || city.isWhiteSpaceOnly || zipCode.isWhiteSpaceOnly {
            return false
        }
        return true
    }
    var costUsd: Decimal {
        let costPerQuantity = 2
        var cost = Decimal(orderQuantity) * Decimal(costPerQuantity)
        cost += Decimal(orderType) / 2
        if addExtraFrosting {
            cost += Decimal(orderQuantity)
        }
        if addSprinkles {
            cost += Decimal(orderQuantity) / 2
        }
        return cost
    }
    init() {
        if let encodedData = UserDefaults.standard.data(forKey: "deliveryAddress") {
            let decoder = JSONDecoder()
            if let decodedAddress = try? decoder.decode([String: String].self, from: encodedData) {
                streetAddress = decodedAddress["streetAddress"] ?? ""
                city = decodedAddress["city"] ?? ""
                zipCode = decodedAddress["zipCode"] ?? ""
            }
        }
    }
}

extension String {
    var isWhiteSpaceOnly: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}

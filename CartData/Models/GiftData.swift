//
//  GiftData.swift
//  UnitedPharmacy
//
//  Created by Pushkar Yadav on 15/02/2023.
//

import Foundation

public struct GiftData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let code = "code"
        static let id = "id"
        static let amount = "amount"
        static let bamount = "b_amount"
    }
    
    // MARK: Properties
    public var code: String?
    public var id: Int?
    public var amount: Int?
    public var bamount: Int?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        code = json[SerializationKeys.code].stringValue
        id = json[SerializationKeys.id].intValue
        amount = json[SerializationKeys.amount].intValue
        bamount = json[SerializationKeys.bamount].intValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = code { dictionary[SerializationKeys.code] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = amount { dictionary[SerializationKeys.amount] = value }
        if let value = bamount { dictionary[SerializationKeys.bamount] = value }
        
        return dictionary
    }
    
}

//
//  AlgoliaSearchModel.swift
//  UnitedPharmacy
//
//  Created by Suraj Lalvani on 09/05/22.
//

import Foundation
import SwiftyJSON


// MARK: - Welcome
struct SearchData {
    var name: Name?
    var objectID: String?
    var categories: CategorieyWise?
    var imageURL: String?
    var price: Price?
    
    init(_ searchData: [String:Any]) {
        name = Name(searchData["name"] as? [String:Any] ?? [:])
        price = Price(searchData["price"] as? [String:Any] ?? [:])
        objectID = searchData["objectID"] as? String
        imageURL = searchData["image_url"] as? String
    }
}

// MARK: - Categories
struct CategorieyWise {
    var en, ar: Ar?
}

// MARK: - Ar
struct Ar {
    var level0, level2, level1: [String]?
}

// MARK: - Name
struct Name {
    var en, ar: String?
    
    init(_ name: [String:Any]) {
        self.en = name["en"] as? String
        self.ar = name["ar"] as? String
    }
}

// MARK: - Price
struct Price {
    var sar: Sar?
    
    init(_ price:[String:Any]) {
        sar = Sar(price["SAR"] as? [String:Any] ?? [:]) //
    }
}

// MARK: - Sar
struct Sar {
    var specialToDate, specialFromDate: Bool?
    var defaultFormated: String?
    var sarDefault: Double?
    
    init(_ value:[String:Any]) {
        self.defaultFormated = value["default_formated"] as? String
        self.specialToDate = value["special_to_date"] as? Bool
        self.specialFromDate = value["special_from_date"] as? Bool
        self.sarDefault = value["default"] as? Double
    }
}

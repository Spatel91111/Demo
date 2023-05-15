//
//  AlgoliaManager.swift
//  UnitedPharmacy
//
//  Created by Suraj Lalvani on 10/05/22.
//

import Foundation
import AlgoliaSearchClient

class AlgoliaManager {
    
    /// The singleton instance.
    static let sharedInstance = AlgoliaManager()
    
    let client: SearchClient
    var productIndex: Index
    
    
    private init() {
        client = SearchClient(appID: ApplicationID(rawValue: AlgoliaSetup.applicationID.rawValue)
                              , apiKey: APIKey(rawValue: AlgoliaSetup.apiKey.rawValue) )
        productIndex = client.index(withName: IndexName(rawValue: AlgoliaSetup.indexName.rawValue) )
    }
    
    func getDataFrom(_ value:Query, completionHandler: @escaping ((SearchResponse)->())) {
        
        productIndex.search(query: value, requestOptions: nil) { response in
            
            switch response {
            case .success(let response) :
                completionHandler(response)
            default :
                print("error")
            }
        }
    }
}

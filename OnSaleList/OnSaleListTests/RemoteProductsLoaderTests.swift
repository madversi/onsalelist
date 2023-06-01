//
//  RemoteProductsLoaderTests.swift
//  OnSaleListTests
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import XCTest

class RemoteProductsLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteProductsLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteProductsLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
}

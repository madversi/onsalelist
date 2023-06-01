//
//  RemoteProductsLoaderTests.swift
//  OnSaleListTests
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import XCTest

class RemoteProductsLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "http://any-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {
        
    }
    
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteProductsLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        _ = RemoteProductsLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteProductsLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

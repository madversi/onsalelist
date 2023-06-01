//
//  RemoteProductsLoader.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteProductsLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}

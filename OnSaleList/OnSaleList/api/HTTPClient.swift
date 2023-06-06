//
//  HTTPClient.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 06/06/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

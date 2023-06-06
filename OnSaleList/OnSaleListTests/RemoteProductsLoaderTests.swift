//
//  RemoteProductsLoaderTests.swift
//  OnSaleListTests
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import OnSaleList
import XCTest

class RemoteProductsLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoProductsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJSON = Data("{\"products\": []}".utf8) // this creates a valid response with no items
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversProductsOn200HTTPResponseNotEmpty() {
        let (sut, client) = makeSUT()
        
        let size1 = Size(size: "P", available: true)
        let size2 = Size(size: "G", available: false)
        let sizesList = [size1, size2]
        let sizesJSON = makeJSON(of: sizesList)
        
        let product1 = ProductItem(
            name: "product1",
            imageURL: URL(string: "http://imageurl.com"),
            price: "0",
            onSale: false,
            salePrice: "0",
            sizes: sizesList
        )
        
        let product1JSON: [String: Any] = [
            "name": product1.name,
            "image": product1.imageURL!.absoluteString,
            "regular_price": product1.price,
            "on_sale": product1.onSale,
            "actual_price": product1.salePrice,
            "sizes": sizesJSON
        ]
        
        let product2 = ProductItem(
            name: "product2",
            imageURL: URL(string: "http://another-imageurl.com"),
            price: "2",
            onSale: true,
            salePrice: "1",
            sizes: sizesList
        )
        
        let product2JSON: [String: Any] = [
            "name": product2.name,
            "image": product2.imageURL!.absoluteString,
            "regular_price": product2.price,
            "on_sale": product2.onSale,
            "actual_price": product2.salePrice,
            "sizes": sizesJSON
        ]
        
        let productsJSON = [
            "products": [product1JSON, product2JSON]
        ]
        
        expect(sut, toCompleteWithResult: .success([product1, product2])) {
            let json = try! JSONSerialization.data(withJSONObject: productsJSON)
            client.complete(withStatusCode: 200, data: json)
        }
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-given-url.com")!) -> (sut: RemoteProductsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteProductsLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteProductsLoader, toCompleteWithResult result: RemoteProductsLoader.Result, file: StaticString = #file, line: UInt = #line, when action: () -> Void) {
        var capturedResults = [RemoteProductsLoader.Result]()
        sut.load { capturedResults.append($0)}
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeJSON(of sizeList: [Size]) -> [[String: Any]] {
        let sizeListJSON: [[String : Any]] = sizeList.map { size in
            [
                "size": size.size,
                "available": size.available
            ]
        }
        return sizeListJSON
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }
}

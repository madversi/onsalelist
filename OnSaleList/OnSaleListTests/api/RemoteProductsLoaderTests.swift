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
        
        expect(sut, toCompleteWith: .failure(RemoteProductsLoader.Error.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemoteProductsLoader.Error.invalidData)) {
                let validJSON = makeProductsData([])
                client.complete(withStatusCode: code, data: validJSON, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteProductsLoader.Error.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoProductsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data("{\"products\": []}".utf8) // this creates a valid response with no items
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversProductsOn200HTTPResponseWithAProductsList() {
        let (sut, client) = makeSUT()
        
        let size1 = Size(size: "P", available: true)
        let size2 = Size(size: "G", available: false)
        let sizesList = [size1, size2]
        
        let product1 = makeProductItem(
            name: "product1",
            price: "2",
            salePrice: "1",
            sizes: sizesList
        )
        
        let product2 = makeProductItem(
            name: "product2",
            imageURL: URL(string: "http://image-url.com"),
            price: "3",
            onSale: true,
            salePrice: "2",
            sizes: sizesList
        )
        
        expect(sut, toCompleteWith: .success([product1.model, product2.model])) {
            let json = makeProductsData([product1.json, product2.json])
            client.complete(withStatusCode: 200, data: json)
        }
        
    }
    
    func test_load_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let url = URL(string: "http://url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteProductsLoader? = RemoteProductsLoader(url: url, client: client)
        
        var capturedResults = [RemoteProductsLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeProductsData([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteProductsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteProductsLoader(url: url, client: client)
        checkForMemoryLeaks(sut, file: file, line: line)
        checkForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func checkForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should've been deallocated. This can be a memory leak.", file: file, line: line)
        }
    }
    
    private func expect(_ sut: RemoteProductsLoader, toCompleteWith expectedResult: RemoteProductsLoader.Result, file: StaticString = #filePath, line: UInt = #line, when action: () -> Void) {
        let loadExpectation = expectation(description: "Wait for load to finish")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedProducts), .success(expectedProducts)):
                XCTAssertEqual(receivedProducts, expectedProducts, file: file, line: line)
            case let (.failure(receivedError as RemoteProductsLoader.Error), .failure(expectedError as RemoteProductsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but got \(receivedResult).")
            }
            loadExpectation.fulfill()
        }
        
        action()
        waitForExpectations(timeout: 1.0)
        
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
    
    private func makeProductItem(name: String, imageURL: URL? = nil, price: String, onSale: Bool = false, salePrice: String, sizes: [Size]) -> (model: ProductItem, json: [String: Any]) {
        let productModel = ProductItem(name: name, imageURL: imageURL, price: price, onSale: onSale, salePrice: salePrice, sizes: sizes)
        
        let productJSON: [String: Any] = [
            "name": productModel.name,
            "image": productModel.imageURL?.absoluteString as Any,
            "regular_price": productModel.price,
            "on_sale": productModel.onSale,
            "actual_price": productModel.salePrice,
            "sizes": makeJSON(of: productModel.sizes)
        ]
        
        return (productModel, productJSON)
    }
    
    private func makeProductsData(_ products: [[String: Any]]) -> Data {
        let producsJSON = ["products": products]
        return try! JSONSerialization.data(withJSONObject: producsJSON)
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
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
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

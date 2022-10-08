//
//  PullReqLoaderTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest
import Alamofire
@testable import GitHub

class PullReqLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        sut.load {_ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        var captureError = [RemotePullRequestLoader.Error]()
        sut.load {
            captureError.append($0)
        }
        let error = NSError(domain: "Test", code: 0)
        client.complete(with: error, at: 0)
        XCTAssertEqual(captureError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200StatusCode() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        let invalidStatusCodes = [199, 300, 400, 404, 500]
        invalidStatusCodes.enumerated().forEach { index, code in
            var captureError = [RemotePullRequestLoader.Error]()
            sut.load {
                captureError.append($0)
            }
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(captureError, [.invalidData])
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidJSON() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        var captureError = [RemotePullRequestLoader.Error]()
        sut.load {
            captureError.append($0)
        }
        let invalidJson = Data.init(bytes: "InvalidJSON".utf8)
        client.complete(withStatusCode: 200, data: invalidJson)
        XCTAssertEqual(captureError, [.invalidData])
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!) -> (sut: RemotePullRequestLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePullRequestLoader(url: url, client: client)
        return (sut: sut, client: client)
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
        
        func complete(withStatusCode statusCode: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}





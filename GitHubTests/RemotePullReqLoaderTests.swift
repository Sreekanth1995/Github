//
//  PullReqLoaderTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest
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
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!) -> (sut: RemotePullRequestLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePullRequestLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Error) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }
}





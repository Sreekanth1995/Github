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
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let client = HTTPClientSpy()
        _ = RemotePullRequestLoader(url: url, client: client)
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let client = HTTPClientSpy()
        let sut = RemotePullRequestLoader(url: url, client: client)
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!) -> (sut: RemotePullRequestLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePullRequestLoader(url: url, client: client)
        sut.load()
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}





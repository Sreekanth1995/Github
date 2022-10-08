//
//  PullReqLoaderTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest

class RemotePullRequestLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}


class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

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
}





//
//  PullReqLoaderTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest

class RemotePullRequestLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
    
}

class PullReqLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemotePullRequestLoader()
        XCTAssertNil(client.requestedURL)
    }
    
}





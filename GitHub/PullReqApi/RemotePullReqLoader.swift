//
//  RemotePullReqLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

final class RemotePullRequestLoader {
    private let client: HTTPClient
    private let url: URL
    
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

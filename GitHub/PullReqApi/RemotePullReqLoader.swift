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
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Error) -> Void) {
        client.get(from: url, completion: { error in
            completion(.connectivity)
        })
    }
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

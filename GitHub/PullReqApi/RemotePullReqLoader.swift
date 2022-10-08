//
//  RemotePullReqLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(Error)
}


protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

final class RemotePullRequestLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Error) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success(let response):
                completion(.invalidData)
            case .failure(let error):
                completion(.connectivity)
            }
        })
    }
}


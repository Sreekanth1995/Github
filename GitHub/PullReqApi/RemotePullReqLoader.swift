//
//  RemotePullReqLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

final class RemotePullRequestLoader {
    private let client: HTTPClient
    private let url: URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    enum Result: Equatable {
        case success([PullRequest])
        case failure(Error)
    }
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case .success(let data, let response):
                if response.statusCode == 200, let json = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(json.map { $0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        })
    }
}

private typealias Root = [PullRequestObj]
private struct PullRequestObj: Decodable {
    let url: URL
    let id: Int
    let state: String
    let title: String?
    let created_at: String?
    let closed_at: String?
    let body: String?
    
    var item: PullRequest {
        return PullRequest(id: id,
                           url: url,
                           state: state,
                           body: body,
                           title: title,
                           createdAt: created_at,
                           closedAt: closed_at)
    }
}

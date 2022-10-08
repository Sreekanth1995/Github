//
//  RemotePullReqLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

final class RemotePullRequestLoader: PullRequestsLoader {
    private let client: HTTPClient
    private let url: URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = PullRequestsLoader.Result

    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(_ completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data, let response):
                completion(PRItemsMapper.map(data: data, response: response))
            case .failure:
                completion(PullRequestsLoader.Result.failure(Error.connectivity))
            }
        })
    }    
}

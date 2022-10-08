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
                if let prs = try? PRItemsMapper.map(data: data, response: response) {
                    completion(.success(prs))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        })
    }
}

private class PRItemsMapper {
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
    
    static func map(data: Data, response: HTTPURLResponse) throws  -> [PullRequest] {
        guard response.statusCode == 200 else {
            throw RemotePullRequestLoader.Error.invalidData
        }
        let json = try JSONDecoder().decode(Root.self, from: data)
        return json.map { $0.item }
    }
}

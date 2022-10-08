//
//  PullRequestMapper.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

internal final class PRItemsMapper {
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
    
    static func map(data: Data, response: HTTPURLResponse) -> RemotePullRequestLoader.Result {
        guard response.statusCode == 200 else {
            return .failure(.invalidData)
        }
        do {
            let json = try JSONDecoder().decode(Root.self, from: data)
            return .success(json.map { $0.item })
        } catch {
            return .failure(.invalidData)
        }
    }
}

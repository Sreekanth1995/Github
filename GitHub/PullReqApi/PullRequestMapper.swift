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
        struct UserObj: Decodable {
            let login: String?
            let avatar_url: String?
        }
        
        struct BaseObj: Decodable {
            struct RepoObj: Decodable {
                let full_name: String?
            }
            let repo: RepoObj?
        }
        
        let url: URL
        let id: Int
        let number: Int
        let state: String
        let title: String?
        let created_at: String?
        let closed_at: String?
        let body: String?
        let user: UserObj?
        let base: BaseObj?
        
        var item: PullRequest {
            return PullRequest(id: id,
                               url: url,
                               number: number,
                               state: state,
                               body: body,
                               title: title,
                               createdAt: created_at,
                               closedAt: closed_at,
                               userName: user?.login,
                               userImage: URL(string: user?.avatar_url ?? ""),
                               repo: base?.repo?.full_name)
        }
    }
    
    
    static func map(data: Data, response: HTTPURLResponse) -> RemotePullRequestLoader.Result {
        guard response.statusCode == 200 else {
            return .failure(RemotePullRequestLoader.Error.invalidData)
        }
        do {
            let json = try JSONDecoder().decode(Root.self, from: data)
            return .success(json.map { $0.item })
        } catch {
            return .failure(RemotePullRequestLoader.Error.invalidData)
        }
    }
}

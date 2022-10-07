//
//  PullRequest.swift
//  GitHub
//
//  Created by M sreekanth  on 07/10/22.
//

import Foundation

struct PullRequest: Codable {
    let url: String?
    let id: Int?
    let node_id: String?
    let html_url: String?
    let diff_url: String?
    let patch_url: String?
    let issue_url: String?
    let number: Int?
    let state: String?
    let locked: Bool?
    let title: String?
    let body: String?
    let created_at: String?
    let updated_at: String?
    let closed_at: String?
    let merged_at: String?
    let merge_commit_sha: String?
    let assignee: String?
    let assignees: [String]?
    let requested_reviewers: [String]?
    let requested_teams: [String]?
    let labels: [String]?
    let milestone: String?
    let draft: Bool?
    let commits_url: String?
    let review_comments_url: String?
    let review_comment_url: String?
    let comments_url: String?
    let statuses_url: String?
    let author_association: String?
    let auto_merge: String?
    let active_lock_reason: String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case id = "id"
        case node_id = "node_id"
        case html_url = "html_url"
        case diff_url = "diff_url"
        case patch_url = "patch_url"
        case issue_url = "issue_url"
        case number = "number"
        case state = "state"
        case locked = "locked"
        case title = "title"
        case body = "body"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case closed_at = "closed_at"
        case merged_at = "merged_at"
        case merge_commit_sha = "merge_commit_sha"
        case assignee = "assignee"
        case assignees = "assignees"
        case requested_reviewers = "requested_reviewers"
        case requested_teams = "requested_teams"
        case labels = "labels"
        case milestone = "milestone"
        case draft = "draft"
        case commits_url = "commits_url"
        case review_comments_url = "review_comments_url"
        case review_comment_url = "review_comment_url"
        case comments_url = "comments_url"
        case statuses_url = "statuses_url"
        case author_association = "author_association"
        case auto_merge = "auto_merge"
        case active_lock_reason = "active_lock_reason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        node_id = try values.decodeIfPresent(String.self, forKey: .node_id)
        html_url = try values.decodeIfPresent(String.self, forKey: .html_url)
        diff_url = try values.decodeIfPresent(String.self, forKey: .diff_url)
        patch_url = try values.decodeIfPresent(String.self, forKey: .patch_url)
        issue_url = try values.decodeIfPresent(String.self, forKey: .issue_url)
        number = try values.decodeIfPresent(Int.self, forKey: .number)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        locked = try values.decodeIfPresent(Bool.self, forKey: .locked)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        closed_at = try values.decodeIfPresent(String.self, forKey: .closed_at)
        merged_at = try values.decodeIfPresent(String.self, forKey: .merged_at)
        merge_commit_sha = try values.decodeIfPresent(String.self, forKey: .merge_commit_sha)
        assignee = try values.decodeIfPresent(String.self, forKey: .assignee)
        assignees = try values.decodeIfPresent([String].self, forKey: .assignees)
        requested_reviewers = try values.decodeIfPresent([String].self, forKey: .requested_reviewers)
        requested_teams = try values.decodeIfPresent([String].self, forKey: .requested_teams)
        labels = try values.decodeIfPresent([String].self, forKey: .labels)
        milestone = try values.decodeIfPresent(String.self, forKey: .milestone)
        draft = try values.decodeIfPresent(Bool.self, forKey: .draft)
        commits_url = try values.decodeIfPresent(String.self, forKey: .commits_url)
        review_comments_url = try values.decodeIfPresent(String.self, forKey: .review_comments_url)
        review_comment_url = try values.decodeIfPresent(String.self, forKey: .review_comment_url)
        comments_url = try values.decodeIfPresent(String.self, forKey: .comments_url)
        statuses_url = try values.decodeIfPresent(String.self, forKey: .statuses_url)
        author_association = try values.decodeIfPresent(String.self, forKey: .author_association)
        auto_merge = try values.decodeIfPresent(String.self, forKey: .auto_merge)
        active_lock_reason = try values.decodeIfPresent(String.self, forKey: .active_lock_reason)
    }

}

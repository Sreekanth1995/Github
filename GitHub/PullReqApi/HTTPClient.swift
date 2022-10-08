//
//  HTTPClient.swift
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

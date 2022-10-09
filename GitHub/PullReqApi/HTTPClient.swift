//
//  HTTPClient.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

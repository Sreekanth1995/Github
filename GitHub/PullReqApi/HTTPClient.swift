//
//  HTTPClient.swift
//  GitHub
//
//  Created by M sreekanth  on 08/10/22.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

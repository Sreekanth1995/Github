//
//  UserImageDataLoader.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation
import Alamofire
public protocol UserImageDataLoaderTask {
    func cancel()
}

public protocol UserImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (UserImageDataLoader.Result) -> Void) -> UserImageDataLoaderTask
}

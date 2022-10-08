//
//  AlamofireHTTPClient.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation
import Alamofire

class AlamofireHTTPClient: HTTPClient {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.request(url)
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(HTTPClient.Result.success((data, dataResponse.response!)))
                case .failure(let err):
                    completion(HTTPClient.Result.failure(err))
                }
            }
    }
}


//
//  AlamofireHttpClientTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest
import Alamofire
@testable import GitHub

class AlamofireHTTPClientTests: XCTestCase {
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        let (sut, sessionSpy) = makeSUT(url: url)
        sessionSpy.observeRequests { request in
            XCTAssertEqual(request.convertible.urlRequest?.url, url)
            XCTAssertEqual(request.convertible.urlRequest?.httpMethod, "GET")
            exp.fulfill()
        }
        
        sut.get(from: url) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL, file: StaticString = #file, line: UInt = #line) -> (sut: HTTPClient, spy: SessionSpy) {
        let sessionSpy = SessionSpy()
        let sut = AlamofireHTTPClient(session: sessionSpy)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, sessionSpy)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private class SessionSpy: Session {
        private var requestObserver: ((DataRequest) -> Void)?
        private var stubs = [URL: AFDataResponse<Data>]()
        
        func observeRequests(observer: @escaping (DataRequest) -> Void) {
            requestObserver = observer
        }
        
        override func request(_ convertible: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: HTTPHeaders? = nil,
                              interceptor: RequestInterceptor? = nil,
                              requestModifier: RequestModifier? = nil) -> DataRequest {
            
            let dataRequest = super.request(convertible)
            requestObserver?(dataRequest)
            return dataRequest
        }
    }
    
}

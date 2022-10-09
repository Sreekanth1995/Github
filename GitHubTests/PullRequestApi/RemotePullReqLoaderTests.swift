//
//  PullReqLoaderTests.swift
//  GitHubTests
//
//  Created by M sreekanth  on 08/10/22.
//

import XCTest
import Alamofire
@testable import GitHub

class PullReqLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=1&per_page=10")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        sut.load {_ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(RemotePullRequestLoader.Error.connectivity), when: {
            let error = NSError(domain: "Test", code: 0)
            client.complete(with: error, at: 0)
        })
    }
    
    func test_load_deliversErrorOnNon200StatusCode() {
        let (sut, client) = makeSUT()
        let invalidStatusCodes = [199, 300, 400, 404, 500]
        invalidStatusCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(RemotePullRequestLoader.Error.invalidData), when: {
                let json = makeItemJson(items: [])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(RemotePullRequestLoader.Error.invalidData), when: {
            let invalidJson = Data("InvalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }
    
    func test_load_deliversNoItemsOn200ResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJson = makeItemJson(items: [])
            client.complete(withStatusCode: 200, data: emptyListJson)
        })
    }

    func test_load_deliverItemsOn200ResponseWithJSONData() {
        let (sut, client) = makeSUT()
        let obj1 = makeItem(id: 1076581210,
                            url: URL(string:"https://api.github.com/repos/apple/swift/pulls/61443")!,
                            state: "open",
                            body: "When an anonymous enum is imported",
                            title: "Respect NS_REFINED_FOR_SWIFT importing anon enums",
                            createdAt: "2022-10-04T22:41:36Z",
                            closedAt: nil)
        
        let obj2 = makeItem(id: 1077335864,
                            url: URL(string: "https://api.github.com/repos/apple/swift/pulls/61447")!,
                            state: "closed",
                            body: "They fail on arm64e on some bots.\r\n\r\nrdar://100805115",
                            title: "Disable Reflection/typeref_decoding(_asan).swift tests",
                            createdAt: "2022-10-05T13:22:32Z",
                            closedAt: "2022-10-05T13:24:39Z")
        let array = [obj1.json, obj2.json]
        let items = [obj1.model, obj2.model]
        expect(sut, toCompleteWithResult: .success(items), when: {
            let data = makeItemJson(items: array)
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTDeallocated() {
        let url = URL(string:"https://api.github.com/repos/apple/swift/pulls")!
        let client = HTTPClientSpy()
        var sut: RemotePullRequestLoader? = RemotePullRequestLoader(url: url, client: client)
        
        var captureResult = [RemotePullRequestLoader.Result]()
        sut?.load {
            captureResult.append($0)
        }
        sut = nil
        let emptyListJson = makeItemJson(items: [])
        client.complete(withStatusCode: 200, data: emptyListJson)
        XCTAssertTrue(captureResult.isEmpty)
    }
    
    // MARK: Helpers
    
    private func expect(_ sut: RemotePullRequestLoader,
                        toCompleteWithResult expectedResult: RemotePullRequestLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for the load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(reveivedError as RemotePullRequestLoader.Error), .failure(expectedError as RemotePullRequestLoader.Error)):
                XCTAssertEqual(reveivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePullRequestLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePullRequestLoader(url: url, client: client)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        trackMemoryLeaks(instance: client, file: file, line: line)
        return (sut: sut, client: client)
    }
    
    private func makeItem(id: Int,
                          url: URL,
                          state: String,
                          body: String?,
                          title: String?,
                          createdAt: String?,
                          closedAt: String?) -> (model: PullRequest, json: [String: Any]) {
        let pullRequest = PullRequest(id: id,
                                      url: url,
                                      state: state,
                                      body: body,
                                      title: title,
                                      createdAt: createdAt,
                                      closedAt: closedAt)
        let jsonObject: [String: Any?] = [
            "id": id,
            "url": url.absoluteString,
            "state": state,
            "body": body,
            "title": title,
            "created_at": createdAt,
            "closed_at": closedAt
        ]
        return (model: pullRequest, json: jsonObject.compactMapValues { $0 })
    }
    
    private func makeItemJson(items: [[String: Any]]) -> Data {
        let data = try! JSONSerialization.data(withJSONObject: items)
        return data
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode statusCode: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}







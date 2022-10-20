//
//  GitHubiOSTests.swift
//  GitHubiOSTests
//
//  Created by M sreekanth  on 09/10/22.
//

import XCTest
import UIKit
@testable import GitHub

final class PullsViewControllerTests: XCTestCase {
    
    func test_loadPullsActions_requestPullsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.callCount, 0)
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.callCount, 1)

        sut.simulateUserInitiatedPullsLoad()
        XCTAssertEqual(loader.callCount, 2)

        sut.simulateUserInitiatedPullsLoad()
        XCTAssertEqual(loader.callCount, 3)
    }
    
    func test_viewdidLoad_showsLoadingIndicator() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        
        loader.completePullsLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)

        sut.simulateUserInitiatedPullsLoad()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)

        loader.completePullsLoading(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
        
    }
    
    func test_loadPullsCompletion_rendersSuccessfullyLoadedPulls() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfRenderItems(), 0)
        let model = makeModel()
        loader.completePullsLoading(with: [model], at: 0)
        XCTAssertEqual(sut.numberOfRenderItems(), 1)
    }
    
    func test_loadPullsCompletion_failedwithError() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertNil(sut.errorMessage())
        loader.completeFetchingWithError()
        XCTAssertNotNil(sut.errorMessage())
    }
    
    func test_loadPullsCompleteion_inBackgroundThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        let model = makeModel()
        let exp = expectation(description: "Wait to complete completion in background thread")
        DispatchQueue.global(qos: .background).async {
            loader.completePullsLoading(with: [model], at: 0)
            DispatchQueue.main.async {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(sut.numberOfRenderItems(), 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: PullsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PullReqUIComposer.pullReqsCompose(with: loader, imageLoader: loader)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        trackMemoryLeaks(instance: loader, file: file, line: line)
        return (sut: sut, loader: loader)
    }
    
    private func makeModel() -> PullRequest {
        return PullRequest(id: 1080926538,
                           url: URL(string: "https://api.github.com/repos/apple/swift/pulls/61503")!,
                           number: 30332,
                           state: "closed",
                           body: "The initial implementation of SILGen for `if #_hasSymbol` will assume it is targeting Darwin so we should diagnose attempts to use the feature on other platforms.",
                           title: "Sema: Diagnose `if #_hasSymbol` as unsupported on non-Darwin targets",
                           createdAt: "2022-10-08T05:19:34Z",
                           closedAt: "2022-10-09T01:14:54Z",
                           userName: "tshortli",
                           userImage: URL(string: "https://avatars.githubusercontent.com/u/16380168?v=4"),
                           repo: "apple/swift")
    }

    
    class LoaderSpy: PullRequestsLoader, UserImageDataLoader {
        
        var completions = [((PullRequestsLoader.Result) -> Void)]()
        var callCount: Int {
            return completions.count
        }
        
        func load(_ completion: @escaping (PullRequestsLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completePullsLoading(with pulls:[PullRequest] = [], at index: Int) {
            completions[index](.success(pulls))
        }
        
        func completeFetchingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
        
        // MARK: UserImageDataLoader
        private struct TaskSpy: UserImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (UserImageDataLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (UserImageDataLoader.Result) -> Void) -> UserImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}

extension PullsViewController {
    func simulateUserInitiatedPullsLoad() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing ?? false
    }
    
    func numberOfRenderItems() -> Int {
        return tableView.numberOfRows(inSection: 0)
    }
    
    func errorMessage() -> String? {
        return errorView.message
    }
}

extension XCTestCase {
    func trackMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
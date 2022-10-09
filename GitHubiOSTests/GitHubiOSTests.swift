//
//  GitHubiOSTests.swift
//  GitHubiOSTests
//
//  Created by M sreekanth  on 09/10/22.
//

import XCTest
import UIKit
@testable import GitHub

final class PullsViewController: UITableViewController {
    let loader: PullRequestsLoader
    init(loader: PullRequestsLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadPulls), for: .valueChanged)
        refreshControl?.beginRefreshing()
        loadPulls()
    }
    
    @objc func loadPulls() {
        loader.load() {[weak self] _ in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class PullsViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadPullsOnInitialisation() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.callCount, 0)
    }
    
    func test_viewDidLoad_loadPulls() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.callCount, 1)
    }
    
    func test_pullsToRefresh_loadPulls() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.callCount, 2)
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.callCount, 3)
    }
    
    func test_viewdidLoad_showLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_viewdidLoad_hidesLoadingIndicatorOnPullsLoad() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completePullsLoading()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://api.github.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: PullsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PullsViewController(loader: loader)
        trackMemoryLeaks(instance: sut, file: file, line: line)
        trackMemoryLeaks(instance: loader, file: file, line: line)
        return (sut: sut, loader: loader)
    }

    
    class LoaderSpy: PullRequestsLoader {
        
        var completions = [((PullRequestsLoader.Result) -> Void)]()
        var callCount: Int {
            return completions.count
        }
        
        func load(_ completion: @escaping (PullRequestsLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completePullsLoading() {
            completions[0](.success([]))
        }
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

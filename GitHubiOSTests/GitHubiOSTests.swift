//
//  GitHubiOSTests.swift
//  GitHubiOSTests
//
//  Created by M sreekanth  on 09/10/22.
//

import XCTest
import UIKit

final class PullsViewController: UIViewController {
    let loader: PullsViewControllerTests.LoaderSpy
    init(loader: PullsViewControllerTests.LoaderSpy) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.load()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


final class PullsViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadPullsOnInitialisation() {
        let spy = LoaderSpy()
        _ = PullsViewController(loader: spy)
        XCTAssertEqual(spy.callCount, 0)
    }
    
    func test_viewDidLoad_loadPulls() {
        let spy = LoaderSpy()
        let sut = PullsViewController(loader: spy)
        sut.loadViewIfNeeded()
        XCTAssertEqual(spy.callCount, 1)
    }
    
    
    class LoaderSpy {
        private(set) var callCount: Int = 0
        
        func load() {
            callCount += 1
        }
    }
    
}

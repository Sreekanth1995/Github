//
//  XCTestCase+MemoryLeakTracking.swift
//  GitHubTests
//
//  Created by M sreekanth  on 09/10/22.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

//
//  MainQueueDispatchDecorator.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decorator: T
    
    init(_ decorator: T) {
        self.decorator = decorator
    }
    
    private func dispatch(_ completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async(execute: completion)
        }
    }
}

extension MainQueueDispatchDecorator: PullRequestsLoader where T == PullRequestsLoader {
    func load(_ completion: @escaping (PullRequestsLoader.Result) -> Void) {
        decorator.load {[weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

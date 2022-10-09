//
//  UserImageViewModel.swift
//  GitHub
//
//  Created by M sreekanth  on 09/10/22.
//

import Foundation

final class PullViewModel<Image> {
    enum State: String {
        case open
        case closed
    }
    
    typealias Observer<T> = (T) -> Void
    
    private var task: UserImageDataLoaderTask?
    private let model: PullRequest
    private let imageLoader: UserImageDataLoader
    private let imageTransformer: (Data) -> Image?
    private var userImageData: Data?
    
    init(model: PullRequest, imageLoader: UserImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var repoName: String? {
        return "\(model.repo ?? "") #\(model.number)"
    }
    
    var title: String? {
        return model.title
    }
    
    var stateIcon: String {
        return model.state + "Icon"
    }
    
    var userName: String {
        return model.userName ?? ""
    }
    
    var createdAt: String? {
        let formatedDate = model.createdAt?.toDate(formate: Date.backendFormat)?.toString(formate: Date.appFormat)
        return formatedDate
    }
    
    var closedAt: String? {
        let formatedDate = model.closedAt?.toDate(formate: Date.backendFormat)?.toString(formate: Date.appFormat)
        return formatedDate
    }
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        if let data = userImageData, let image = imageTransformer(data) {
            onImageLoad?(image)
        } else {
            task = imageLoader.loadImageData(from: model.url) { [weak self] result in
                self?.handle(result)
            }
        }
    }
    
    private func handle(_ result: UserImageDataLoader.Result) {
        if let data = try? result.get(), let image = imageTransformer(data) {
            userImageData = data
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}

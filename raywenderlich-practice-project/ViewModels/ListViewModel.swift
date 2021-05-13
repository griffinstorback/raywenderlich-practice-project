//
//  ListViewModel.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-05.
//

import Foundation
import UIKit
import Combine

class ListViewModel {
    let networkManager: NetworkManagerProtocol
    var cancellables = Set<AnyCancellable>()

    var items = CurrentValueSubject<[Item], Never>([])
    var displayingTypes: DisplayItemType = .both {
        didSet {
            updateItems()
        }
    }
    
    private var articles: [Item] = [] {
        didSet {
            updateItems()
        }
    }
    private var videos: [Item] = [] {
        didSet {
            updateItems()
        }
    }
    
    private func updateItems() {
        switch displayingTypes {
        case .articles:
            items.send(articles)
        case .videos:
            items.send(videos)
        case .both:
            items.send(articles + videos)
        }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        
        //loadArticlesAndVideosViaClosure()
        loadArticlesAndVideosViaPublishers()
    }
    
    func loadArticlesAndVideosViaClosure() {
        networkManager.getArticlesViaClosure { articles, error in
            if let error = error {
                return
            }
            if let articles = articles {
                self.articles = articles
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.networkManager.getVideosViaClosure { videos, error in
                if let error = error {
                    return
                }
                if let videos = videos {
                    self.videos = videos
                }
            }
        }
    }
    
    func loadArticlesAndVideosViaPublishers() {
        let articlesPublisher = networkManager.getArticlesViaPublisher()
        articlesPublisher.sink(receiveCompletion: { completion in
            print("** ARTICLES PUBLISHER COMPLETION: \(completion)")
        }, receiveValue: { articles in
            self.articles = articles
        }).store(in: &cancellables)
        
        let videosPublisher = networkManager.getVideosViaPublisher()
        DispatchQueue.main.async {
            videosPublisher.sink(receiveCompletion: { completion in
                print("** VIDEOS PUBLISHER COMPLETION: \(completion)")
            }, receiveValue: { videos in
                self.videos = videos
            }).store(in: &self.cancellables)
        }
    }
    
    func getImage(fromURL: String, completion: @escaping (UIImage?, APIError?) -> Void) {
        networkManager.getImageViaClosure(fromURL: fromURL) { image, error in
            DispatchQueue.main.async {
                completion(image, error)
            }
        }
    }
}

//
//  NetworkManager.swift
//  raywenderlich-practice-project
//
//  Created by Griffin Storback on 2021-05-04.
//

import Foundation
import UIKit
import Combine

struct UnableToDecodeError: Error {
    var errorDescription: String = "Unable to decode the data."
}

struct InvalidURLError: Error {
    var errorDescription: String = "The image url was invalid."
}

struct APIError {
    var error: Error
}

protocol NetworkManagerProtocol {
    func getArticlesViaClosure(completion: @escaping ([Item]?, APIError?) -> Void)
    func getVideosViaClosure(completion: @escaping ([Item]?, APIError?) -> Void)
    func getItemsViaClosure(url: URL, completion: @escaping ([Item]?, APIError?) -> Void)
    func getImageViaClosure(fromURL: String, completion: @escaping (UIImage?, APIError?) -> Void)
    
    func getArticlesViaPublisher() -> AnyPublisher<[Item], Error>
    func getVideosViaPublisher() -> AnyPublisher<[Item], Error>
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() { }
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    let urlBasePath = "https://raw.githubusercontent.com/raywenderlich/ios-interview/master/Practical%20Example"
    let articlesURLString = "https://raw.githubusercontent.com/raywenderlich/ios-interview/master/Practical%20Example/articles.json"
    let videosURLString = "https://raw.githubusercontent.com/raywenderlich/ios-interview/master/Practical%20Example/videos.json"
    
    func getArticlesViaClosure(completion: @escaping ([Item]?, APIError?) -> Void) {
        guard let articlesURL = URL(string: articlesURLString) else {
            completion(nil, APIError(error: InvalidURLError()))
            return
        }
        getItemsViaClosure(url: articlesURL, completion: completion)
    }
    
    func getVideosViaClosure(completion: @escaping ([Item]?, APIError?) -> Void) {
        guard let videosURL = URL(string: videosURLString) else {
            completion(nil, APIError(error: InvalidURLError()))
            return
        }
        getItemsViaClosure(url: videosURL, completion: completion)
    }
    
    func getItemsViaClosure(url: URL, completion: @escaping ([Item]?, APIError?) -> Void) {
        let urlSession = URLSession.shared
        let articlesRequest = URLRequest(url: url)
        
        urlSession.dataTask(with: articlesRequest) { data, response, error in
            if let error = error {
                print("ERROR getting articles: \(error)")
                completion(nil, APIError(error: error))
                return
            }
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let itemData = try JSONDecoder().decode(ItemAPIResponse.self, from: data)
                    completion(itemData.data, nil)
                } catch {
                    completion(nil, APIError(error: error))
                }
            }
            
        }.resume()
    }
    
    func getImageViaClosure(fromURL: String, completion: @escaping (UIImage?, APIError?) -> Void) {
        guard let imageURL = URL(string: fromURL) else {
            completion(nil, APIError(error: InvalidURLError()))
            return
        }
        
        // retrieve the image from cache if possible
        /*if let cachedImage = imageCache.object(forKey: fromURL as NSString) as? UIImage {
            completion(cachedImage, nil)
            return
        }*/
        
        // retrieve the image from the network (and insert it into cache)
        let session = URLSession.shared
        session.dataTask(with: URLRequest(url: imageURL)) { data, response, error in
            if let error = error {
                completion(nil, APIError(error: error))
                return
            }
            if let data = data, let response = response as? HTTPURLResponse {
                if let retrievedImage = UIImage(data: data) {
                    self.imageCache.setObject(retrievedImage, forKey: fromURL as NSString)
                    completion(retrievedImage, nil)
                } else {
                    completion(nil, APIError(error: UnableToDecodeError()))
                }
            }
        }.resume()
    }
    
    
    // Publisher variations
    //
    func getArticlesViaPublisher() -> AnyPublisher<[Item], Error> {
        let url = URL(string: articlesURLString)!
        /*guard let url = URL(string: articlesURLString) else {
            return AnyPublisher<Item, InvalidURLError>
        }*/
                
        return getItemsViaPublisher(from: url)
    }
    
    func getVideosViaPublisher() -> AnyPublisher<[Item], Error> {
        let url = URL(string: videosURLString)!
        
        return getItemsViaPublisher(from: url)
    }
    
    func getItemsViaPublisher(from url: URL) -> AnyPublisher<[Item], Error> {
        let session = URLSession.shared
        
        let pub = session.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: ItemAPIResponse.self, decoder: JSONDecoder())
            .map(\.data)
            .eraseToAnyPublisher()
        
        return pub
    }
}

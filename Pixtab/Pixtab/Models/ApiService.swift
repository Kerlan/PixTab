//
//  ApiService.swift
//  Pixtab
//
//  Created by Kerlan PLUMASSEAU on 23/02/2023.
//

import Foundation
import UIKit

class ApiService {
    static var shared = ApiService()
    private init() {}
    
    private static let apiUrl: String = "https://pixabay.com/api/"
    private static let apiKey: String = "18021445-326cf5bcd3658777a9d22df6f"
    
    private static var task: URLSessionDataTask?
    
    func fetchImages(search: String, page: String, completionHandler: @escaping (Bool, String, [ImageData]?) -> Void) {
        guard var urlComponents: URLComponents = URLComponents(string: ApiService.apiUrl) else {
            completionHandler(false, "Error in urlComponents", nil)
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: ApiService.apiKey),
            URLQueryItem(name: "q", value: search),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: "18")
        ]
        
        guard let url: URL = urlComponents.url else {
            completionHandler(false, "Error in urlComponents.url", nil)
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        ApiService.task?.cancel()
        ApiService.task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(false, "Error in data or error is not nil", nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(false, "Error in response", nil)
                    return
                }
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]  else {
                    completionHandler(false, "Error in serialization", nil)
                    return
                }
                guard let hits = responseJSON["hits"] as? [[String : Any]] else {
                    completionHandler(false, "Error in hits", nil)
                    return
                }
                self.getImagesInResponse(hits: hits) { (images) in
                    completionHandler(true, "Data received", images)
                }
            }
        })
        ApiService.task?.resume()
    }
    
    private func getImagesInResponse(hits: [[String : Any]], completionHandler: @escaping ([ImageData]) -> Void) {
        var images: [ImageData] = []
        
        for hit in hits {
            if let imageUrl = hit["webformatURL"] as? String, let id = hit["id"] as? Int {
                guard let url = URL(string: imageUrl) else {
                    return
                }
                guard let data: Data = try? Data(contentsOf: url) else {
                    return
                }
                guard let image = UIImage(data: data) else {
                    return
                }
                images.append(ImageData(id: id, image: image, isSelected: false))
            }
        }
        completionHandler(images)
    }
}

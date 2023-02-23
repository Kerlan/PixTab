//
//  ImageService.swift
//  Pixtab
//
//  Created by Kerlan PLUMASSEAU on 23/02/2023.
//

import Foundation

class ImageService {
    static var shared = ImageService()
    private init() {}
    
    private static var task: URLSessionDataTask?
    
    func getImage(imageUrl: String, completionHandler: @escaping ((Data?) -> Void)) {
        guard let imageUrl = URL(string: imageUrl) else {
            completionHandler(nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        
        ImageService.task?.cancel()
        ImageService.task = session.dataTask(with: imageUrl) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        completionHandler(data)
                    }
                }
            }
        }
        ImageService.task?.resume()
    }
}

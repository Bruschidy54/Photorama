//
//  PhotoStore.swift
//  Photorama
//
//  Created by Dylan Bruschi on 3/3/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import Foundation

class PhotoStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos() {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            
            if let jsonData = data {
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    print(jsonString)
            }
        }
        else if let requestError = error {
            print("Error fetching recent photos: \(requestError)")
        }
        else {
            print("Unexpected error with the request")
        }
    }
    task.resume()
}
}

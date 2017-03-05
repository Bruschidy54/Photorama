//
//  PhotoStore.swift
//  Photorama
//
//  Created by Dylan Bruschi on 3/3/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}

class PhotoStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            
            let result = self.processRecentPhotosRequest(data: data as NSData?, error: error as NSError?)
            
            completion(result)
    }
    task.resume()
}
    
    func processRecentPhotosRequest(data: NSData?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        let photoURL = photo.remoteURL
        let request = NSURLRequest(url: photoURL as URL)
        
       let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
        
        let result = self.processImageRequest(data: data as NSData?, error: error as NSError?)
        
        if case let .Success(image) = result {
            photo.image = image
        }
        completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data: NSData?, error: NSError?) ->ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData as Data) else {
            
            // Couldn't create an image
            if data == nil {
                return .Failure(error!)
                
            }
            else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        return .Success(image)
    }
}

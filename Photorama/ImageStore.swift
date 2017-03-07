//
//  ImageStore.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/23/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        
        // Create full URL for image
        let imageURL = imageURLForKey(key: key)
        
        // Turn image into PNG data
        if let pngData = UIImagePNGRepresentation(image) {
            do {
           try pngData.write(to: imageURL as URL)
            } catch let pngError {
                print("error occured \(pngError)")
            }
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        do {
        try FileManager.default.removeItem(at: imageURL as URL)
        }
        catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    func imageURLForKey(key: String) -> NSURL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key) as NSURL
    }
}

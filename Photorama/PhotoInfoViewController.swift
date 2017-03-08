//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Dylan Bruschi on 3/5/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo, completion: { (result) -> Void in
            switch result {
            case let .Success(image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTags" {
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        }
    }
}

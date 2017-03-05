//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Dylan Bruschi on 3/5/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(image: nil)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(image: nil)
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView.image = nil
    }
    }
    
}

//
//  Extentions.swift
//  ImageSearcher
//
//  Created by Phoenix on 30.11.17.
//  Copyright © 2017 Phoenix_Dev. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUseingCacheWith(urlString: String) {
        let url = URL(string: urlString)
        
        // check cache for image first
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        // if in cache image not found, download image from server
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }
    
}


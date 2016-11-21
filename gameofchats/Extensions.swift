//
//  Extensions.swift
//  gameofchats
//
//  Created by Umoru Joseph on 11/21/16.
//  Copyright © 2016 Umoru Joseph. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        self.image = nil
        
        let urlNSString = urlString as NSString
        //check for cached images
        if let cachedImages = imageCache.object(forKey: urlNSString) {
            self.image = cachedImages
            return
        }
        
        //download new images
        if let url = URL(string: urlString){
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, errorr) in
                
                //download hit an error so lets return out
                if let error = errorr {
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!){
                        imageCache.setObject(downloadedImage, forKey: urlNSString)
                        self.image = downloadedImage
                    }
                }
            })
            task.resume()
            
        }
    }
}

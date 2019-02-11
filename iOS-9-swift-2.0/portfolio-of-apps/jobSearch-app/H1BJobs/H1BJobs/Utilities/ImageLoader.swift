//
//  ImageLoader.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/2/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

// Image Caching References:
// https://teamtreehouse.com/community/does-anyone-know-how-to-show-an-image-from-url-with-swift
// http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-5-async-image-loading-and-caching/

import UIKit

class ImageLoader {
    
    var cache = NSCache<NSString, NSData>()
    
    class var sharedLoader: ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    // DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    func imageForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url:String) -> ()) {
        DispatchQueue.main.async( execute: {
            let data: NSData? = self.cache.object(forKey: urlString as NSString)
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL(string: urlString)!) { [weak self] data, response, error in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self?.cache.setObject(data! as NSData, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completionHandler(image, urlString)
                    }
                    return
                }

            }
            downloadTask.resume()
        })
    }
    
}

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
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    class var sharedLoader: ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url:String) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            let data = strongSelf.cache.object(forKey: urlString as AnyObject)
            
            if let goodData = data, let data = goodData as? Data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: {(data: Data?, response: URLResponse?, error: NSError?) -> Void in
                
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    strongSelf.cache.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async {
                        completionHandler(image, urlString)
                    }
                    return
                }
                
                } as! (Data?, URLResponse?, Error?) -> Void)
            downloadTask.resume()
            
        }
    }
    
}

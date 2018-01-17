//
//  UIImageView+Utils.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/2/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(_ link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            
        }).resume()
    }
}

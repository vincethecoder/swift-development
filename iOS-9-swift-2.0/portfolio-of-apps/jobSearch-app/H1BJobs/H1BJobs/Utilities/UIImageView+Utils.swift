//
//  UIImageView+Utils.swift
//  H1BJobs
//
//  Created by Kobe Sam on 1/2/16.
//  Copyright © 2016 vincethecoder. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        guard let url = URL(string: link)
            else {return}
        contentMode = mode
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }).resume()
    }
}

//
//  UIImage+Utils.swift
//  H1BJobs
//
//  Created by Kobe Sam on 12/31/15.
//  Copyright © 2015 vincethecoder. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageScaledToSize(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}

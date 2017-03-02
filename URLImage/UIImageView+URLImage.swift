//
//  UIImageView+URLImage.swift
//  URLImage
//
//  Created by Wayne Yeh on 2017/2/22.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit

private var gradientKey: UInt8 = 0
extension UIImageView: URLImageDelegate {
    var urlImage: URLImage {
        let image = URLImage()
        image.delegate = self

        return image
    }
    
    // MARK - URLImageDelegate
    
    internal func urlImage(image: UIImage?, percent: CGFloat) {
        guard
            let image = image
            else { return }
        
        self.image = image
        self.layer.rasterizationScale = percent
        self.layer.shouldRasterize = (percent != 1)
    }
}

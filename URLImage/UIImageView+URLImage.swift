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
    var gradient: UIVisualEffectView? {
        get {
            return objc_getAssociatedObject(self, &gradientKey) as? UIVisualEffectView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &gradientKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var urlImage: URLImage {
        let image = URLImage()
        image.delegate = self
        
        return image
    }
    
    // MARK - URLImageDelegate
    
    internal func urlImage(image: UIImage?, percent: CGFloat) {
        if gradient == nil {
            gradient = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            
            self.addSubview(gradient!)
        }
        var frame = self.layer.bounds
        frame.origin.y = frame.size.height * (1-percent)
        frame.size.height *= percent
        gradient?.frame = frame
        
        if (percent==1) {
            UIView.animate(withDuration: 0.5) {
                var frame = self.layer.bounds
                frame.origin.y = frame.size.height
                frame.size.height = 0
                self.gradient?.frame = frame
                
                self.image = image
            }
        } else {
            self.image = image
        }
    }
}

//
//  URLImage.swift
//  URLImage
//
//  Created by Wayne Yeh on 2017/2/21.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit

protocol URLImageDelegate: class {
    func urlImage(image: UIImage?, percent: CGFloat)
}

public class URLImage: NSObject, URLSessionDownloadDelegate {
    fileprivate var url: URL?
    fileprivate var image: UIImage?
    weak var delegate:URLImageDelegate?

    public func show() {
        guard let url = url else {
            update(percent: 0)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let img = URLImageCache.get(url: url) {
                self.image = img
            }
            
            let req = NSMutableURLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
            
            session.downloadTask(with: req as URLRequest).resume()
            session.finishTasksAndInvalidate()
        }
    }
    
    func update(percent: CGFloat) {
        delegate?.urlImage(image: image, percent: percent)
    }
    
    public func remote(url: String) -> URLImage {
        self.url = URL(string: url)
        return self
    }
    
    public func local(image: String) -> URLImage {
        self.image = UIImage(named: image)
        return self
    }
    
    // MARK URLSessionDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        let percent = CGFloat(writ) / CGFloat(exp)
        if percent != 1 {
            update(percent: percent)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        image = URLImageCache.add(task: downloadTask, location: location)
        
        update(percent: 1)
    }
}

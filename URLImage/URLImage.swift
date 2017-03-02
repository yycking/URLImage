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

public class URLImage: NSObject {
    fileprivate var url: URL?
    fileprivate var image: UIImage?
    weak var delegate: URLImageDelegate?

    fileprivate var remoteImageDataLength: Int64 = 0
    fileprivate lazy var remoteImageData = Data()
    fileprivate lazy var downloadDate = Date()
    
    public func show() {
        guard let url = url else {
            delegate?.urlImage(image: image, percent: 1)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let img = URLImageCache.get(url: url) {
                self.image = img
            }
            self.delegate?.urlImage(image: self.image, percent: 1)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
            session.dataTask(with: url).resume()
            session.finishTasksAndInvalidate()
        }
    }
    
    public func remote(url: String) -> URLImage {
        self.url = URL(string: url)
        return self
    }
    
    public func local(image: String) -> URLImage {
        self.image = UIImage(named: image)
        return self
    }
}

import ImageIO
// MARK URLSessionDataDelegate
extension URLImage: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        guard response.mimeType?.hasPrefix("image") == true else {
            completionHandler(.cancel)
            return
        }
        
        remoteImageDataLength = response.expectedContentLength
        completionHandler(.allow);
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        remoteImageData.append(data)
        let percent = CGFloat(remoteImageData.count) / CGFloat(remoteImageDataLength)
        
        guard
            percent == 1 || downloadDate + 1 < Date(),
            let image = UIImage(data: remoteImageData)
            else { return }
        
        downloadDate = Date()
        
        if percent == 1 {
            URLImageCache.add(task: dataTask, image: image)
        }
        delegate?.urlImage(image: image, percent: percent)
        
//        let imageSourceRef = CGImageSourceCreateIncremental(nil)
//        CGImageSourceUpdateData(imageSourceRef, remoteImageData as CFData, percent == 1)
//        if let imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, nil) {
//            let remoteImage = UIImage(cgImage: imageRef)
//
//            if percent == 1 {
//                URLImageCache.add(task: dataTask, image: remoteImage)
//            }
//            delegate?.urlImage(image: remoteImage, percent: percent)
//        }
    }
}

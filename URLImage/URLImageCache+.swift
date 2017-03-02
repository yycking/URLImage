//
//  URLImageCache+.swift
//  URLImage
//
//  Created by Wayne Yeh on 2017/2/22.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreData
import UIKit

extension URLImageCache {
    static private let entityName = "URLImageCache"
    static private let modalName = "URLImageCache"
    static private let moc: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: modalName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    static private func load(url: URL) -> URLImageCache? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "url == %@", url.absoluteString)
        
        guard
            let results = try? moc.fetch(request) as! [URLImageCache] else { return nil }
        
        return results.first
    }
    
    static func add(task: URLSessionTask, image: UIImage) {
        guard let url = task.currentRequest?.url else { return}
        
        let cache = load(url: url) ?? (NSEntityDescription.insertNewObject(forEntityName: entityName, into: moc) as! URLImageCache)
        
        cache.image = UIImagePNGRepresentation(image) as NSData?
        cache.url = url.absoluteString
    }
    
    static func get(url: URL) -> UIImage? {
        guard
            let result = load(url: url),
            let data = result.image else {
            return nil
        }
        
        return UIImage(data: data as Data)
    }
}

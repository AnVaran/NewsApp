//
//  LoadImage.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class LoadImage: UIImageView {
    
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("couldn't load inage from url \(url)")
                return
            }
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
    
}


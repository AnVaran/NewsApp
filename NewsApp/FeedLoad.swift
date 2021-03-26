//
//  FeedLoad.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

class FeedLoad: NSObject, XMLParserDelegate {
    
    private var parserCompletionHandler: (([FeedItem]) -> Void)!
    private let API_KEY = "cfc401cb92d841c8a807889295dc5648"
    private var rssItems: [FeedItem] = []
    
    func loadFeed(url: String, comletionHandler: @escaping (([FeedItem]) -> Void)) {
        
        let u = "https://newsapi.org/v2/top-headlines?country=us&apiKey="
        let urll = u + API_KEY
        
        self.parserCompletionHandler = comletionHandler
        
        guard let url = URL(string: urll) else { return }
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let newsFeed = try decoder.decode(NewsFeed.self, from: data)
                guard let feedArray = newsFeed.articles else { return }
                for i in feedArray {
                    let imageUrl = i.urlToImage ?? ""
                    let author = i.author ?? "No author"
                    let date = i.publishedAt ?? ""
                    let title = i.title ?? ""
                    let description = i.description ?? "No description"
                    let item = FeedItem(imageURL: imageUrl, title: title, auther: author, pubDate: date, description: description)
                    self.rssItems.append(item)
                }
            } catch {
                print("Error in JSON parsing")
            }
            self.parserCompletionHandler(self.rssItems)
            
        }
        task.resume()
    }
}

struct NewsFeed: Codable {
    var status: String = ""
    var totalResults: Int = 0
    var articles: [Article]?
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

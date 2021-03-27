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
    
    private let API_KEY = "&apiKey=cfc401cb92d841c8a807889295dc5648"
    private let MAIN_URL = "https://newsapi.org/v2/everything?q=apple"
    private let LANGUAGE = "&language=en"
    private var toDate: String = {
        guard let currDate = DateConverter.getDateFor(hours: 0) else { return ""}
        let date = DateConverter.dateToISO_8601String(date: currDate)
        return date
    }()
    
    private var rssItems: [FeedItem] = []
    
    func loadFeed(fromDate: String, comletionHandler: @escaping (([FeedItem]) -> Void)) {
        
        let inputUrl = MAIN_URL + LANGUAGE + "&from=" + fromDate + "&to=" + toDate + API_KEY
        
        toDate = fromDate
        self.parserCompletionHandler = comletionHandler
        
        guard let url = URL(string: inputUrl) else { return }
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            print(response)
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
                    let date = DateConverter.stringToISO_8601String(i.publishedAt) ?? "No date"
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

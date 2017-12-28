//
//  WikipediaAPIClient.swift
//  Wikipedia
//
//  Created by Madushani Lekam Wasam Liyanage on 11/30/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation


enum WikipediaError: Error {
    case badQuery
    case internetConnectionFailure
    case couldNotParseData
    case noResponse
    
}

class WikipediaAPIClient {
    
    //we can use a singleton, but it's not necessary
    //static let shared = WikipediaAPIClient()
    
    let urlSession = URLSession(configuration: .default)
    
    func searchForArticles(withQuery: String,  completionHandler: @escaping ([WikipediaSearchResult]?, WikipediaError?) -> Void) {
        
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&titles=\(withQuery)") else {
            
            completionHandler(nil, WikipediaError.badQuery)
            
            return
        }
        
       let task = self.urlSession.dataTask(with: url , completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let _ = error {
                completionHandler(nil, WikipediaError.internetConnectionFailure)
            }
            
            guard let _  = response else {
                completionHandler(nil, WikipediaError.noResponse)
                return
            }
            
            
            guard let data = data else {
                completionHandler(nil, WikipediaError.couldNotParseData)
                return
            }
        
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                //                guard let jsonDictionary = json as? [String: AnyObject],
                //                    let pages = jsonDictionary["query"]?["pages"] else {
                //                        return
                //                }
                
                guard let jsonDictionary = json as? [String:Any],
                    let query = jsonDictionary["query"] as? [String:Any],
                    let pages = query["pages"] as? [String:Any] else {
                        completionHandler(nil, WikipediaError.couldNotParseData)
                        return
                }
                
                var searchResults: [WikipediaSearchResult] = []
                for page in pages.values {
                    if  let page = page as? [String:Any],
                        let pageID = page["pageid"] as? Int,
                        let title = page["title"] as? String {
                        let result = WikipediaSearchResult(title: title, pageId: pageID)
                        searchResults.append(result)
                        
                    }
                }
                
                completionHandler(searchResults, nil)
                
            }
            catch {
                completionHandler(nil, WikipediaError.couldNotParseData)
            }
        })
        
        task.resume()
    }
    
}

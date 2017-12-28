//
//  ViewController.swift
//  Wikipedia
//
//  Created by Madushani Lekam Wasam Liyanage on 11/30/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var apiClient = WikipediaAPIClient()
    
    var searchResults = [WikipediaSearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        apiClient.searchForArticles(withQuery: searchBar.text ?? "", completionHandler: { results, error in
            DispatchQueue.main.async {
            if let error = error {
                //                switch error {
                //                case .badQuery {
                // TO DO: POP UP ALERT SAYING BAD QUERY
                //                    print("Bad Query!")
                //                    }
                //                case .couldNotParseData, .noResponse {
                // TO DO: POP UP ALERT SAYING "something went wrong" for us to fix
                //                    print("Could not parse data!")
                //                    }
                //                case .internetConnectionFailure {
                // TO DO: POP UP ALERT SAYING NO INTERNET
                //                    print("Internet connection failure!")
                //                    }
                //                }
            }
            if let results = results, error == nil {
                self.searchResults = results
                // I will be executed when the apiClient calls completionHandler
                self.tableView.reloadData()
            }
            }
        })
    }
}
    
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.apiClient.searchForArticles(withQuery: searchBar.text ?? "", completionHandler: {results, error in
//            DispatchQueue.main.async {
//                
//           if let error = error {
////                switch(error) {
////                case .badQuery:
////                    TODO pop up alert saying bad query
////                case .couldNotParseData:
////                    TODO popup alert saying "something went wrong and make a note to ourselves to fix it
////                case .internetConnectionFailure:
////                    TODO
////                case .noResponse:
////                    
////                }
//           }
//            
//            if let resutls = results, error == nil {
//                
//                self.searchResults = results!
//                
//                 self.tableView.reloadData()
//                }
//            
//            
//            }
//            
//        })
//  
//    }
//}

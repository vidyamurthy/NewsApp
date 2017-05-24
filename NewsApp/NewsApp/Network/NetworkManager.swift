//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Vidya Murthy on 24/05/17.
//  Copyright © 2017 Vidya Murthy. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    private init () {}
    
    let apiKey = "03be397f7fa14794b82daecf9acbfa33"
    
    func getMostViewedArticlesFor(section: String, timePeriod: Int, onSuccess: @escaping (Bool) -> Void, onFailure: @escaping (AnyObject) -> Void) {
        
        let urlString = String(format: "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/%@/%i.json?api-key=%@", section, timePeriod, apiKey)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if (error != nil) {
                onFailure(error as AnyObject)
            }
            else {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    let responseDict = jsonObj as! [String: AnyObject]
                    DataManager.sharedManager.saveToCoreDataFrom(array: responseDict["results"] as! [[String : AnyObject]])
                    onSuccess(true)
                }
                catch {
                    print("Error parsing JSON")
                    onSuccess(false)
                }
            }
        }.resume()
    }
}

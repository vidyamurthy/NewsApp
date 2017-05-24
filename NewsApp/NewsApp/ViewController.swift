//
//  ViewController.swift
//  NewsApp
//
//  Created by Vidya Murthy on 24/05/17.
//  Copyright © 2017 Vidya Murthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NetworkManager.sharedManager.getMostViewedArticlesFor(section: "all-sections", timePeriod: 1, onSuccess: {success in
            if success {
//                self.listingsArray = DataManager.sharedManager.fetchAllListings()!
                DispatchQueue.main.async(){
//                    self.listingsTableView.reloadData()
                }
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "", message: "There was some network error, please try again in sometime.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


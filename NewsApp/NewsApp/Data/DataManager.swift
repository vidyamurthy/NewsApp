//
//  DataManager.swift
//  NewsApp
//
//  Created by Vidya Murthy on 24/05/17.
//  Copyright © 2017 Vidya Murthy. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let sharedManager = DataManager()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NewsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Helper Methods
    
    func saveToCoreDataFrom(array: [[String: AnyObject]]) {
        _ = array.map{ self.createListingEntityFrom(dictionary: $0)}
        
        do {
            try DataManager.sharedManager.persistentContainer.viewContext.save()
        }
        catch let error{
            print(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func createListingEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = DataManager.sharedManager.persistentContainer.viewContext
        
        // check if it already exists
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsArticle")
        let predicate = NSPredicate(format: "id == %i", argumentArray: [dictionary["id"] as! Int16])
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NewsArticle]
            if (fetchResults!.count) > 0 {
                print("Article already exists")
            }
            else {
                if let articleEntity = NSEntityDescription.insertNewObject(forEntityName: "NewsArticle", into: context) as? NewsArticle {
                    
                    articleEntity.id = Int64(dictionary["id"] as! Int16)
                    articleEntity.title = dictionary["title"] as? String
                    articleEntity.abstract = dictionary["abstract"] as? String
                    articleEntity.publishedDate = dictionary["published_date"] as? String
                    articleEntity.section = dictionary["source"] as? String
                    articleEntity.source = dictionary["section"] as? String
                    articleEntity.byline = dictionary["byline"] as? String
                    articleEntity.url = dictionary["url"] as? String
                   
                    guard let mediaArray = dictionary["media"] as? [[AnyHashable: Any]] else {
                        articleEntity.imageUrl = ""
                        return articleEntity
                    }
                    
                    for media in mediaArray {
                        let imageList = media["media-metadata"] as! [[String: AnyObject]]
                        
                        for images in imageList {
                            if images["format"] as! String == "mediumThreeByTwo440" {
                                articleEntity.imageUrl = images["url"] as? String
                            }
                        }
                        if (articleEntity.imageUrl?.isEmpty)! {
                            articleEntity.imageUrl = imageList[0]["url"] as? String
                        }
                    }
                    return articleEntity
                }
            }
        }
        catch {
            
        }
        return nil
    }

}

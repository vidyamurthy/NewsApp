//
//  NewsArticle+CoreDataProperties.swift
//  NewsApp
//
//  Created by Vidya Murthy on 24/05/17.
//  Copyright © 2017 Vidya Murthy. All rights reserved.
//

import Foundation
import CoreData


extension NewsArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var section: String?
    @NSManaged public var byline: String?
    @NSManaged public var source: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var id: Int64

}

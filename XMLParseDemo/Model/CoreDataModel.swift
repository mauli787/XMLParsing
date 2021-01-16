//
//  CoreDataModel.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 11/01/21.
//

import Foundation
import CoreData


public class AlbumConfiguration: NSManagedObject { 
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumConfiguration> {
        return NSFetchRequest<AlbumConfiguration>(entityName: "MoviesDB")
    }
    
}
 

//
//  CoreDataManager.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 11/01/21.
//
import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    var managedObjectContext : NSManagedObjectContext!
    static let shared = CoreDataManager()
    
    override init() {
        super.init()
        managedObjectContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "XMLParseDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    // MARK: Fetch All Data
    
    func fetchAllData(_ completionHandler: (_ result: [NSManagedObject]) -> Void){
        var result : [NSManagedObject]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AlbumConfiguration.entityName())
        request.returnsObjectsAsFaults = false
        do {
            result = try managedObjectContext.fetch(request) as? [NSManagedObject]
            completionHandler(result!)
        } catch {
            print("Fetching data Failed")
        }
    } 
    func fetchData() -> Int {
        var result : [NSManagedObject]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AlbumConfiguration.entityName())
        request.returnsObjectsAsFaults = false
        do {
            result = try managedObjectContext.fetch(request) as? [NSManagedObject]
        } catch {
            print("Fetching data Failed")
        }
        return result?.count ?? 0
    }
    
    // MARK: Get Entity Records Count
    func count(forEntityName entityName : String) -> Int {
        let fetchRequest : NSFetchRequest =  self.fetchRequest(forEntityName : entityName)
        do {
            return try managedObjectContext.count(for: fetchRequest)
        } catch let fetchError as NSError{
            print("retrieveById error: \(fetchError.localizedDescription)")
        }
        return 0
    }
    
    // MARK: Insert Single Object
    func insertObject(forEntityName entityName : String, attributes : [String : Any] ) {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
        for (key, value) in attributes {
            managedObject.setValue(value, forKey: key)
        }
        self.saveManagedObjectContext()
    }
    
    // MARK: Insert Multiple Object
    func insertObjects(forEntityName entityName : String, attributes : [[String : Any]] ) {
        for attribute in attributes {
            let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
            for (key, value) in attribute {
                managedObject.setValue(value, forKey: key)
            }
        }
        self.saveManagedObjectContext()
    }
    
    // MARK: Fetch All Attributes From Entity
    func fetchAllAttributes(forEntityName entityName : String) -> [NSFetchRequestResult]? {
        
        print("Fetching Data..")
        var result : [NSFetchRequestResult]?
               let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
               request.returnsObjectsAsFaults = false
               do {
                   result = try managedObjectContext.fetch(request) 
               } catch {
                   print("Fetching data Failed")
               }
           return result
    }
    
    // MARK: Fetch Request
    func fetchRequest(forEntityName entityName : String) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
    }
    
    // MARK: Fetch By Id For Entity
    func fetchByPredicate(forEntityName entityName : String, predicate : NSPredicate) -> [NSFetchRequestResult]? {
        let fetchRequest : NSFetchRequest =  self.fetchRequest(forEntityName : entityName)
        fetchRequest.predicate = predicate
        var result : [NSFetchRequestResult]?
        do {
            result = try managedObjectContext.fetch(fetchRequest)
        } catch let fetchError as NSError{
            print("retrieveById error: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    // MARK: Fetch Request Result
    func fetchRequestResult(forEntityName entityName : String, predicate : NSPredicate? = nil, sortDescriptor : NSSortDescriptor? = nil, offset : Int? = nil, fetchLimit : Int? = 25) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest =  self.fetchRequest(forEntityName : entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        if let offset = offset {
            fetchRequest.fetchLimit = fetchLimit!
            fetchRequest.fetchOffset = offset
        }
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    // MARK: Fetch Request Results
    func fetchRequestResults(forEntityName entityName : String, predicate : NSPredicate? = nil, sortDescriptor : NSSortDescriptor? = nil, offset : Int? = nil, fetchLimit : Int? = 25) -> [NSFetchRequestResult]? {
        let fetchRequest : NSFetchRequest = self.fetchRequestResult(forEntityName: entityName, predicate: predicate, sortDescriptor: sortDescriptor, offset: offset, fetchLimit: fetchLimit)
        return self.fetchWith(fetchRequest: fetchRequest)
    }
    
    // MARK: Fetch With Fetch Request
    func fetchWith(fetchRequest request : NSFetchRequest<NSFetchRequestResult>) ->  [NSFetchRequestResult]? {
        var result : [NSFetchRequestResult]?
        do {
            result = try managedObjectContext.fetch(request)
        } catch let fetchError as NSError{
            print("retrieveById error: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    // MARK: Fetched Results Controller With Fetch Request
    func fetchedResultsController(fetchRequest request : NSFetchRequest<NSFetchRequestResult>, cacheName : String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
    }
    
    // MARK: Update Managed Object
    func update(managedObject object : NSManagedObject, values : [String : Any]) {
        for (key, value) in values {
            object.setValue(value, forKey: key)
        }
        self.saveManagedObjectContext()
    }
    
    // MARK: Delete Managed Object
    func delete(managedObject object : NSManagedObject) {
        managedObjectContext.delete(object)
        self.saveManagedObjectContext()
    }
    
    // MARK: Delete All Managed Object
    func deleteAll(forEntityName entityName : String) {
        let allAttributes = self.fetchAllAttributes(forEntityName: entityName)
        for managedObject in allAttributes! {
            if let mObject = managedObject as? NSManagedObject {
                managedObjectContext.delete(mObject)
            }
        }
        self.saveManagedObjectContext()
    }
    
    func delete(forEntityName entityName : String, predicate : NSPredicate? = nil, sortDescriptor : NSSortDescriptor? = nil, offset : Int? = nil, fetchLimit : Int? = nil) {
        // Create Fetch Request
        let fetchRequest : NSFetchRequest =  self.fetchRequestResult(forEntityName: entityName, predicate: predicate, sortDescriptor: sortDescriptor, offset: offset, fetchLimit: fetchLimit)
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            _ = try managedObjectContext.execute(batchDeleteRequest)
        } catch { }
    }
    
    // MARK: Save Managed Object Context
    func saveManagedObjectContext() {
        do {
            try managedObjectContext.save()
        } catch let saveError as NSError {
            print("synWithMainContext error: \(saveError.localizedDescription)")
        }
    }
}

extension NSManagedObject {
    public class func entityName() -> String {
        return "MoviesDB"
    }
}

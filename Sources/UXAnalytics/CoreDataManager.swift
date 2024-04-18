//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
import CoreData
class CoreDataManager {
    public static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: "UXAnalytics", withExtension: "momd", subdirectory: "Sources/UXAnalytics") else {
            fatalError("Failed to locate model file in bundle.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to initialize managed object model from URL: \(modelURL)")
        }

        let persistentContainer = NSPersistentContainer(name: "UXAnalytics", managedObjectModel: managedObjectModel)

        // Configure the persistent store coordinator
        let description = NSPersistentStoreDescription()
        description.url = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("UXAnalytics.sqlite")
        persistentContainer.persistentStoreDescriptions = [description]

        // Load persistent stores
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return persistentContainer
        /*
        let container = NSPersistentContainer(name: "UXAnalytics")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        */
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
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
}

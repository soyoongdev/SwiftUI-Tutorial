//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by Hau Nguyen on 17/08/2021.
//

import SwiftUI
import CoreData

@main
struct CoreDataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

var persistentContainer: NSPersistentContainer {
    
    let container = NSPersistentContainer(name:  "Data")
    container.loadPersistentStores(completionHandler: {(storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        }catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

//
//  CoreDataStack.swift
//  CoreDataApp
//
//  Created by win on 3/24/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack{
    var container : NSPersistentContainer {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {(desciption,error) in
            guard error == nil else{
                print("Error : \(error!)")
                return
            }
        })
        return container
    }
    var managedContext : NSManagedObjectContext {
        return container.viewContext
    }
}

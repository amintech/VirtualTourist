//
//  DataController.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 13/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    private let presistentContainer: NSPersistentContainer
    
    static let shared = DataController()
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "VirtualTourist")
    }
    
    var viewContext: NSManagedObjectContext {
        return presistentContainer.viewContext
    }
    
    func load(complation: (() -> Void)? = nil ){
        presistentContainer.loadPersistentStores { (storeDisc, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            complation?()
        }
    }
    
}

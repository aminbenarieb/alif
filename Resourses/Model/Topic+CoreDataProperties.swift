//
//  Topic+CoreDataProperties.swift
//  
//
//  Created by Amin Benarieb on 13/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Topic {

    @NSManaged var name: String?
    @NSManaged var passed: NSNumber?
    @NSManaged var slides: NSData?
    @NSManaged var train_dictionary: NSData?

}

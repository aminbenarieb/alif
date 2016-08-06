//
//  Topic+CoreDataProperties.swift
//  
//
//  Created by Amin Benarieb on 06/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Topic {

    @NSManaged var difficulty: Int16
    @NSManaged var name: String?
    @NSManaged var content: String?
    @NSManaged var passed: Float

}

//
//  EntityFetchProtocol.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

import CoreData
import Foundation

protocol EntityFetchProtocol: NSManagedObject, Identifiable {
    associatedtype EntityType: NSManagedObject
    static func fetchRequest(predicate: NSPredicate?) -> NSFetchRequest<EntityType>
}

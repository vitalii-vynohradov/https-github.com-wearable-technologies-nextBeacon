//
//  Equipment.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

import CoreData
import Foundation

@objc(Equipment)
public class Equipment: NSManagedObject, Identifiable {
    @NSManaged public var id: Int32
    @NSManaged public var typeId: Int32
    @NSManaged public var uid: String
}

extension Equipment: EntityFetchProtocol {
    public static func fetchRequest(predicate: NSPredicate?) -> NSFetchRequest<Equipment> {
        let fetchRequest = NSFetchRequest<Equipment>(entityName: "Equipment")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "typeId", ascending: true),
                                        NSSortDescriptor(key: "uid", ascending: true)]
        return fetchRequest
    }
}

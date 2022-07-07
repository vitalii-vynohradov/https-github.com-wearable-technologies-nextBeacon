//
//  EquipmentType.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

import CoreData
import Foundation

@objc(EquipmentType)
public class EquipmentType: NSManagedObject, Identifiable {
    @NSManaged public var id: Int32
    @NSManaged public var label: String
    @NSManaged public var name: String
    @NSManaged public var desc: String?
}

extension EquipmentType: EntityFetchProtocol {
    public static func fetchRequest(predicate: NSPredicate?) -> NSFetchRequest<EquipmentType> {
        let fetchRequest = NSFetchRequest<EquipmentType>(entityName: "EquipmentType")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return fetchRequest
    }
}

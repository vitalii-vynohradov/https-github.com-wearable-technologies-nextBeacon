//
//  PersistenceController.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 03.06.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        let storeURL = try! FileManager
                .default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AppDB.sqlite")

        let description = NSPersistentStoreDescription(url: storeURL)

        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true

        container = NSPersistentContainer(name: "LocalDB")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                Logger.error("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func clearAllRepos() {
        deleteTable("Equipment")
        deleteTable("EquipmentType")
    }

    private func deleteTable(_ name: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        } catch {
            Logger.error("\(name) DB clear error!")
        }
    }
}

//
//  BaseDataService.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

import CoreData
import Foundation

class BaseDataService<E: EntityFetchProtocol/*, R: ResponseProtocol*/> {
    let managedContext: NSManagedObjectContext

    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.managedContext = persistenceController.container.viewContext
    }

    func load(id: Int32? = nil, completion: @escaping (Result<[E], DbError>) -> Void) {
        let predicate = id != nil ? NSPredicate(format: "id == %d", id!) : nil
        loadData(predicate: predicate, completion: completion)
    }

//    func saveDataFrom(_ response: [R]) {
//        // Clear table
//        clear()
//
//        // Insert new data
//        response.forEach { _ = $0.process(context: managedContext) }
//
//        // Save table
//        save()
//    }

    func isDataExistsWithId(_ id: Int32?) -> Bool {
        guard let id = id else { return false }

        let request = E.fetchRequest(predicate: NSPredicate(format: "id == %d", id))

        do {
            let data = try managedContext.fetch(request)
            return !data.isEmpty
        } catch {
            Logger.error("\(DbError.general(error))")
        }

        return false
    }

    func addItem(parameters: [String: Any]) {
        let item = E(context: managedContext)
        item.setValuesForKeys(parameters)

        // Save table
        save()
    }

    func deleteItem(id: Int32) {
        let requestItem = E.fetchRequest(predicate: NSPredicate(format: "id == %d", id))
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = requestItem as? NSFetchRequest<NSFetchRequestResult> ?? E.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            save()
        } catch {
            Logger.error("\(E.self) DB delete error!")
        }
    }

    func clear() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = E.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            save()
        } catch {
            Logger.error("\(E.self) DB clear error!")
        }
    }

    func save() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                Logger.error("\(E.self) DB save error!")
            }
        }
    }
}

private extension BaseDataService {
    func loadData(predicate: NSPredicate? = nil, completion: @escaping (Result<[E], DbError>) -> Void) {
        guard let request = E.fetchRequest(predicate: predicate) as? NSFetchRequest<E> else {
            Logger.error("\(DbError.badRequest)")
            completion(.failure(.badRequest))
            return
        }

        if request.sortDescriptors == nil {
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        }

        do {
            let data = try managedContext.fetch(request)
            completion(.success(data))
        } catch {
            Logger.error("\(DbError.general(error))")
            completion(.failure(.general(error)))
        }
    }
}

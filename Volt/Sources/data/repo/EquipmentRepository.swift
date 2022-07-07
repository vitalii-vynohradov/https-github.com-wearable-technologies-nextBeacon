//
//  EquipmentRepository.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 11.06.2021.
//

import Foundation
import SwiftUI

class EquipmentRepository: BaseRepository<Equipment> {
    typealias DataService = BaseDataService<Equipment>

    static let dataService = DataService()

    static let defaultValue = EquipmentRepository(dataService: dataService)

    func addEquipmentLocal(id: Int32, typeId: Int32, mac: String) {
        let parameters: [String: Any] = ["id": id,
                                         "uid": mac,
                                         "typeId": typeId]

        self.postLocal(parameters: parameters)
    }

    func deleteEquipmentLocal(id: Int32) {
        self.deleteLocal(id: id)
    }
}

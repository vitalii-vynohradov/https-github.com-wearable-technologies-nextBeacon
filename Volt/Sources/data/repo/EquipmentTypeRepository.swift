//
//  EquipmentTypeRepository.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

import Foundation
import SwiftUI

class EquipmentTypeRepository: BaseRepository<EquipmentType> {
    typealias DataService = BaseDataService<EquipmentType>

    static let dataService = DataService()

    static let defaultValue = EquipmentTypeRepository(dataService: dataService)

    func loadMock() {
        EquipmentTypeRepository.dataService.load { result in
            switch result {
            case .success(let data):
                self.handle(data)
            default:
                break
            }
        }
    }

    func handle(_ data: [EquipmentType]) {
        if data.isEmpty {
            let equipment0: [String: Any] = ["id": 0,
                                             "name": "Auffanggurt HS",
                                             "label": "Auffanggurt HS"]

            let equipment1: [String: Any] = ["id": 1,
                                             "name": "Erdungskabel HS",
                                             "label": "Erdungskabel HS"]

            let equipment2: [String: Any] = ["id": 2,
                                             "name": "Handschuhe HS",
                                             "label": "Handschuhe HS"]

            postLocal(parameters: equipment0)
            postLocal(parameters: equipment1)
            postLocal(parameters: equipment2)

        } else {
            loadLocal()
        }
    }
}

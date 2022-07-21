//
//  PPEViewModel.swift
//  Volt
//
//  Created by Mykyta Smaha on 05.07.2021.
//

import Combine
import Foundation
import SwiftUI

struct PPEDetails: Identifiable {
    let id: Int32 // Type id
    let equipmentId: Int32
    let name: String
    let mac: String
}

protocol PPEViewModelDelegate: NSObject {
    func onUpdateAllReady(ready: Bool)
    func onUpdateEquipment()
}

final class PPEViewModel: ObservableObject {
    private var equipmentTypesRepository = EquipmentTypeRepository.defaultValue
    private var equipmentRepository = EquipmentRepository.defaultValue

    @State var isLoading = false

    @Published var allPPE: [PPEDetails] = []
    @Published var areAllPPEPaired = false

    weak var delegate: PPEViewModelDelegate?

    private var subscriptions = Set<AnyCancellable>()

    private func attachRepositories() {
        equipmentTypesRepository.$data
            .combineLatest(equipmentRepository.$data)
            .map { requiredEquipmentTypes, pairedEquipment in
                return requiredEquipmentTypes
                    .map { equipmentType in
                        let pairedItem = pairedEquipment.first(where: { $0.typeId == equipmentType.id })
                        return PPEDetails(id: equipmentType.id,
                                          equipmentId: pairedItem?.id ?? -1,
                                          name: equipmentType.name,
                                          mac: pairedItem?.uid ?? "")
                    }
                    .sorted { $0.name < $1.name }
            }
            .eraseToAnyPublisher()
            .sink { [weak self] data in
                self?.allPPE = data
            }
            .store(in: &self.subscriptions)

        $allPPE
            .sink { [weak self] data in
                self?.areAllPPEPaired = !data.isEmpty && data.allSatisfy { $0.equipmentId > 0 }
                self?.delegate?.onUpdateEquipment()
            }
            .store(in: &self.subscriptions)

        equipmentTypesRepository.$isLoading
            .combineLatest(equipmentRepository.$isLoading)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
            .sink { [weak self] loading in
                self?.isLoading = loading
            }
            .store(in: &self.subscriptions)

        equipmentTypesRepository.$error
            .sink { error in
                guard let error = error else { return }
                Logger.debug("Equipment types repository error: \(error.localizedDescription)")
            }
            .store(in: &self.subscriptions)

        equipmentRepository.$error
            .sink { error in
                guard let error = error else { return }
                Logger.debug("Equipment repository error: \(error.localizedDescription)")
            }
            .store(in: &self.subscriptions)

        $areAllPPEPaired
            .sink { [weak self] ready in
                self?.delegate?.onUpdateAllReady(ready: ready)
            }
            .store(in: &self.subscriptions)
    }

    func subscribe() {
        attachRepositories()
        load()
    }

    func unsubscribe() {
        self.subscriptions.removeAll()
    }

    func load(forceFetch force: Bool = false) {
        equipmentTypesRepository.loadMock()
        equipmentRepository.loadLocal()
    }

    func unpair(id: Int32) {
        equipmentRepository.deleteEquipmentLocal(id: id)
    }

    func handleQrCodeFor(typeId: Int32, code: String) -> Bool {
        if let mac = code.mac,
           let id = mac.id
        {
            Logger.debug("->> \(typeId) - \(mac)")
            equipmentRepository.addEquipmentLocal(id: id, typeId: typeId, mac: mac)
            return true
        }

        return false
    }
}

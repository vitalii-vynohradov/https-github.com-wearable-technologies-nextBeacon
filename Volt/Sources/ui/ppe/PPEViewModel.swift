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

    @Published var showQrReader = false
    @Published var dismissedQrReader = true
    @Published var qrCode: String?

    weak var delegate: PPEViewModelDelegate?

    private var selectedType: Int32?
    private var unpairId: Int32?
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

        $dismissedQrReader.combineLatest($qrCode)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] didDismiss, qrCode in
                if didDismiss {
                    self?.handleQrCode(code: qrCode)
                }
            }
            .store(in: &self.subscriptions)

        $areAllPPEPaired
            .sink { [weak self] ready in
                self?.delegate?.onUpdateAllReady(ready: ready)
            }
            .store(in: &self.subscriptions)

        $allPPE
            .sink { [weak self] _ in
                self?.delegate?.onUpdateEquipment()
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

    func pair(typeId: Int32) {
        selectedType = typeId
        showQrReader = true
    }

    func unpair(id: Int32) {
        equipmentRepository.deleteEquipmentLocal(id: id)
    }

    private func handleQrCode(code: String?) {
        guard let code = code else { return }
        self.qrCode = nil
        if let type = selectedType, let mac = code.mac, let id = mac.id {
            Logger.debug("->> \(type) - \(mac)")
            equipmentRepository.addEquipmentLocal(id: id, typeId: type, mac: mac)
        } else {
            Logger.debug("Can't parse QR: \(code)")
        }
    }
}

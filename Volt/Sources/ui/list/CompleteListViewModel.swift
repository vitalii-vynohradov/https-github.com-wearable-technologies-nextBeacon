//
//  CompleteListViewModel.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import Foundation
import Combine

struct EquipmentDataHolder: Codable, Hashable {
    let id: Int32
    let name: String
    let mac: String
    var available: Bool
}

final class CompleteListViewModel: ObservableObject {
    private var equipmentTypesRepository = EquipmentTypeRepository.defaultValue
    private var equipmentRepository = EquipmentRepository.defaultValue

    @Published var allEquipment: [EquipmentDataHolder] = []
    @Published var isScanning = false

    @Published var showAlertError = false
    @Published var alertErrorMsg = ""
    
    private var foundEquipment: Set<BleDevice> = []

    private var subscriptions = Set<AnyCancellable>()

    func initialise() {
        equipmentTypesRepository.$data
            .combineLatest(equipmentRepository.$data)
            .sink { [weak self] equipment, paired in
                self?.allEquipment = equipment
                    .map { equipmentType in
                        let mac = paired.first(where: { equipmentType.id == $0.typeId })?.uid ?? "n.a."
                        return EquipmentDataHolder(id: equipmentType.id, name: equipmentType.name, mac: mac, available: false)
                    }
                    .sorted { $0.name < $1.name }
                }
            .store(in: &subscriptions)
    }

    func subscribe() {
        initialise()
        BleManager.defaultValue.addDelegate(delegate: self)
    }

    func unsubscribe() {
        subscriptions.removeAll()
        BleManager.defaultValue.removeDelegate(delegate: self)
    }

    func load() {
//        equipmentTypesRepository.load(forceFetch: true)
    }

    func check() {
        guard !isScanning else { return }

        Logger.debug("Start looking for equipment")

        isScanning = true

        // Reset status
        for eq in allEquipment {
            if let row = allEquipment.firstIndex(where: { $0.id == eq.id }) {
                allEquipment[row] = EquipmentDataHolder(id: eq.id, name: eq.name, mac: eq.mac, available: false)
            }
        }

        // Start looking for equipment
        BleManager.defaultValue.startScanning(allowDuplicates: true)

        // Search timeout
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15.0) {
            // Stop search
            self.isScanning = false

            Logger.debug("Stop looking for equipment")

            BleManager.defaultValue.stopScanning()

            // Reset found list
            self.foundEquipment.removeAll()
        }
    }
}

// MARK: - Ble manager
extension CompleteListViewModel: BleManagerDelegate {
    func bleManagerReady() {
        Logger.debug("Bluetooth is ready")
    }

    func bleManagerDeviceFound(device: BleDevice) {
        if foundEquipment.update(with: device) == nil {
            let equipment = allEquipment.first(where: { $0.mac == device.mac })
            let description = equipment == nil ? "Not paired" : equipment!.name

            // Update equipment status
            if let found = equipment, let row = allEquipment.firstIndex(where: { $0.id == found.id }) {
                allEquipment[row] = EquipmentDataHolder(id: found.id, name: found.name, mac: found.mac, available: true)
            }

            Logger.debug("Found equipment id = \(device.mac) --> \(description)")
        }
    }

    func bleManagerError(error: BleError) {
        Logger.debug("Bluetooth error: \(error.localizedDescription)")
    }
}

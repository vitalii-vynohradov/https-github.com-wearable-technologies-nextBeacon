//
//  BleManager.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 07.06.2021.
//

import CoreBluetooth
import Foundation
import SwiftUI

protocol BleManagerProtocol: AnyObject {
    func addDelegate(delegate: BleManagerDelegate)
    func removeDelegate(delegate: BleManagerDelegate)

    func startScanning(allowDuplicates: Bool)
    func stopScanning()
    func isScanning() -> Bool
}

extension BleManagerProtocol {
    func startScanning(allowDuplicates: Bool = true) {
        startScanning(allowDuplicates: allowDuplicates)
    }
}

protocol BleManagerDelegate: AnyObject {
    func bleManagerReady()
    func bleManagerDeviceFound(device: BleDevice)
    func bleManagerError(error: BleError)
}

class BleManager: NSObject {
    static let shared = BleManager()

    private let delegates = MulticastDelegate<BleManagerDelegate>()

    private var centralManager: CBCentralManager!

    private let serviceUUIDs = [CBUUID(string: "180F")]

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self,
                                          queue: nil,
                                          options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
}

// MARK: - implementation
extension BleManager: BleManagerProtocol {
    func addDelegate(delegate: BleManagerDelegate) {
        delegates.add(delegate: delegate)
        checkBleManager()
    }

    func removeDelegate(delegate: BleManagerDelegate) {
        delegates.remove(delegate: delegate)
    }

    func startScanning(allowDuplicates: Bool) {
        guard !isScanning() else { return }

        guard isBleManagerReady() else {
            checkBleManager()
            return
        }

        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: allowDuplicates)]
        centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
        Logger.debug("Start scanning...")
    }

    func stopScanning() {
        centralManager.stopScan()
        Logger.debug("Stop scanning")
    }

    func isScanning() -> Bool {
        return centralManager.isScanning
    }
}

// MARK: - Central Manager Delegate
extension BleManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Logger.debug("Bluetooth state updated: \(central.state.rawValue)")
        switch central.state {
        case .poweredOn:
            delegates.invoke(invocation: { $0.bleManagerReady() })
        case .resetting:
            delegates.invoke(invocation: { $0.bleManagerError(error: .bluetoothResetting) })
        case .unsupported:
            delegates.invoke(invocation: { $0.bleManagerError(error: .bluetoothUnsupported) })
        case .unauthorized:
            delegates.invoke(invocation: { $0.bleManagerError(error: .permissionDenied) })
        case .poweredOff:
            delegates.invoke(invocation: { $0.bleManagerError(error: .bluetoothDisabled) })
        default:
            delegates.invoke(invocation: { $0.bleManagerError(error: .unknown) })
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        guard BleUtil.isVoltSensorWithName(peripheral.name) else { return }

        let device = BleDevice(from: peripheral, rssi: RSSI.intValue)

        Logger.debug("SCAN: \(device)")
        delegates.invoke(invocation: { $0.bleManagerDeviceFound(device: device) })
    }
}

// MARK: - environment key
extension BleManager: EnvironmentKey {
    static let defaultValue: BleManagerProtocol = BleManager.shared
}

// MARK: - private
private extension BleManager {
    func isBleManagerReady() -> Bool {
        return isBleManagerAuthorized() && centralManager.state == .poweredOn
    }

    func isBleManagerAuthorized() -> Bool {
        return CBCentralManager.authorization == .allowedAlways
    }

    func checkBleManager() {
        switch (centralManager.state, isBleManagerAuthorized()) {
        case (.unknown, _), (.resetting, _):
            break // wait for notifications
        case (.poweredOn, true):
            delegates.invoke(invocation: { $0.bleManagerReady() })
        case (.poweredOff, _):
            delegates.invoke(invocation: { $0.bleManagerError(error: .bluetoothDisabled) })
        default:
            delegates.invoke(invocation: { $0.bleManagerError(error: .permissionDenied) })
        }
    }
}

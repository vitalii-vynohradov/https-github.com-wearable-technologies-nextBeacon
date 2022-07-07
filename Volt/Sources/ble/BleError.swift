//
//  BluetoothError.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 07.06.2021.
//

import Foundation

enum BleError: Error {
    case general(Error)
    case permissionDenied
    case bluetoothDisabled
    case bluetoothUnsupported
    case bluetoothResetting
    case unknown
}

// MARK: - LocalizedError
extension BleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .general(let error):
            return error.localizedDescription
        case .permissionDenied:
            return "bt_permission_denied".localized()
        case .bluetoothDisabled:
            return "bt_disabled".localized()
        case .bluetoothUnsupported:
            return "bt_not_supported".localized()
        case .bluetoothResetting:
            return "bt_resetting".localized()
        default:
          return "bt_unknown_error".localized()
        }
    }
}

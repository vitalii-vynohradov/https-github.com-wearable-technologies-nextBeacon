//
//  BleDevice.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 07.06.2021.
//

import CoreBluetooth
import Foundation

struct BleDevice {
    let name: String
    let mac: String
    let rssi: Int
	let seenAt: Date

    init(from peripheral: CBPeripheral, rssi: Int) {
        let name = peripheral.name ?? "Unknown"
        let tail = String(name.split(separator: " ").last ?? "")
        let mac = tail.isHexNumber ? tail : "Unknown"

        self.name = name
        self.mac = mac
        self.rssi = rssi
		self.seenAt = Date()
    }
}

extension BleDevice: Hashable {
	static func == (lhs: BleDevice, rhs: BleDevice) -> Bool {
		return lhs.mac == rhs.mac
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(mac)
	}
}

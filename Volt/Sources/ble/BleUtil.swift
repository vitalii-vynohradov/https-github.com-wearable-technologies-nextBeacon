//
//  BleUtil.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 07.06.2021.
//

import Foundation

let voltDeviceList = ["UA Footpod", "BMi "]

class BleUtil {
    static func isVoltSensorWithName(_ name: String?) -> Bool {
        guard let name = name?.lowercased() else { return false }
        return voltDeviceList.contains {
            name.contains($0.lowercased())
        }
    }
}

//
//  CLProximity+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 13.01.2022.
//

import CoreLocation

extension CLProximity {
    func name() -> String {
        switch self {
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        default:
            return "Unknown"
        }
    }
}

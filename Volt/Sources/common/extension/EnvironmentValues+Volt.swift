//
//  EnvironmentValues+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 04.06.2021.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var bleManager: BleManagerProtocol {
        self[BleManager.self]
    }
}

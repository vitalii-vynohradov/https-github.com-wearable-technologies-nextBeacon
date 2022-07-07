//
//  Optional+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 03.06.2021.
//

import Foundation

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

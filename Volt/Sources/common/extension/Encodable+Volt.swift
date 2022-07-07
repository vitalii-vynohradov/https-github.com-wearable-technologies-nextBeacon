//
//  Encodable+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 27.01.2022.
//

import Foundation

extension Encodable {
    func toParams() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}

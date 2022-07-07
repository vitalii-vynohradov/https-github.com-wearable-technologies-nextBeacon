//
//  JSONDecoder+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 03.06.2021.
//

import Foundation

extension JSONDecoder {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            guard let date = dateFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)")
            }
            return date
        }
        return decoder
    }
}

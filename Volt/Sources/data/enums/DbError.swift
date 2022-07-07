//
//  DbError.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 04.06.2021.
//

import Foundation

enum DbError: Error {
    case general(Error)
    case badRequest

    private var genericErrorMessage: String {
        "error_generic_error_message".localized()
    }
}

extension DbError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "DB bad request"
        default:
            return genericErrorMessage
        }
    }
}

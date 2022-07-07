//
//  RepositoryError.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 04.06.2021.
//

import Foundation

enum RepositoryError: Error {
    case dbError(DbError)
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dbError(let error):
            return error.errorDescription
        }
    }
}

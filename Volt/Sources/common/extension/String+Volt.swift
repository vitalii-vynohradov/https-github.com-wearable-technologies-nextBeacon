//
//  String+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 03.06.2021.
//

import Foundation

public extension String {
    func localized(_ args: CVarArg...) -> String {
        guard !isEmpty else { return self }
        let localizedString = NSLocalizedString(self, comment: "")
        let resultString = withVaList(args) {
            NSString(format: localizedString, locale: Locale.current, arguments: $0) as String
        }
        return resultString.isEmpty ? self : resultString
    }

    var isHexNumber: Bool {
        filter(\.isHexDigit).count == count
    }

    var mac: String? {
        guard let number = Int(self) else { return nil }

        var fullMac = String(number, radix: 16, uppercase: true)

        if fullMac.count == 11 {
            fullMac = "0" + fullMac
        }

        guard fullMac.count == 12 else { return nil }

        var macArray = Array(fullMac)
            .chunked(into: 2)
            .map { $0.map { String($0) }.joined() }

        macArray.reverse()

        return macArray.suffix(3).joined()
    }

    var id: Int32? {
        return Int32(self, radix: 16)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

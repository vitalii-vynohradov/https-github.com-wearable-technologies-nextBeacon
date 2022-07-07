//
//  UIApplication+Volt.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 09.06.2021.
//

import UIKit

extension UIApplication {
    func openAppSettings(completion: ((Bool) -> Void)? = nil) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: completion)
    }
}

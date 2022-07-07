//
//  VoltApp.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 03.06.2021.
//

import CoreLocation
import SwiftUI

@main
struct VoltApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PPEView()
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarTitle("ppe_title".localized())
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    init() {
        Logger.shared.logLevel = .debug
        UITabBar.appearance().backgroundColor = UIColor(named: "TabViewColor")
        UITableView.appearance().backgroundColor = UIColor(named: "TabViewColor")
    }
}

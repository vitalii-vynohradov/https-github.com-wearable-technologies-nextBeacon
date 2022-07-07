//
//  View2+Volt.swift
//  Volt
//
//  Created by Mykyta Smaha on 09.06.2021.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            hidden()
        } else {
            self
        }
    }

    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                NavigationLink(
                    destination: view,
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

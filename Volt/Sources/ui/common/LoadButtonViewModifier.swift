//
//  LoadButtonViewModifier.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct LoadButtonViewModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled

    var backgroundDisableColor = Color(.lightGray)
    var backgroundColor = Color("AccentColor")
    var textColor = Color.white
    var verticalTextPadding: CGFloat = 10.0
    var horizontalTextPadding: CGFloat = 20.0
    var verticalPadding: CGFloat = 30.0
    var horizontalPadding: CGFloat = 0.0
    var topPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.vertical, verticalTextPadding)
            .padding(.horizontal, horizontalTextPadding)
            .background(isEnabled ? backgroundColor : backgroundDisableColor)
            .foregroundColor(textColor)
            .font(.title3.bold())
            .clipShape(Capsule())
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
    }
}

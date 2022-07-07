//
//  DefaultNavigationLinkViewModifier.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct DefaultNavigationLinkViewModifier: ViewModifier {
    var backgroundColor = Color.white
    var textColor = Color(.black)
    var verticalTextPadding: CGFloat = 10.0
    var horizontalTextPadding: CGFloat = 20.0
    var verticalPadding: CGFloat = 2.0
    var horizontalPadding: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalTextPadding)
            .padding(.horizontal, horizontalTextPadding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.title3.bold())
            .clipShape(Capsule())
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
    }
}

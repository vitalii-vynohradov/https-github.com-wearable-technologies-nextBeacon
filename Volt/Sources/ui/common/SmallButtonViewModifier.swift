//
//  SmallButtonViewModifier.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct SmallButtonViewModifier: ViewModifier {
    var backgroundColor = Color(.systemBackground)
    var textColor = Color(.label)
    var strokeColor = Color(.label)
    var cornerRadius: CGFloat = 4.0
    var lineWidth: CGFloat = 1.0
    var verticalTextPadding: CGFloat = 8.0
    var horizontalTextPadding: CGFloat = 8.0
    var verticalPadding: CGFloat = 0.0
    var horizontalPadding: CGFloat = 10.0
    var topPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0

    func body(content: Content) -> some View {
        content
            .padding(.vertical, verticalTextPadding)
            .padding(.horizontal, horizontalTextPadding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.caption)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth))
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
    }
}

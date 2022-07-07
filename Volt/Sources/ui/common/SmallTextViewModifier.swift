//
//  SmallTextViewModifier.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct SmallTextViewModifier: ViewModifier {
    var textColor = Color(.label)
    var verticalPadding: CGFloat = 0.0
    var horizontalPadding: CGFloat = 10.0
    var topPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0
    var alignment = Alignment.center

    func body(content: Content) -> some View {
        content
            .frame(alignment: alignment)
            .font(.caption)
            .foregroundColor(textColor)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
    }
}

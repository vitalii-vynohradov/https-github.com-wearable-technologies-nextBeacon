//
//  EnabledButtonStyle.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct EnabledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var backgroundColor = Color(.black)
    var disabledBackgroundColor = Color(.gray)
    var textColor = Color.white
    var font = Font.title3.bold()
    var clipShape = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    var verticalTextPadding: CGFloat = 10.0
    var horizontalTextPadding: CGFloat = 20.0
    var verticalPadding: CGFloat = 30.0
    var horizontalPadding: CGFloat = 0.0
    var topPadding: CGFloat = 0.0
    var bottomPadding: CGFloat = 0.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalTextPadding)
            .padding(.horizontal, horizontalTextPadding)
            .background(isEnabled ? backgroundColor : disabledBackgroundColor)
            .foregroundColor(textColor)
            .font(font)
            .clipShape(clipShape)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
    }
}

struct EnabledButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press Me") {
            print("Button Pressed")
        }
        .buttonStyle(EnabledButtonStyle())
    }
}

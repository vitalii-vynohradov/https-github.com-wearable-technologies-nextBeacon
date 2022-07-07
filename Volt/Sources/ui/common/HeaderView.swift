//
//  HeaderView.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct HeaderView: View {
    var text = "Title"
    var backgroundColor = Color("TabViewColor")
    var foregroundColor = Color(.label)
    var topPadding: CGFloat = 70.0
    var bottomPadding: CGFloat = 10.0
    var alignment = Alignment.center
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Spacer(minLength: 30)

            Text(text)
                .font(.title.bold())
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
                .frame(maxWidth: .infinity, alignment: alignment)

            Button(action: {
                action?()
            }, label: {
                Image(systemName: "xmark")
            })
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .padding(.trailing, bottomPadding)
            .frame(maxWidth: 30, alignment: alignment)
            .hidden(action == nil)
        }
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

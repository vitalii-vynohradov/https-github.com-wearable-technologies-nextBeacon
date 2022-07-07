//
//  AlertView.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct AlertView: View {
    var text = "Title"
    var buttonTitle = "Ok"
    var buttonAction: () -> Void = {}

    var body: some View {
        VStack(spacing: 0.0) {
            Text(text)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20.0)
                .padding(.horizontal, 20.0)
                .font(.footnote)

            Divider()

            Button(buttonTitle) {
                buttonAction()
            }
            .padding(.vertical, 10.0)
            .padding(.horizontal, 20.0)
            .foregroundColor(.accentColor)
            .font(.title3)
        }
        .background(Color("TabViewColor"))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .padding(.horizontal, 40.0)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}

//
//  CompleteListView.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 07.07.2022.
//

import SwiftUI

struct CompleteListView: View {
    @ObservedObject var model: CompleteListViewModel = CompleteListViewModel()
    
    var body: some View {
        VStack {
            List(model.allEquipment, id: \.self) { item in
                HStack {
                    Text("\(item.name)")
                        .font(.title2)
                        .padding(.vertical)
                    Spacer()
                    Image(systemName: item.available ? "checkmark" : "xmark")
                        .frame(width: 40, height: 40)
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(item.available ? Color.green : Color.red)
                        .background(Color("TabViewColor"))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 10)

            Spacer()

            Button("missions_check_button".localized()) { model.check() }
                .modifier(LoadButtonViewModifier())
                .disabled(model.isScanning)
                .padding()
        }
        .alert(isPresented: $model.showAlertError) {
            return Alert(title: Text(model.alertErrorMsg))
        }
        .background(Color("TabViewColor"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { model.subscribe() }
        .onDisappear { model.unsubscribe() }
    }
}

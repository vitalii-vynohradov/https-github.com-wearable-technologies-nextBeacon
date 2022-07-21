//
//  PPEView.swift
//  Volt
//
//  Created by Mykyta Smaha on 05.07.2021.
//

/*import SwiftUI

struct PPEView: View {
    @ObservedObject var model: PPEViewModel = PPEViewModel()

    var body: some View {
        VStack {
            List {
                switch model.allPPE.isEmpty {
                case true:
                    Text("eq_empty".localized())
                case false:
                    ForEach(model.allPPE) { item in
                        HStack {
                            Text("\(item.name)")
                                .padding(.top)
                                .padding(.bottom)
                                .padding(.trailing, 10.0)

                            Spacer()

                            if item.equipmentId > 0 {
                                Text("ID: \(item.mac)")
                                    .modifier(SmallTextViewModifier(horizontalPadding: 0.0))
                                VStack {
                                    Text("ppe_paired".localized())
                                        .modifier(SmallTextViewModifier(textColor: .green))
                                    Button("ppe_unpair".localized()) {
                                        model.ensureUnpair(id: item.equipmentId)
                                    }
                                    .modifier(SmallTextViewModifier())
                                    .alert(isPresented: $model.showUnpairAlert) {
                                        return Alert(title: Text("ppe_unpair".localized()),
                                                     message: Text(model.alertErrorMsg),
                                                     primaryButton: .cancel(
                                                        Text("general_cancel".localized())
                                                     ),
                                                     secondaryButton: .destructive(
                                                        Text("general_ok".localized()),
                                                        action: { unpair() }
                                                     ))
                                    }
                                }
                            } else {
                                Button("ppe_pair".localized()) {
                                    model.pair(typeId: item.id)
                                }
                                .modifier(SmallButtonViewModifier())
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            .alert(isPresented: $model.showAlertError) {
                return Alert(title: Text("error_generic_title".localized()),
                             message: Text(model.alertErrorMsg))
            }

            Spacer()

            NavigationLink(
                destination: CompleteListView()
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarTitle("missions_load_title".localized())
            ) {
                Text("missions_load_title".localized().uppercased())
                    .font(.title3.bold())
                    .padding(35.0)
            }
            .disabled(!model.areAllPPEPaired)
        }
        .background(Color("TabViewColor"))
        .onAppear { model.subscribe() }
        .onDisappear { model.unsubscribe() }
        .fullScreenCover(isPresented: $model.showQrReader,
                         onDismiss: { model.dismissedQrReader = true },
                         content: { QRCodeReaderView(isPresented: $model.showQrReader, qrCode: $model.qrCode) })
    }

    private func unpair() {
        withAnimation {
            model.unpair()
        }
    }
}

struct PPEView_Previews: PreviewProvider {
    static var previews: some View {
        PPEView(model: PPEViewModel())
    }
}*/

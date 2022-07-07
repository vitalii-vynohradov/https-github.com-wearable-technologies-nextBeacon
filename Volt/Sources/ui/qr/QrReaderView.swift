//
//  QrReaderView.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 09.06.2021.
//

import Combine
import SwiftUI

struct QrReaderView: View {
    @StateObject private var model: QrReaderViewModel

    let cameraPermissionAlert = Alert(title: Text("camera_permission_title".localized()),
                                      message: Text("camera_permission_text".localized()),
                                      primaryButton: .default(
                                          Text("general_settings".localized()),
                                          action: { UIApplication.shared.openAppSettings() }),
                                      secondaryButton: .cancel(Text("general_cancel".localized())))

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Text("camera_permission_text".localized())
                        .multilineTextAlignment(.center)
                        .padding(20)

                    QrReaderPreview(captureSession: model.captureSession)
                        .onAppear {
                            model.setup()
                        }
                        .alert(isPresented: $model.showPermissionAlertError, content: { cameraPermissionAlert })
                }

                Spacer()

                Text(model.qrCode ?? "qr_reader_info_text".localized())
                    .hidden(model.isCameraUnavailable)
            }
            .padding()
            .navigationBarTitle(Text("qr_reader_title".localized()))
            .navigationBarItems(trailing: Button("Cancel") {
                model.isPresented = false
            })
        }
    }

    init(isPresented: Binding<Bool> = .constant(true), qrCode: Binding<String?> = .constant("n.a.")) {
        _model = StateObject(wrappedValue: QrReaderViewModel(presented: isPresented, qrCode: qrCode))
    }
}

struct QrReaderView_Previews: PreviewProvider {
    static var previews: some View {
        QrReaderView()
    }
}

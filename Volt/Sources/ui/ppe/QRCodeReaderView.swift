//
//  QRCodeReaderView.swift
//  Volt
//
//  Created by Mykyta Smaha on 11.07.2021.
//

import SwiftUI

struct QRCodeReaderView: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var model: QrReaderViewModel

    init(isPresented: Binding<Bool> = .constant(true), qrCode: Binding<String?> = .constant("n.a.")) {
        _model = StateObject(wrappedValue: QrReaderViewModel(presented: isPresented, qrCode: qrCode))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                HeaderView(text: "qr_reader_title".localized())

                QrReaderPreview(captureSession: model.captureSession)

                ZStack {
                    HStack {
                        Button("general_cancel".localized()) {
                            model.isPresented = false
                        }
                        .foregroundColor(Color(.label))

                        Spacer()

                        Button(action: {
                            // TODO: switch camera
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .font(.title3)
                                .foregroundColor(Color(.label))
                        })
                    }
                    .padding()

                    Text(model.qrCode ?? "qr_reader_info_text".localized())
                        .hidden(model.isCameraUnavailable)
                        .padding()
                }
            }
            if model.showPermissionAlertError {
                AlertView(text: "camera_permission_text".localized(), buttonTitle: "general_settings".localized()) {
                    UIApplication.shared.openAppSettings()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                model.setup()
            }
        }
        .onAppear {
            model.setup()
        }
    }
}

struct QRCodeReaderView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeReaderView()
    }
}

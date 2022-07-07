//
//  QrReaderViewModel.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 09.06.2021.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

final class QrReaderViewModel: ObservableObject {
    private let service = QrReaderService()

    @Published var qrCode: String!
    @Published var isCameraUnavailable = false
    @Published var showPermissionAlertError = false

    @Binding var isPresented: Bool
    @Binding var result: String?

    var captureSession: AVCaptureSession

    private var subscriptions = Set<AnyCancellable>()

    init(presented: Binding<Bool>, qrCode: Binding<String?>) {
        _isPresented = presented
        _result = qrCode
        captureSession = service.captureSession

        service.$qrCode.sink { [weak self] code in
            guard let qrCode = code else { return }
            self?.qrCode = qrCode
            self?.result = qrCode
            self?.isPresented = false
        }
        .store(in: &self.subscriptions)

        service.$isCameraUnavailable.sink { [weak self] unavailable in
            self?.isCameraUnavailable = unavailable
        }
        .store(in: &self.subscriptions)

        service.$showPermissionAlertError.sink { [weak self] show in
            self?.showPermissionAlertError = show
        }
        .store(in: &self.subscriptions)
    }

    func setup() {
        service.checkForPermissions()
        service.configure()
    }
}

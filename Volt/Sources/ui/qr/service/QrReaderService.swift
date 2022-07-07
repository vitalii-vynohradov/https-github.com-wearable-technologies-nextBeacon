//
//  QrReaderService.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 09.06.2021.
//

import AVFoundation
import Foundation
import UIKit

class QrReaderService: NSObject {
    @Published var qrCode: String?
    @Published var isCameraUnavailable = false
    @Published var showPermissionAlertError = false

    let captureSession = AVCaptureSession()

    private var isFinishScanning = false
}

extension QrReaderService {
    func checkForPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    DispatchQueue.main.async {
                        self.isCameraUnavailable = true
                    }
                }
            })
        default:
            DispatchQueue.main.async {
                self.isCameraUnavailable = true
                self.showPermissionAlertError = true
            }
        }
    }

    public func configure() {
        setup()
    }
}

extension QrReaderService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            guard !isFinishScanning else { return }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}

private extension QrReaderService {
    func setup() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = .continuousAutoFocus
                captureDevice.unlockForConfiguration()
            } catch {
                self.isCameraUnavailable = true
                Logger.debug(error.localizedDescription)
            }
        }

        let captureDeviceInput: AVCaptureDeviceInput
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            self.isCameraUnavailable = true
            Logger.debug(error.localizedDescription)
            return
        }

        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        captureSession.startRunning()
    }

    func failed() {
        Logger.debug("QR failed")
    }

    func found(code: String) {
        Logger.debug("Found QR: \(code)")
        isFinishScanning = true
        qrCode = code
    }
}

//
//  QrReaderPreview.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 09.06.2021.
//

import AVFoundation
import SwiftUI

struct QrReaderPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }

        override var layer: AVCaptureVideoPreviewLayer {
            return super.layer as? AVCaptureVideoPreviewLayer ?? self.layer
        }
    }

    let captureSession: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.layer.session = captureSession
        view.layer.connection?.videoOrientation = .portrait

        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}
}

struct QrReaderPreview_Previews: PreviewProvider {
    static var previews: some View {
        QrReaderPreview(captureSession: AVCaptureSession())
            .frame(height: 300)
    }
}

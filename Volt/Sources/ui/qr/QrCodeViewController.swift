//
//  QrCodeViewController.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 21.07.2022.
//

import Foundation
import UIKit

protocol QrCodeDelegate: NSObject {
    func onQrCode(code: String)
}

class QrCodeViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    private var videoLayer: CALayer!

    var codeReader: QrCodeReader! = QrCodeReader()

    weak var delegate: QrCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        videoLayer = codeReader.videoPreview
        videoPreview.layer.addSublayer(videoLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeReader.startReading { code in

            Logger.debug("QR code: \(code)")

            self.navigationController?.popViewController(animated: true)

            self.delegate?.onQrCode(code: code)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeReader.stopReading()
    }
}

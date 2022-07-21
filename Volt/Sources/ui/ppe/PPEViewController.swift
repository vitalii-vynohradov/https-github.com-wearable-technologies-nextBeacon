//
//  PPEViewController.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class PPEViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var completeButton: UIButton!
    
    private var model: PPEViewModel = PPEViewModel()

    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self

        model.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.unsubscribe()
    }
}

extension PPEViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allPPE.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: PPEViewCell.ID, for: indexPath)

        if let ppeCell = cell as? PPEViewCell {
            ppeCell.update(model.allPPE[indexPath.row])
            return ppeCell
        }

        return cell
    }
}

extension PPEViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)

        let equipment = model.allPPE[indexPath.row]

        let isPaired = equipment.equipmentId > 0

        if isPaired {
            ensureUnpair(id: equipment.equipmentId)
        } else {
            selectedIndex = indexPath.row
            if let destination = UIStoryboard.init(
                name: "Main",
                bundle: Bundle.main
            ).instantiateViewController(withIdentifier: "QrCodeViewController") as? QrCodeViewController {
                destination.delegate = self
                navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
}

extension PPEViewController: PPEViewModelDelegate {
    func onUpdateAllReady(ready: Bool) {
        completeButton.isEnabled = ready
    }

    func onUpdateEquipment() {
        table.reloadData()
    }
}

extension PPEViewController: QrCodeDelegate {
    func onQrCode(code: String) {
        let id = model.allPPE[selectedIndex].id

        if !model.handleQrCodeFor(typeId: id, code: code) {
            let alert = UIAlertController(title: "Can't parse QR code: \(code)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

private extension PPEViewController {
    func ensureUnpair(id: Int32) {
        let alert = UIAlertController(title: "Unpair", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.model.unpair(id: id)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))


        self.present(alert, animated: true)
    }
}

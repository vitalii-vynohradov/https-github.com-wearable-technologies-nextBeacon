//
//  CompleteListViewController.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class CompleteListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var checkButton: UIButton!
    
    private var model: CompleteListViewModel = CompleteListViewModel()

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

    @IBAction func onCheck(_ sender: Any) {
        model.check()
    }
}

extension CompleteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}

extension CompleteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allEquipment.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CompleteListViewCell.ID, for: indexPath)

        if let listCell = cell as? CompleteListViewCell {
            listCell.update(model.allEquipment[indexPath.row])
            return listCell
        }

        return cell
    }
}

extension CompleteListViewController: CompleteListViewModelDelegate {
    func onUpdateScan(isScanning: Bool) {
        checkButton.isEnabled = !isScanning
    }

    func onUpdateEquipment() {
        table.reloadData()
    }
}

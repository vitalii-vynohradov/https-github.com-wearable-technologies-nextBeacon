//
//  CompleteListViewController.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class CompleteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!

    private var model: CompleteListViewModel = CompleteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.delegate = self
        self.table.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.subscribe()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.table.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.unsubscribe()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allEquipment.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CompleteListViewCell.ID, for: indexPath)

        if let listCell = cell as? CompleteListViewCell {
            let device = model.allEquipment[indexPath.row]
            listCell.nameLabel.text = device.name
            listCell.statusImageView.image = device.available ? UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")
            listCell.statusImageView.tintColor = device.available ? .green : .red
            return listCell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func onCheck(_ sender: Any) {
        model.check()
    }
}

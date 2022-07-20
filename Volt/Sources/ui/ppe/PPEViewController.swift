//
//  PPEViewController.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class PPEViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!

    private var model: PPEViewModel = PPEViewModel()

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
        return model.allPPE.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: PPEViewCell.ID, for: indexPath)

        if let ppeCell = cell as? PPEViewCell {
            let device = model.allPPE[indexPath.row]
            ppeCell.nameLabel.text = device.name
            ppeCell.idLabel.text = device.mac
            return ppeCell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
    }
    
}

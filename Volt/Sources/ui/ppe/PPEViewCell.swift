//
//  PPEViewCell.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class PPEViewCell: UITableViewCell {
    static let ID = "PPECell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var pairLabel: UILabel!

    func update(_ equipment: PPEDetails) {
        let isPaired = equipment.mac != ""
        nameLabel.text = equipment.name
        idLabel.text = isPaired ? "ID: \(equipment.mac)" : ""
        pairLabel.text = isPaired ? "UNPAIR" : "PAIR"
    }
}

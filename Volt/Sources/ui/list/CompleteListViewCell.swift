//
//  CompleteListViewCell.swift
//  NEXT.Beacon
//
//  Created by Vitalii Vynohradov on 20.07.2022.
//

import Foundation
import UIKit

class CompleteListViewCell: UITableViewCell {
    static let ID = "ListCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!

    func update(_ equipment: EquipmentDataHolder) {
        nameLabel.text = equipment.name
        statusImageView.image = equipment.available ? UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")
        statusImageView.tintColor = equipment.available ? .green : .red
    }
}

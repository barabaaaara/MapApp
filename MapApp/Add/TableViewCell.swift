//
//  TableViewCell.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/05/16.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var radioButtonImage: UIImageView!
    @IBOutlet weak var smokingAreaImage: UIImageView!
    @IBOutlet weak var smokingAreaLabel: UILabel!
    @IBOutlet weak var smokingAreaDiscription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

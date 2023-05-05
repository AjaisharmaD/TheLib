//
//  TitleTableViewCell.swift
//  TheLib
//
//  Created by Ideas2it on 04/04/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        iconImage.tintColor = Constants.logoTintColor
    }
    
}

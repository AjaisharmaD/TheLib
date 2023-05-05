//
//  MyBookTableViewCell.swift
//  TheLib
//
//  Created by Ideas2it on 06/04/23.
//

import UIKit

class MyBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var countLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        //titleLabel
        titleLable.font = Constants.bookTitleFont
        
        // COunt Lable
        countLable.font = Constants.statusLableFont
        countLable.textColor = Constants.secondryTextColor
        
    }
    
}

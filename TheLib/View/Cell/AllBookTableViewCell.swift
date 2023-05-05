//
//  AllBookTableViewCell.swift
//  TheLib
//
//  Created by Ideas2it on 21/04/23.
//

import UIKit

class AllBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorLable: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Book Title
        bookTitle.font = Constants.bookTitleFont
        
        // Author Lable
        authorLable.font = Constants.statusLableFont
        authorLable.textColor = Constants.secondryTextColor
        
        // Add Button
        addButton.tintColor = Constants.logoTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  BookTableViewCell.swift
//  TheLib
//
//  Created by Ideas2it on 04/04/23.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var dropDownStack: UIStackView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var opt1: UIButton!
    @IBOutlet weak var opt2: UIButton!
    @IBOutlet weak var opt3: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookImage.contentMode = .scaleAspectFit
        bookTitle.numberOfLines = 0
        
        self.selectionStyle = .none
        
        // Status Lable
        statusLabel.text = BookStatus.wantToRead.rawValue
        
        //Menu View
        menuView.isHidden = true
        menuView.layer.shadowRadius = Constants.shadowRadius
        menuView.layer.shadowOpacity = Constants.shadowOpacity
        menuView.layer.shadowOffset = Constants.shadowOffset
        menuView.layer.shadowColor = Constants.shadowColor
        menuView.layer.cornerRadius = Constants.cornerRadius
        
        //Options
        opt1.tintColor = Constants.logoTintColor
        opt2.tintColor = Constants.logoTintColor
        opt3.tintColor = Constants.logoTintColor
        
        //Drop Down Button
        downBtn.tintColor = Constants.logoTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

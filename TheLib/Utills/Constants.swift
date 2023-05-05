//
//  Constants.swift
//  TheLib
//
//  Created by Ideas2it on 21/04/23.
//

import UIKit

public class Constants {
    
    //lable Font
    public static let titleFont: UIFont = .systemFont(ofSize: 40.0, weight: .bold)
    public static let bookTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .bold)
    public static let statusLableFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular)
    
    //Selected Item color
    public static let selctedItemColor: UIColor = .red
    public static let secondryTextColor: UIColor = .gray
    
    // Text Field
    public static let borderWidth: CGFloat = 2.0
    public static let correctColor: CGColor = UIColor.green.cgColor
    public static let wrongColor: CGColor = UIColor.red.cgColor
    
    // Common Color
    public static let logoTintColor: UIColor = .black
    
    // For Creating card
    public static let shadowColor: CGColor = UIColor.black.cgColor
    public static let shadowOffset: CGSize = CGSize(width: 0.0, height: 2.0)
    public static let shadowRadius: CGFloat = 4.0
    public static let shadowOpacity: Float = 0.5
    public static let cornerRadius: CGFloat = 8.0
    public static let padding: CGFloat = 10
}

//
//  Validation.swift
//  TheLib
//
//  Created by Ideas2it on 07/04/23.
//

import UIKit

public class Validation {
    public func isEmailValid(email: String) -> Bool {
        let regex = "^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return pred.evaluate(with: email)
    }
    
    func isPasswordValid(password: String) -> Bool {
        let regex  = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: password)
    }
}

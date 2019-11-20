//
//  DismissKeyboard.swift
//  Yaker
//
//  Created by Francisco Barreto on 29/10/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    func dismissKey() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = true
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }

}

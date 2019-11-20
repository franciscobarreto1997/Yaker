//
//  Alert.swift
//  Yaker
//
//  Created by Francisco Barreto on 03/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {

    func displayAlert(withTitle title: String, withMessage message: String) {
        
        self.view.endEditing(true)

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alertController, animated: true, completion: nil)

    }

}

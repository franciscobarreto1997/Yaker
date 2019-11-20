//
//  User.swift
//  Yaker
//
//  Created by Francisco Barreto on 30/10/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation

class User {
    
    let email: String
    let username: String
    let password: String
    let posts = [Post]()
    
    init(email: String, username: String, password:String) {
        self.email = email
        self.username = username
        self.password = password
    }
    
    //MARK: Add location
    
}

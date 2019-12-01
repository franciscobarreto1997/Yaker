//
//  Post.swift
//  Yaker
//
//  Created by Francisco Barreto on 30/10/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation

class Post {
    
    var sumOfLikes = 1
    var content: String?
    var userId: String?
    var createdAt: Date?
    var id: String?
    var likes: Dictionary<String, Bool>?
    var locationId: String?
    
    func addOneLike() {
        return sumOfLikes += 1
    }
    
    func takeOneLike() {
        return sumOfLikes -= 1
    }
    
    
    init(content: String, sumOfLikes: Int, userID: String, createdAt: Date, id: String, likes: Dictionary<String, Bool>, locationID: String) {
        self.content = content
        self.sumOfLikes = sumOfLikes
        self.userId = userID
        self.createdAt = createdAt
        self.id = id
        self.likes = likes
        self.locationId = locationID
    }
    
    //MARK: Add location
    
   
    
}

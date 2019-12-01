//
//  NewPostViewController.swift
//  Yaker
//
//  Created by Francisco Barreto on 16/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var newPostView: UIView!
    @IBOutlet weak var newPostTextView: UITextView!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var ref: DatabaseReference!
    
    let currentUserID = Auth.auth().currentUser!.uid
    
    let locationManager = CLLocationManager()
        
    var currentRegion: CLRegion?
    

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        ref = Database.database().reference()
                        
        setupViews()
        
        self.dismissKey()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPostButtonTapped(_ sender: Any) {
        
        let newPostText = newPostTextView.text
        
        if newPostText!.count < 3 {
            displayAlert(withTitle: "Invalid Message", withMessage: "Your yak can't be smaller than 3 letters")
            return
        }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.string(from: Date.init())
                
        let likesDictionary = [currentUserID: true]
        

        
        ref.child("locations").observeSingleEvent(of: .value) { (snapshot) in
            let locations = snapshot.value as! [String: AnyObject]
            var name: String?
            var locationID: String?
            
            for location in locations {
                name = location.value["name"] as? String
                if name == self.currentRegion?.identifier {
                    locationID = location.key
                    
                    let postRef = self.ref.child("locations").child(locationID!).child("posts").childByAutoId()
                    let postID = postRef.key!
                    
                    let newPostInfo = ["content": String(newPostText!),
                                       "userID": String(self.currentUserID),
                                       "sumOfLikes": 1,
                                       "createdAt": date,
                                       "id": postID,
                                       "likes": likesDictionary,
                                       "locationID": locationID!] as [String : AnyObject]
                    
                    
                    postRef.setValue(newPostInfo)
                    return
                }
            }
            
        }
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupViews() {
        newPostTextView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        newPostView.layer.cornerRadius = 10
        newPostButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
}

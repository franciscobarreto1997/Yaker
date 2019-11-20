//
//  FeedViewController.swift
//  Yaker
//
//  Created by Francisco Barreto on 12/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var writePostButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeBarButtonItem: UITabBarItem!
    

    private var posts = [Post]()
    
    var ref: DatabaseReference!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Date.init())
        
        tabBar.selectedItem = homeBarButtonItem
        
        ref = Database.database().reference()
        
        getPosts()
                
        let writePostImage = UIImage(named: "write")
        let tintedImage = writePostImage?.withTintColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        writePostButton.setImage(tintedImage, for: .normal)

        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
            
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.white
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "11D5B2")!], for: UIControl.State.selected)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! PostTableViewCell
        
        cell.postContentLabel.text = posts[indexPath.row].content
        cell.postLikesLabel.text = String(posts[indexPath.row].sumOfLikes)
        cell.arrowUpButton.setImage(UIImage(named: "arrowUp")?.withTintColor(UIColor.init(hexString: "#DDEBE8")!), for: .normal)
        cell.arrowDownButton.setImage(UIImage(named: "arrowDown")?.withTintColor(UIColor.init(hexString: "#DDEBE8")!), for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
        let date = posts[indexPath.row].createdAt!
        
        let secondsSincePost = Date.init().timeIntervalSince(date)
        
        var dateStringTimeStamp = secondsSincePost.format(using: [.hour, .minute])
        
        let secondsToDouble = secondsSincePost.advanced(by: 0)
        
        switch secondsToDouble {
        case ..<3600:
            dateStringTimeStamp = secondsSincePost.format(using: [.minute])
        default:
            dateStringTimeStamp = secondsSincePost.format(using: [.hour, .minute])
        }
        
        cell.postTimeStampLabel.text = dateStringTimeStamp! + " " + "ago"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func arrowUpButtonTapped(_ sender: UIButton) {
                
        let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)

        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            let rowIndex =  indexPath.row
            
            let sumOfLikes = self.ref.child("posts").child(posts[rowIndex].id!).child("sumOfLikes")
            let likes = self.ref.child("posts").child(posts[rowIndex].id!).child("likes")
            
                posts[rowIndex].addOneLike()
                sumOfLikes.setValue(posts[rowIndex].sumOfLikes)
                
                switch segmentedControl.selectedSegmentIndex {
                case 1:
                     let sortedPosts = posts.sorted() { $0.sumOfLikes > $1.sumOfLikes }
                     posts = sortedPosts
                default:
                    let sortedPosts = posts.sorted() { $0.createdAt! > $1.createdAt! }
                    posts = sortedPosts
                }
                        
            
        }
        
        
        
    }
    
    @IBAction func arrowDownButtonTapped(_ sender: UIButton) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            let rowIndex =  indexPath.row
             
            let post = self.ref.child("posts").child(posts[rowIndex].id!).child("sumOfLikes")
            
                posts[rowIndex].takeOneLike()
                posts[rowIndex].likesEnabled = false
                post.setValue(posts[rowIndex].sumOfLikes)
            
                switch segmentedControl.selectedSegmentIndex {
                case 1:
                     let sortedPosts = posts.sorted() { $0.sumOfLikes > $1.sumOfLikes }
                     posts = sortedPosts
                     tableView.reloadData()
                default:
                    let sortedPosts = posts.sorted() { $0.createdAt! > $1.createdAt! }
                    posts = sortedPosts
                    tableView.reloadData()
                }
            
            
        }
        
  
    }
    
    func getPosts() {
        
        
                        
        let postRef = self.ref.child("posts")
                
        postRef.observe(DataEventType.value, with: { (snapshot) in
          let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.posts = []
            for post in postDict {
                 let content = post.value["content"] as! String
                let sumOfLikes = post.value["sumOfLikes"] as! Int
                let userID = post.value["userID"] as! String
                let createdAt = post.value["createdAt"] as! String
                let postID = post.value["id"] as! String
                                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: createdAt)
                                
                let newPost = Post(content: content, sumOfLikes: sumOfLikes, userID: userID, createdAt: date!, id: postID)
                
                self.posts.append(newPost)
                
                switch self.segmentedControl.selectedSegmentIndex {
                case 1:
                    let sortedPosts = self.posts.sorted() { $0.sumOfLikes > $1.sumOfLikes }
                    self.posts = sortedPosts
                    self.tableView.reloadData()
                default:
                    let sortedPosts = self.posts.sorted() { $0.createdAt! > $1.createdAt! }
                    self.posts = sortedPosts
                    self.tableView.reloadData()
                }
                
                self.postsCountLabel.text = String(self.posts.count)
            }
            
        })
                
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
             let sortedPosts = posts.sorted() { $0.sumOfLikes > $1.sumOfLikes }
             posts = sortedPosts
             tableView.reloadData()
        default:
            let sortedPosts = posts.sorted() { $0.createdAt! > $1.createdAt! }
            posts = sortedPosts
            tableView.reloadData()
        }
        
    }
    
}

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
import CoreLocation

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var writePostButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeBarButtonItem: UITabBarItem!
    

    private var posts = [Post]()
    private var locations = [Location]()
    
    var ref: DatabaseReference!
        
    var currentRegion: CLRegion?
    
    let currentUserID = Auth.auth().currentUser!.uid
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ref = Database.database().reference()
        
//        createLocations()
        getLocations()
        getPosts()
        setupTableView()
        setupTabBar()
        setupTopBar()
        setupSegmentedControl()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        
        cell.postContentLabel.text = post.content
        cell.postLikesLabel.text = String(post.sumOfLikes)
        cell.arrowUpButton.setImage(UIImage(named: "arrowUp")?.withTintColor(UIColor.init(hexString: "#DDEBE8")!), for: .normal)
        cell.arrowDownButton.setImage(UIImage(named: "arrowDown")?.withTintColor(UIColor.init(hexString: "#DDEBE8")!), for: .normal)
                
        if post.likes![currentUserID] != nil {
            cell.arrowUpButton.isEnabled = false
            cell.arrowDownButton.isEnabled = false
        }
        
        
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
            
            let post = posts[rowIndex]
            let sumOfLikes = self.ref.child("posts").child(post.id!).child("sumOfLikes")
            let likes = self.ref.child("posts").child(post.id!).child("likes")
            let likesDictionary = [currentUserID: true]
            
            
                post.addOneLike()
                sumOfLikes.setValue(post.sumOfLikes)
                likes.updateChildValues(likesDictionary)
                
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
             
            let post = posts[rowIndex]
            let sumOfLikes = self.ref.child("posts").child(post.id!).child("sumOfLikes")
            let likes = self.ref.child("posts").child(post.id!).child("likes")
            let likesDictionary = [currentUserID: true]
            
            
            
                post.takeOneLike()
                sumOfLikes.setValue(post.sumOfLikes)
                likes.updateChildValues(likesDictionary)
            
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
                let likes = post.value["likes"] as! Dictionary<String, Bool>
                                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: createdAt)
                                
                let newPost = Post(content: content, sumOfLikes: sumOfLikes, userID: userID, createdAt: date!, id: postID, likes: likes)
                
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
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func setupTabBar() {
        tabBar.selectedItem = homeBarButtonItem
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.white
    }
    
    func setupTopBar() {
        let writePostImage = UIImage(named: "write")
        let tintedImage = writePostImage?.withTintColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        writePostButton.setImage(tintedImage, for: .normal)
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "11D5B2")!], for: UIControl.State.selected)
    }
    
    func setupLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
    }
    
    
    func getLocations() {
        
        let locationRef = ref.child("locations")
        
        locationRef.observe(DataEventType.value) { (snapshot) in
            let locationDict = snapshot.value as? [String : AnyObject] ?? [:]
            for location in locationDict {
                let name = location.value["name"] as! String
                let latitude = location.value["latitude"] as! Double
                let longitude = location.value["longitude"] as! Double
                
                let newLocation = Location(name: name, latitude: latitude, longitude: longitude)
                
                self.locations.append(newLocation)
            }
            self.monitorRegions()
            self.setupLocationServices()
            
        }
    }
    
    func createLocations() {
        let home = Location(name: "home", latitude: 38.706476, longitude: -9.341905)
        
        let homeLocationInfo = ["name": home.name, "latitude": home.latitude, "longitude": home.longitude] as [String : AnyObject]
        
        ref.child("locations").childByAutoId().setValue(homeLocationInfo)
        
    }
    
    func monitorRegions() {
        for location in self.locations {
            locationManager.startMonitoring(for: location.geofenceRegion!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let homeLocation = self.locations[0]
        
        let userLocation = Location(name: "user", latitude: locValue.latitude, longitude: locValue.longitude)
        if (userLocation.geofenceRegion!.intersects(homeLocation.geofenceRegion!)) {
            currentRegion = homeLocation.geofenceRegion
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewPost" {
            let newPostViewController = segue.destination as? NewPostViewController
            newPostViewController?.currentRegion = currentRegion
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        displayAlert(withTitle: "Your in", withMessage: "Your at \(region.identifier) buddy!")
        currentRegion = region
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        displayAlert(withTitle: "Your out", withMessage: "You left \(region.identifier) buddy!")
    }
    
}

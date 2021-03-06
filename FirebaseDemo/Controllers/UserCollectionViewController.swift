//
//  UserCollectionViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

// Set reuseIdentifierCell
private let reuseIdentifier = "UserCell"

class UserCollectionViewController: UICollectionViewController {
    
    // TODO: Step 1 Create Firebase Database and Property
    // Create database object
    var databaseRef = FIRDatabase.database().reference()
    
    // Property
    var usersDic = [String : AnyObject]?()
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Step 2 OberveEvent is listening to firebase realtime database
        // on path user_profile
        self.databaseRef.child("user_profile").observeEventType(.Value, withBlock: { (snapshot) in
            
            // Remove all before loading data
            self.userImagesArray.removeAll()
            self.userNamesArray.removeAll()
            self.usersDic?.removeAll()
            
            // Set Firebase object to users dictionary property
            self.usersDic = snapshot.value as? [String : AnyObject]
            
            // Loop each user in dictionary object
            for(userId, details) in self.usersDic!{
                
                // Get image url and name
                let img = details["profile_pic_small"] as? String
                let name = details["name"] as! String
                
                // Set image and name to array
                self.userImagesArray.append(img!)
                self.userNamesArray.append(name)
                self.collectionView?.reloadData()
            }
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // ###### self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userImagesArray.count
    }
    
    // TODO: Step 3 Configure Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Create custom cell object
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
        
        // Configure the cell
        let imageUrl = NSURL(string: userImagesArray[indexPath.row])
        let imageData = NSData(contentsOfURL: imageUrl!)
        
        cell.profileImageView.image = UIImage(data: imageData!)
        cell.nameLabel.text = userNamesArray[indexPath.row]
        return cell
    }
}

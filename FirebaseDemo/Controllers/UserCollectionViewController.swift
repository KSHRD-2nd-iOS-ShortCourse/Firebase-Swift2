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

    // Create database object
    var databaseRef = FIRDatabase.database().reference()
    
    // Property
    var usersDic = NSDictionary?()
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.databaseRef.child("user_profile").observeEventType(.Value, withBlock: { (snapshot) in
            
            // Set Firebase object to users dictionary property
            self.usersDic = snapshot.value as? NSDictionary
            
            // Loop each user in dictionary object
            for(userId, details) in self.usersDic!{
                
                // Get image url and name
                let img = details.objectForKey("profile_pic_small") as! String
                let name = details.objectForKey("name") as! String
                let firstName = name.componentsSeparatedByString(" ")[0]
                
                // Set image and name to array
                self.userImagesArray.append(img)
                self.userNamesArray.append(firstName)
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

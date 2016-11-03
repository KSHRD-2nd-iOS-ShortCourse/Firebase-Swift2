//
//  UserCollectionViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "UserCell"

class UserCollectionViewController: UICollectionViewController {

    var databaseRef = FIRDatabase.database().reference()
    var usersDic = NSDictionary?()
    
    var userNamesArray = [String]()
    var userImagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.databaseRef.child("user_profile").observeEventType(.Value, withBlock: { (snapshot) in
            self.usersDic = snapshot.value as? NSDictionary
            for(userId, details) in self.usersDic!{
                let img = details.objectForKey("profile_pic_small") as! String
                let name = details.objectForKey("name") as! String
                let firstName = name.componentsSeparatedByString(" ")[0]
                
                self.userImagesArray.append(img)
                self.userNamesArray.append(firstName)
                self.collectionView?.reloadData()
            }
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userImagesArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
    
        // Configure the cell
    
        let imageUrl = NSURL(string: userImagesArray[indexPath.row])
        let imageData = NSData(contentsOfURL: imageUrl!)
        
        cell.profileImageView.image = UIImage(data: imageData!)
        cell.nameLabel.text = userNamesArray[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

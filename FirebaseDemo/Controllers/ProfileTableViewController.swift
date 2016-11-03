//
//  ProfileTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FBSDKLoginKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ### Load User from firebase then display to control on screen */
        // Check if have user
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            
            
            // Get Facebook Token
            if let accessTokenString = FBSDKAccessToken.currentAccessToken(){
                
                self.nameLabel.text = name
                // let data = NSData(contentsOfURL: photoUrl!)
                // self.profileImageView.image = UIImage(data: data!)
                
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                
                
                // MARK: **** START Firebase Store
                // ### Load high resolution image and if have image don't request to facebook
                
                let storage = FIRStorage.storage()
                let storageRef = storage.referenceForURL("gs://fir-swift2.appspot.com")
                
                storageRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                    if error != nil{
                        print("Unable to download image \(error?.localizedDescription)")
                    }else{
                        if data != nil {
                            print("User already has an image, no need to download from facebook")
                            self.profileImageView.image = UIImage(data: data!)
                        }
                    }
                })
                
                if self.profileImageView.image == nil {
                    // Get profile pic
                    var profilePicture =  FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":"300", "width":"300", "redirect":false], HTTPMethod: "GET").startWithCompletionHandler { (connection, result, error) in
                        // Check if error occur
                        if error != nil {
                            // error happen
                            print(error.localizedDescription)
                            return
                        }
                        
                        // Cast to NSDictionary to user objectForKey method
                        let dictionary = result as? NSDictionary
                        let data = dictionary?.objectForKey("data") // get data
                        
                        let urlPic = data?.objectForKey("url") as! String // get url
                        
                        // Convert url to nsdata
                        if let imageData = NSData(contentsOfURL: NSURL(string: urlPic)!){
                            // Get firebase storage path
                            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                            
                            // Upload image to firebase storage
                            let uploadTask = profilePicRef.putData(imageData, metadata: nil){
                                metadata, error in
                                if error == nil {
                                    let downloadUrl = metadata?.downloadURL()
                                    
                                }else{
                                    print("Error in downloading image \(error?.localizedDescription)")
                                }
                            }
                            self.profileImageView.image = UIImage(data: imageData)
                        }
                        print(result)
                    }
                }
                // MARK:  Start Firebase Store END ****
                
                
            }else{
                self.nameLabel.text = email!
            }
        } else {
            // No user is signed in.
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: - Sign Out
    @IBAction func signOut(sender: AnyObject) {
        // signs the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        // signs the user out of the Facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKLoginManager().logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

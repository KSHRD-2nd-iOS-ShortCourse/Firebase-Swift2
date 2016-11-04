//
//  SignUpTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 10/28/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailVerificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // MARK: - Firebase Sign Up Action
    @IBAction func signUpAction(sender: AnyObject) {
        
        // Call firebase create user
        FIRAuth.auth()?.createUserWithEmail(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            // Create account error
            if error != nil {
                print("Error \(error?.localizedDescription)")
            }else{
                
                // Check Verification Swift
                if self.emailVerificationSwitch.on {
                    print("----> Verification Turn On")
                    user!.sendEmailVerificationWithCompletion({ error in
                        if let error = error {
                            // An error happened.
                            print("Error \(error.localizedDescription)")
                        } else {
                            // Email sent.
                            print("Email sent to \(user!.email!)")
                        }
                    })
                }else{
                    print("----> Verification Turn Off")
                    print("No Email Sent \(user!.email!)")
                }
                
                /* #### This code is user after create register user screen  #### */
                
                // When the user logs in for the frist time, we'll store the users name and the users email on their profile page.
                // also store the small version of the profile picture in the database and in the storage
                
                if error == nil {
                    let storage = FIRStorage.storage()
                    
                    let storageRef = storage.referenceForURL("gs://fir-swift2.appspot.com")
                    let profilePicRef = storageRef.child(user!.uid + "/profile_pic_small.jpg")
                    
                    // store the userID
                    let userId = user?.uid
                    
                    let databaseRef = FIRDatabase.database().reference()
                    databaseRef.child("user_profile").child(userId!).child("profile_pic_small").observeEventType(.Value, withBlock: { (snapshot) in
                        let profile_pic = snapshot.value as? String?
                        print("in block")
                        if profile_pic == nil{
                            if let imageData = UIImagePNGRepresentation(UIImage(named: "default-avatar")!){
                                let uploadTask = profilePicRef.putData(imageData, metadata: nil){
                                    metadata, error in
                                    if error == nil {
                                        let dowloadURL = metadata?.downloadURL()
                                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(dowloadURL?.absoluteString)
                                    }else{
                                        print("error in downloading image")
                                    }
                                }
                            }
                            
                            // store data into the users profile page
                            databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName ?? "")
                            databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                            databaseRef.child("user_profile").child("\(user!.uid)/website").setValue("")
                        }else{
                            print("User has logged in earlier")
                        }
                    })
                }
                /* #### This code is user after create register user screen  #### */
                

            
                try! FIRAuth.auth()?.signOut()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

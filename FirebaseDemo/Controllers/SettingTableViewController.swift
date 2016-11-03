//
//  SettingTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingTableViewController: UITableViewController {
    
    // Create Firebase database and auth object
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from firebase realtime storage to control
        var refHandle = self.ref.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
            
            // Convert snapshot to Dictionary
            let userDict = snapshot.value as! NSDictionary
            print(userDict)
            
            // Get data of user by user id
            let userDetails = userDict.objectForKey(self.user!.uid)
            
            // Set value to textfield
            self.nameTextField.text = userDetails?.objectForKey("name") as? String
            self.genderTextField.text = userDetails?.objectForKey("gender") as? String
            self.ageTextField.text = userDetails?.objectForKey("age") as? String
            self.emailTextField.text = userDetails?.objectForKey("email") as? String
            self.websiteTextField.text = userDetails?.objectForKey("website") as? String
        })
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    // MARK: Update User Profile
    @IBAction func update(sender: AnyObject) {
        
        // Set value to firebase storage 
        self.ref.child("user_profile").child("\(user!.uid)/name").setValue(nameTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(genderTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/age").setValue(ageTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/email").setValue(emailTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/website").setValue(websiteTextField.text)
        
    }
    
}

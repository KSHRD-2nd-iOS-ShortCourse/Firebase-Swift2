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
    
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    
    @IBOutlet var ageTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refHandle = self.ref.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
            let userDict = snapshot.value as! NSDictionary
            print(userDict)
            let userDetails = userDict.objectForKey(self.user!.uid)
            
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
    
    @IBAction func update(sender: AnyObject) {
        self.ref.child("user_profile").child("\(user!.uid)/name").setValue(nameTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(genderTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/age").setValue(ageTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/email").setValue(emailTextField.text)
        self.ref.child("user_profile").child("\(user!.uid)/website").setValue(websiteTextField.text)
        
    }
    
}

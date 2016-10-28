//
//  SignUpTableViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 10/28/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailVerificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        FIRAuth.auth()?.createUserWithEmail(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
          
            // Create account error
            if error != nil {
                print("Error \(error.debugDescription)")
                return
            }
            
            
            if self.emailVerificationSwitch.on {
                if let user = FIRAuth.auth()?.currentUser{
                    user.sendEmailVerificationWithCompletion({ error in
                        if let error = error {
                            // An error happened.
                            print("Error \(error.debugDescription)")
                        } else {
                            // Email sent.
                            print("Email sent")
                        }
                    })
                }
            }else{
                if let user = FIRAuth.auth()?.currentUser {
                    // User is signed in.
                    print(user.email)
                } else {
                    // No user is signed in.
                    print("NO User")
                }
            }
        }
    }
}

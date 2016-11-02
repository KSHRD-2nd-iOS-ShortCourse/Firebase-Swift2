//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 10/28/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInTableViewController: UITableViewController {

    var email = ""
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func backToSignIn(segue : UIStoryboardSegue){
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            print("DidChangeListener : \(user.email!)")
            print ("Email verified. Signing in...\(user.email!)")
            self.performSegueWithIdentifier("showHome", sender: nil)
            
        } else {
            // No user is signed in.
            print("DidChangeListener : NO user sign in")
        }
        
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//                // User is signed in.
//                print("DidChangeListener : \(user.email!)")
//                print ("Email verified. Signing in...\(user.email!)")
//                self.performSegueWithIdentifier("showHome", sender: nil)
//                
//            } else {
//                // No user is signed in.
//                print("DidChangeListener : NO user sign in")
//            }
//        }
    }

    @IBAction func signIn(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("Error \(error.debugDescription)")
                return
            }
            if let user = FIRAuth.auth()?.currentUser {
                
                if !user.emailVerified {
                    let alertVC = UIAlertController(title: "Verify Email", message: "Sorry. Your email address has not yet been verified. Please verify your email!", preferredStyle: .Alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .Default) {
                        (_) in
                        user.sendEmailVerificationWithCompletion(nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                } else {
                    print ("Email verified. Signing in...\(user.email!)")
                    self.performSegueWithIdentifier("showHome", sender: nil)
                    
                }
            }else{
                print("No account \(error.debugDescription)")
            }
        }
        
        
        //        FIRAuth.auth()?.signInWithEmail("yinkokpheng@gmail.com", password: "123456") { (user, error) in
        //            if error != nil {
        //                print("Error \(error.debugDescription)")
        //                return
        //            }
        //
        //            if let user = FIRAuth.auth()?.currentUser {
        //                // User is signed in.
        //                print(user.email)
        //            } else {
        //                // No user is signed in.
        //                print("NO User")
        //            }
        //        }
    }

    @IBAction func forgetPassword(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to =yinkokpheng@gmail.", preferredStyle: .Alert)
        
        // Add the text field for text entry.
        alertVC.addTextFieldWithConfigurationHandler { textField in
            // If you need to customize the text field, you can do so here.
            /*
             Listen for changes to the text field's text so that we can toggle the current
             action's enabled property based on whether the user has entered a sufficiently
             secure entry.
             */
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleTextFieldTextDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: textField)
           
           
        }

        
        let alertActionOkay = UIAlertAction(title: "Okay", style: .Default) {
            (_) in
            FIRAuth.auth()?.sendPasswordResetWithEmail(self.email) { error in
                if let error = error {
                    // An error happened.
                    print(error)
                } else {
                    // Password reset email sent.
                    print("Password reset email sent. \(self.email)")
                }
            }
        }
        

        let alertActionCancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldTextDidChangeNotification
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        email = textField.text!
        print("TextDidChangeNotification \(email)")
    }

}


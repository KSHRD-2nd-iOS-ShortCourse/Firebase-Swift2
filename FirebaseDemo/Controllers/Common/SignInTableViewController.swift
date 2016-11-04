//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 10/28/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignInTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    
    // TODO: Step 1 Create Property
    var email = ""
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var facebookCustomButton: UIButton!
    @IBOutlet var facebookButton: FBSDKLoginButton!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    // TODO: Step 2 Back to Sign In Screen
    @IBAction func backToSignIn(segue : UIStoryboardSegue){ }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Step 7 Facebook button configure
        // Add delegate for FacebookButton
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
        
        // Custom Button property
        facebookCustomButton.backgroundColor = UIColor.blueColor()
        facebookCustomButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        facebookCustomButton.addTarget(self, action: #selector(handleCustomFBLogin), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        // TODO: Step 6 Check Firebase current user
        if let user = FIRAuth.auth()?.currentUser{
            // User is signed in.
            print("viewDidAppear Email verified. Signing in...: \(user.email)")
            self.performSegueWithIdentifier("showHome", sender: nil)
        }else{
            // No user is signed in.
            print("viewDidAppear : NO user sign in")
        }
    }
    
    // TODO: Step 3 - Firebase SignIn
    @IBAction func signIn(sender: AnyObject) {
        // Firebase SignIn with Email
        FIRAuth.auth()?.signInWithEmail(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            // If error occur
            if error != nil {
                print("Error \(error.debugDescription)")
                return
            }
            
            // If no error, get signed in user
            // Check email verified
            if !(user!.emailVerified) {
                let alertVC = UIAlertController(title: "Verify Email", message: "Sorry. Your email address has not yet been verified. Please verify your email!", preferredStyle: .Alert)
                let alertActionOkay = UIAlertAction(title: "Okay", style: .Default) {
                    (_) in
                    user!.sendEmailVerificationWithCompletion(nil)
                }
                let alertActionCancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                
                alertVC.addAction(alertActionOkay)
                alertVC.addAction(alertActionCancel)
                self.presentViewController(alertVC, animated: true, completion: nil)
            } else {
                print ("Email verified. Signing in...\(user!.email!)")
                self.performSegueWithIdentifier("showHome", sender: nil)
            }
        }
    }
    
    // TODO: Step 4 - Firebase Reset Password
    @IBAction func forgetPassword(sender: AnyObject) {
        let alertVC = UIAlertController(title: "Reset Password", message: "Please enter your email. we will send reset password link to your email.", preferredStyle: .Alert)
        
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
        
        // Alert action Ok
        let alertActionOkay = UIAlertAction(title: "Okay", style: .Default) {
            (_) in
            
            // When user click Ok, Request to firebase to send password reset to user email
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
    
    // TODO: Step 5 - UITextFieldTextDidChangeNotification
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        email = textField.text!
        print("TextDidChangeNotification \(email)")
    }
    
    
    // TODO: Step 8 Facebook Login Button Delegate Method
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        loadingIndicator.startAnimating()
        // Check if error occur
        if error != nil {
            // error happen
            loadingIndicator.startAnimating()
            print(error.localizedDescription)
            return
        }else if (result.isCancelled){
            loadingIndicator.startAnimating()
            print("Cancelled")
            return
        }else{
            //fetchProfile()
            firebaseLoginWithCredential()
            print("Successfull login in with facebook...")
        }
    }
    
    // TODO: Step 9 Facebook Button Logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Log Out")
    }
    
    // TODO: Step 10 Facebook Custom Method
    // Custom method for custom fb login button
    func handleCustomFBLogin() {
        let parameters = ["email", "public_profile", "user_friends"]
        
        // Call facebook login method
        FBSDKLoginManager().logInWithReadPermissions(parameters, fromViewController: self) { (result, error) in
            // Check if error occur
            if error != nil {
                // error happen
                print(error.localizedDescription)
                return
            }else if (result.isCancelled){
                print("Cancelled")
                return
            }else{
                // Logged in
                if result.grantedPermissions.contains("public_profile"){
                    if let token = FBSDKAccessToken.currentAccessToken(){
                        print(token.tokenString)
                        //self.fetchProfile()
                        self.firebaseLoginWithCredential()
                    }
                }
            }
        }
    }
    
    // TODO: Step 11 Facebook Get Profile
    func fetchProfile() {
        print("fetch profile")
        
        // Create facebook graph with fields
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).startWithCompletionHandler { (connection, result, error) in
            // Check if error occur
            if error != nil {
                // error happen
                print(error.localizedDescription)
                return
            }
            print(result)
        }
    }
    
    // TODO: Step 12 Firebase Login With Credential
    func firebaseLoginWithCredential() {
        // Get Facebook Token
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        // Check token string have don't have -> return
        guard let accessTokenString = accessToken.tokenString else{
            return
        }
        
        // if have -> process login with credential
        let credentials = FIRFacebookAuthProvider.credentialWithAccessToken(accessTokenString)
        
        // TODO: Step 13 Sign in with Credential
        FIRAuth.auth()?.signInWithCredential(credentials, completion: { (user, error) in
            // Check if error occur
            if error != nil {
                // error happen
                print("Something went wrong with our FB user", error)
                return
            }
            self.loadingIndicator.stopAnimating()
            print("Successfully logged in with our user", user)
            
            
            // TODO: Step 14 Save facebook image to Firebase Storage and url to Firebase Realtime 
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
                    
                    if profile_pic == nil{
                        if let imageData = NSData(contentsOfURL: user!.photoURL!){
                            // Upload image to firebase storage
                            let uploadTask = profilePicRef.putData(imageData, metadata: nil){
                                metadata, error in
                                
                                if error == nil {
                                    // get uploaded image url
                                    let dowloadURL = metadata?.downloadURL()
                                    
                                    // save image url to firebase realtime database profile_pic_small
                                    databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(dowloadURL?.absoluteString)
                                }else{
                                    print("error in downloading image")
                                }
                            }
                        }
                        
                        // store data into the users profile page in firebase realtime
                        databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
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
            
            
            self.performSegueWithIdentifier("showHome", sender: nil)
        })
    }
    
}


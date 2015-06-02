//
//  signInViewController.swift
//  template
//
//  Created by Dav Sun on 4/1/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class signInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.username {
            self.password.becomeFirstResponder()
        }
        if textField == self.password {
            self.signInLogic()
        }
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sign(sender: AnyObject) {
        self.signInLogic();
    }
    func signInLogic(){
        ProgressHUD.show(nil)
        if self.username.text != "" || self.password.text != "" {
            PFUser.logInWithUsernameInBackground(self.username.text, password: self.password.text) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    if let user = user {
                        ProgressHUD.dismiss()
                        ProgressHUD.showSuccess(nil)
                        self.username.text = ""
                        self.password.text = ""
                        var first:Bool = user["first"] as! Bool
                        
                        if first == false {
                            self.performSegueWithIdentifier("dash", sender: self)
                        }else{
                            if user.username == "Mueller" {
                                self.performSegueWithIdentifier("picture", sender: self)
                            }else{
                                self.performSegueWithIdentifier("code", sender: self)
                            }
                        }
                    }
                } else {
                    // The login failed. Check error to see why.
                    var code = error!.code;
                    if code == 100 {
                        ProgressHUD.showError("Problem Connecting!")
                    }
                    if code == 101 {
                        ProgressHUD.showError("Can't find you!.")
                    }
                }
            }
        }else{
            ProgressHUD.showError("Its Blank!");
        }
    }
}



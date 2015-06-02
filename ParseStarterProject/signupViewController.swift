//
//  signupViewController.swift
//  template
//
//  Created by Dav Sun on 4/1/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Bolts
import Parse

class signupViewController: UIViewController, UITextFieldDelegate {
    
    var length = 8;
    //length of the string limit
    var uppercase = 0;
    var number = 1;
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var submit: UIButton!

    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    // email requires manual addition
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pass.delegate = self
        self.pass1.delegate = self
        self.username.delegate = self
        self.email.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submit(sender: AnyObject) {
        self.submitLogic();
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if textField == self.email {
            self.username.becomeFirstResponder()
        }
        if textField == self.username {
            self.pass.becomeFirstResponder()
        }
        if textField == self.pass {
            self.pass1.becomeFirstResponder()
        }
        if textField == self.pass1 {
            self.submitLogic();
        }
        return true
    }
    func submitLogic(){
        var final = true;
        if !valid(self.username.text,from: "username") || !valid(self.pass.text,from: "password"){
            final = false;
        }
        if self.pass.text != self.pass1.text {
            final = false;
            ProgressHUD.showError("The passes don't match")
        }
        if final == true {
            var user = PFUser();
            user.username = username.text;
            user.password = pass.text;
            user["first"] = true;
            ProgressHUD.show("", interaction: false)
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
                    ProgressHUD.dismiss()
                    ProgressHUD.showSuccess(nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    var code = error!.code;
                    if code == 100 {
                        ProgressHUD.showError("Can't Connect");
                    }
                    if code == 202 {
                        ProgressHUD.showError("User already exists");
                    }
                    if code == 203 {
                        ProgressHUD.showError("Email already taken");
                    }
                }
            }
        }
    }

    func valid(input : String,from : String) -> Bool{
        var valids = true;
        if input.length < self.length {
            valids = false;
            ProgressHUD.showError("Length of \(from) too short.");
        }
        var up = 0;
        var num = 0;
        let letters = NSCharacterSet.uppercaseLetterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for uni in input.unicodeScalars {
            if letters.longCharacterIsMember(uni.value) {
                up++
            } else if digits.longCharacterIsMember(uni.value) {
                num++
            }
        }
        if up < self.uppercase {
            valids = false;
            ProgressHUD.showError("Not enough Uppercase letter in \(from).");

        }
        if num < self.number {
            valids = false;
            ProgressHUD.showError("Not enough Numbers in \(from).");

        }
        return valids;
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}

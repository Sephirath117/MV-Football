//
//  sayViewController.swift
//  template
//
//  Created by Dav Sun on 6/1/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class sayViewController: UIViewController {
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var submit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submitAction(sender: AnyObject) {
     var obj = PFObject(className: "Events")
        println(obj)
     obj["content"] = content.text
     obj["user"] = PFUser.currentUser()!
     obj.saveInBackgroundWithBlock {
        (success: Bool, error: NSError?) -> Void in
        if (success) {
            ProgressHUD.showSuccess(nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


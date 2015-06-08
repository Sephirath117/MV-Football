//
//  codeViewController.swift
//  template
//
//  Created by Dav Sun on 5/30/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class codeViewController: UIViewController {
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var code: UITextField!
    var code_object: PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submit(sender: AnyObject) {
        var query = PFQuery(className:"codes")
        query.whereKey("code", equalTo:code.text)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                println("The getFirstObject request failed.")
                ProgressHUD.showError("Code invalid!", interaction: false)
            } else {
                // The find succeeded.
                println("Successfully retrieved the code object.")
                if let object = object {
                    if object["used"] as! Bool == true {
                        ProgressHUD.showError("Code already used!", interaction: false)
                    }else{
                        if self.code.text == "mueller" {
                            println("HRESERFESr")
                            self.code_object = object;
                            self.performSegueWithIdentifier("picture", sender: self)
                        }else{
                            object["used"] = true;
                            object.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    self.code_object = object;
                                    self.performSegueWithIdentifier("picture", sender: self)
                                } else {
                                    println("ERROR: saving")
                                    // There was a problem, check error.description
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "picture" {
            let vc:pictureViewController = segue.destinationViewController as pictureViewController
            vc.code = self.code_object
        }
    }
}

//
//  settingsViewController.swift
//  template
//
//  Created by Dav Sun on 6/4/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class settingsViewController: UIViewController {
    
    @IBOutlet weak var profile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfile" {
            let vc:settingViewController = segue.destinationViewController as! settingViewController
            vc.user = PFUser.currentUser()!
        }
    }
}


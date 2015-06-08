//
//  dashboardViewController.swift
//  template
//
//  Created by Dav Sun on 4/2/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class dashboardViewController: UIViewController {
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profile: UIImageView!
    override func viewDidLoad() {
        self.username.text = PFUser.currentUser()!.username
        self.position.text = PFUser.currentUser()!["role"] as String
        super.viewDidLoad()
        println("yea")
        image();
        self.navigationItem.hidesBackButton = true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func image(){
        profile.layer.cornerRadius = 25;
        profile.layer.borderColor = UIColor.whiteColor().CGColor
        profile.layer.borderWidth = 2;
        self.profile.clipsToBounds = true;
        var file: PFFile = PFUser.currentUser()!["picture"] as PFFile;
        file.getDataInBackgroundWithBlock {
            (imageData: NSData?,error : NSError?) -> Void in
            if let imageData = imageData {
                self.profile.image = UIImage(data: imageData)                
            }
        }
    }
    
    @IBAction func signout(sender: AnyObject) {
        PFUser.logOut();
        self.navigationController?.popToRootViewControllerAnimated(true)
        ProgressHUD.showSuccess(nil)
    }
}


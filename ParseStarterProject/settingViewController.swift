//
//  settingViewController.swift
//  template
//
//  Created by Dav Sun on 4/2/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class settingViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate {
    
    var user: PFUser!
    @IBOutlet weak var block3: UIView!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var img: UIButton!
    @IBOutlet weak var block1: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var block2: UIView!
    @IBOutlet weak var block4: UIButton!
    @IBOutlet weak var editBlock1: UIButton!
    @IBOutlet weak var editBlock2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        block1.layer.cornerRadius = 5;
        block2.layer.cornerRadius = 5;
        block3.layer.cornerRadius = 5;
        block4.layer.cornerRadius = 5;
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser()!.username == user.username {
            self.img.hidden = false;
            self.editBlock1.hidden = false;
            self.editBlock2.hidden = false;
        }else{
            self.img.hidden = true;
            self.editBlock1.hidden = true;
            self.editBlock2.hidden = true;
        }
        image();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func image(){
        self.username.text = user.username
        if user["coach"] as Bool == true {
            self.position.text = "Coach"
        }
        else{
            self.position.text = "Player"
        }
        profile.layer.cornerRadius = 35;
        profile.layer.borderColor = UIColor.clearColor().CGColor
        profile.layer.borderWidth = 2;
        self.profile.clipsToBounds = true;
        var file: PFFile = user["picture"] as PFFile;
        file.getDataInBackgroundWithBlock {
            (imageData: NSData?,error : NSError?) -> Void in
            if let imageData = imageData{
                self.profile.image = UIImage(data: imageData)
            }
        }
    }
    @IBAction func imgAction(sender: AnyObject) {
        var ActionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Take a picture")
        ActionSheet.addButtonWithTitle("Choose a picture")
        ActionSheet.delegate = self
        ActionSheet.showInView(self.view)
    }
    func actionSheet(myActionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        println(buttonIndex);
        if buttonIndex == 1 {
            ShouldStartCamera(self, true)
        }
        if buttonIndex == 2 {
            ShouldStartPhotoLibrary(self, true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.profile.image = image;
        var file = PFFile(name: "picture.jpeg", data: UIImageJPEGRepresentation(image, 0.6));
        PFUser.currentUser()!["picture"] = file;
        PFUser.currentUser()!.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            ProgressHUD.showSuccess(nil)
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}


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
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var img: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        image();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func image(){
        profile.layer.cornerRadius = 60;
        profile.layer.borderColor = UIColor.whiteColor().CGColor
        profile.layer.borderWidth = 2;
        self.profile.clipsToBounds = true;
        var file: PFFile = PFUser.currentUser()!["picture"] as! PFFile;
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
        PFUser.currentUser()!["first"] = false;
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


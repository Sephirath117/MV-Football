//
//  pictureViewController.swift
//  template
//
//  Created by Dav Sun on 4/2/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class pictureViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate {
    
    var code : PFObject!
    var name : String!
    var number: Int!
    var positions: String!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var nameChange: UITextField!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var numtext: UITextField!
    @IBOutlet weak var positiontext: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.hidesBackButton = true;
        self.profile.image = UIImage(named: "default_profile.jpg");
        self.profile.layer.cornerRadius = 60;
        self.profile.layer.borderWidth = 2;
        self.profile.layer.borderColor = UIColor.redColor().CGColor;
        self.profile.clipsToBounds = true;
        self.done.hidden = true;
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var r = code["role"] as! String
        self.role.text = "You're a \(r)"
        name = code["Name"] as! String
        self.nameChange.text = name
        if code["coach"] as! Bool == true {
            self.num.hidden = true;
            self.numtext.hidden = true;
            self.position.hidden = true;
            self.positiontext.hidden = true;
        }else{
            number = code["number"] as! Int
            self.numtext.text = "\(number)"
            positions = code["position"] as! String
            self.positiontext.text = positions
        }
    }
    
    @IBAction func add(sender: AnyObject) {
        println("here")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneLogic(sender: AnyObject) {
        if code["coach"] as! Bool == true {
            PFUser.currentUser()!["coach"] = true;
            PFUser.currentUser()!["name"] = self.nameChange.text;
            PFUser.currentUser()!["role"] = code["role"] as! String;
            self.performSegueWithIdentifier("dash", sender: self)
        }else{
            PFUser.currentUser()!["coach"] = false;
            PFUser.currentUser()!["name"] = self.nameChange.text;
            PFUser.currentUser()!["role"] = self.positiontext.text;
            if let myNumber = NSNumberFormatter().numberFromString(self.numtext.text) {
                var myInt:Int = myNumber.integerValue
                PFUser.currentUser()!["number"] = myInt;
                // do what you need to do with myInt
                self.performSegueWithIdentifier("dash", sender: self)
            } else {
                ProgressHUD.showError("Please put a number!", interaction: false)
                // what ever error code you need to write
            }
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
            self.done.hidden = false;
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func signout(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        ProgressHUD.showSuccess(nil)
    }
}


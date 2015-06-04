//
//  rosterViewController.swift
//  template
//
//  Created by Dav Sun on 6/2/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class rosterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var sendUser:PFUser!
    @IBOutlet weak var collectView: UICollectionView!
    private let reuseIdentifier = "User"
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 15.0)
    private var arr = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.delegate = self
        collectView.dataSource = self
        println("yea")
        self.search(false)        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func search(s:Bool ){
        println("wehted")
        var query = PFQuery(className: "_User")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            println("WHAT")
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? AnyObject {
                    self.arr = objects as! NSArray
                    println("HERSEfseFdsfaekhjfasdfljkadsfhljadfs")
                }
                self.collectView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let user = arr[indexPath.item] as! PFObject
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! rosterViewCell
        cell.layer.cornerRadius = 5;
        cell.profile.layer.cornerRadius = 35;
        cell.name.text = user["username"] as! String
        var file: PFFile = user["picture"] as! PFFile;
        file.getDataInBackgroundWithBlock {
            (imageData: NSData?,error : NSError?) -> Void in
            if let imageData = imageData{
                cell.profile.layer.cornerRadius = 35;
                cell.profile.clipsToBounds = true;
                cell.profile.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = arr[indexPath.item] as! PFUser
        self.sendUser = user
        self.performSegueWithIdentifier("toProfile", sender: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfile" {
            let vc:settingViewController = segue.destinationViewController as! settingViewController
            vc.user = self.sendUser
        }
    }
}

//

//  PicUpload.swift

//  WorkoutMotivation

//

//  Created by Tarang khanna on 6/10/15.

//  Copyright (c) 2015 Tarang khanna. All rights reserved.

//



import UIKit

import CoreImage
import MobileCoreServices



var CIFilterNames = [
    
    "CIPhotoEffectChrome",
    
    "CIPhotoEffectFade",
    
    "CIPhotoEffectInstant",
    
    "CIPhotoEffectNoir",
    
    "CIPhotoEffectProcess",
    
    "CIPhotoEffectTonal",
    
    "CIPhotoEffectTransfer",
    
    "CISepiaTone"
    
]



var filterButton = UIButton()

class PicUpload: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet var uploadBtn: MKButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var originalImage: UIImageView!
    
    @IBOutlet weak var imageToFilter: UIImageView!
    
    
    
    
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    let tapRec = UITapGestureRecognizer()
    
    @IBOutlet var text: MKTextField!
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
//        originalImage.contentMode = UIViewContentMode.Center
//        
//        imageToFilter.contentMode = UIViewContentMode.Center
        
        //uploadBtn.hidden = true
        
        text.hidden = true
        
    }
    
    
    
    func unhide() {
        
        uploadBtn.hidden = false
        
        
        //text.hidden = false
        
        //textLabel.bringSubviewToFront(view)
        
        UIView.animateWithDuration(1, animations: {self.text.hidden = false})
        
    }
    
    
    
    func displayAlert(title: String, message: String) {
        
        
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        })))
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        
        
        var image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        //imageToFilter.hidden = false
        
        
        
    }
    
    
    
    @IBAction func camera(sender: AnyObject) {
        var picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate = self
        picker.allowsEditing = false
        picker.cameraCaptureMode = .Photo
        picker.mediaTypes = [kUTTypeImage as String]
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        imageToFilter.hidden = true
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        
        
        imageToPost.image = image
        
        
        
        var xCoord: CGFloat = 5
        
        var yCoord: CGFloat = 5
        
        var buttonWidth:CGFloat = 70
        
        var buttonHeight: CGFloat = 70
        
        var gapBetweenButtons: CGFloat = 5
        
        
        
        // Items Counter
        
        var itemCount = 0
        
        for itemCount = 0;  itemCount < CIFilterNames.count;  ++itemCount {
            
            
            
            // Button properties
            
            filterButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            
            filterButton.tag = itemCount
            
            filterButton.showsTouchWhenHighlighted = true
            
            filterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            filterButton.layer.cornerRadius = 6
            
            filterButton.clipsToBounds = true
            
            
            
            
            
            // Create filters for each button
            
            let ciContext = CIContext(options: nil)
            
            let coreImage = CIImage(image: originalImage.image)
            
            let filter = CIFilter(name: "\(CIFilterNames[itemCount])" )
            
            filter.setDefaults()
            
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            let filteredImageData = filter.valueForKey(kCIOutputImageKey) as! CIImage
            
            let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent())
            
            var imageForButton = UIImage(CGImage: filteredImageRef);
            
            
            
            // Assign filtered image to the button
            
            filterButton.setBackgroundImage(imageForButton, forState: UIControlState.Normal)
            
            
            
            
            
            // Add Buttons in the Scroll View
            
            xCoord +=  buttonWidth + gapBetweenButtons
            
            filtersScrollView.addSubview(filterButton)
            
        } // END LOOP ==========================================================
        
        
        
        
        
        // Resize Scroll View
        
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount+1), yCoord)
        
        unhide()
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tapRec.addTarget(self, action: "tappedView")
        
        self.view.addGestureRecognizer(tapRec)
        
        self.view.userInteractionEnabled = true
        
        text.layer.borderColor = UIColor.clearColor().CGColor
        
        text.floatingPlaceholderEnabled = true
        
        text.placeholder = "text.."
        
        text.tintColor = UIColor.MKColor.Blue
        
        text.rippleLocation = .Right
        
        text.cornerRadius = 0
        
        text.bottomBorderEnabled = true
        
        text.attributedPlaceholder = NSAttributedString(string:"text..",
            
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        
        text.delegate = self
        
    }
    
    
    
    
    
    // FILTER BUTTON ACTION
    
    func filterButtonTapped(sender: UIButton) {
        
        var button = sender as UIButton
        
        imageToFilter.hidden = false
        
        imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)
        
        imageToPost.image = imageToFilter.image
        
    }
    
    
    
    @IBAction func savePicButton(sender: AnyObject) {
        
        // Save the image into camera roll
        
        UIImageWriteToSavedPhotosAlbum(imageToFilter.image, nil, nil, nil)
        
        
        
        var alert = UIAlertView(title: "Filters",
            
            message: "Your image has been saved to Photo Library",
            
            delegate: self,
            
            cancelButtonTitle: "Ok")
        
        alert.show()
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    
    
    
    func tappedView() {
        
        // if selected image
        
        unhide()
        
    }
    
    
    
    @IBAction func uploadImage(sender: AnyObject) {
        
        unhide()
        
        // profile pic
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        
        var person = PFObject(className:"Person")
        
        person["score"] = 0
        
        person["username"] = PFUser.currentUser()?.username
        
        person["admin"] = true
        
        if text.text == nil {
            
            person["text"] = "  "
            
        } else {
            
            person["text"] = text.text
            
        }
        
        person["startTime"] = CFAbsoluteTimeGetCurrent()
        
        person["votedBy"] = []
        
        if let imageData = imageToPost.image!.mediumQualityJPEGNSData as NSData? { // choose low to reduce by 1/8
            
            var imageSize = Float(imageData.length)
            
            imageSize = imageSize/(1024*1024) // in Mb
            
            println("Image size is \(imageSize)Mb")
            
            if imageSize < 5 {
                
                if let imageFile = PFFile(name: "image.png", data: imageData) as PFFile? {
                    
                    person["imageFile"] = imageFile
                    
                    person.saveInBackgroundWithBlock {
                        
                        (success: Bool, error: NSError?) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        
                        
                        
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if (success) {
                            
                            //self.retrieve()
                            
                            self.performSegueWithIdentifier("picUploaded", sender: self)
                            
                            println("posted!")
                            
                            self.text.text = "" // empty it
                            
                        } else {
                            
                            println("Couldn't post!")
                            
                            SCLAlertView().showWarning("Error Posting", subTitle: "Check Your Internet Connection.")
                            
                            self.activityIndicator.stopAnimating()
                            
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                SCLAlertView().showWarning("Error Posting", subTitle: "File Too Big")
                
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }
            
        } else {
            
            SCLAlertView().showWarning("No Image", subTitle: "Select An Image to Upload.")
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        
        
        
        //        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        
        //        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        //        activityIndicator.center = self.view.center
        
        //        activityIndicator.hidesWhenStopped = true
        
        //        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        //        view.addSubview(activityIndicator)
        
        //        activityIndicator.startAnimating()
        
        //
        
        //        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //
        
        //        var post = PFObject(className: "Post")
        
        //
        
        //        //post["message"] = message.text
        
        //
        
        //        post["userId"] = PFUser.currentUser()!.objectId!
        
        //
        
        //        //post["text"] = PFUser.currentUser()?.text
        
        //
        
        //        let imageData = UIImagePNGRepresentation(imageToPost.image)
        
        //
        
        //        let imageFile = PFFile(name: "image.png", data: imageData)
        
        //
        
        //        post["imageFile"] = imageFile
        
        //
        
        //        post.saveInBackgroundWithBlock{(success, error) -> Void in
        
        //
        
        //            self.activityIndicator.stopAnimating()
        
        //
        
        //            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        //
        
        //            if error == nil {
        
        //
        
        //                self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
        
        //
        
        //                self.imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg.png")
        
        //
        
        //               // self.message.text = ""
        
        //
        
        //            } else {
        
        //
        
        //                self.displayAlert("Could not post image", message: "Please try again later")
        
        //
        
        //            }
        
        //
        
        //        }
        
        //
        
        //    }
        
        //
        
        //    override func didReceiveMemoryWarning() {
        
        //        super.didReceiveMemoryWarning()
        
        //        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    
    
}



extension UIImage {
    
    var highestQualityJPEGNSData:NSData { return UIImageJPEGRepresentation(self, 1.0) }
    var highQualityJPEGNSData:NSData    { return UIImageJPEGRepresentation(self, 0.75)}
    var mediumQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.5) }
    
    var lowQualityJPEGNSData:NSData     { return UIImageJPEGRepresentation(self, 0.25)}
    
    var lowestQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.0) }
    
}


//
//  PicUpload.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/10/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import CoreImage

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
class PicUpload: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    
    
    
    @IBOutlet weak var filtersScrollView: UIScrollView!
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
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
        

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        imageToPost.image = image
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // FILTER BUTTON ACTION
    func filterButtonTapped(sender: UIButton) {
        var button = sender as UIButton
        
        imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)
        
    }
    
    
    // SAVE PICTURE BUTTON
    @IBAction func savePicButton(sender: AnyObject) {
        // Save the image into camera roll
        UIImageWriteToSavedPhotosAlbum(imageToFilter.image, nil, nil, nil)
        
        var alert = UIAlertView(title: "Filters",
            message: "Your image has been saved to Photo Library",
            delegate: self,
            cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

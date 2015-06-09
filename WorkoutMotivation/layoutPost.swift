//
//  layoutPost.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/6/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

let reuseIdentifier2 = "Cell"

class layoutPost: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //pass in value for a post for ZOOM in feature
    
    var message : String = ""
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier2, forIndexPath: indexPath) as! CollectionViewCell
        cell.title2.text = message
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        println(self.view.frame.size)
        return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height - 10))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(-2, 0, 0, 0)
    }
    

    
}
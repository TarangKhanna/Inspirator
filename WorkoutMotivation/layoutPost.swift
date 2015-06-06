//
//  layoutPost.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/6/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit



class layoutPost: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    println(self.view.frame.size)
    return CGSizeMake(200, self.view.frame.size.height - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 200
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    
    return cell
    }
    
    
}
//
//  SBGestureTableView.swift
//  SBGestureTableView-Swift
//
//  Created by Ben Nichols on 10/3/14.
//  Copyright (c) 2014 Stickbuilt. All rights reserved.
//

import UIKit

class SBGestureTableView: UITableView, UIGestureRecognizerDelegate {

    var draggingViewOpacity = 1.0
    var isEnabled = true
    var edgeSlidingMargin = 0.0
    var edgeAutoscrollMargin = 0.0

    var cellReplacingBlock: ((SBGestureTableView, SBGestureTableViewCell) -> (Void))?
    var didMoveCellFromIndexPathToIndexPathBlock: ((NSIndexPath, NSIndexPath) -> (Void))?
    
    var canReorder: Bool {
        get {
            return longPress.enabled
        }
        set {
            longPress.enabled = newValue
        }
    }
    var minimumLongPressDuration : CFTimeInterval {
        get {
            return longPress.minimumPressDuration;
        }
        set {
            if (newValue <= 0) {
                longPress.minimumPressDuration = 0.5;
            }
            longPress.minimumPressDuration = newValue;
        }
    }
    
    private var scrollRate = 0.0
    private var currentLocationIndexPath : NSIndexPath?
    private var initialIndexPath : NSIndexPath?
    private var draggingView: UIImageView?
    private var savedObject: NSObject?
    private var scrollDisplayLink : CADisplayLink?
    private var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()

    
    func initialize() {
        longPress.addTarget(self, action: "longPress:")
        longPress.delegate = self
        addGestureRecognizer(longPress)
        cellReplacingBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            tableView.replaceCell(cell, duration: 0.3, bounce: 8, completion: nil)
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func indexPathFromGesture(gesture: UIGestureRecognizer) -> NSIndexPath? {
        let location = gesture.locationInView(self)
        let indexPath = indexPathForRowAtPoint(location)
        return indexPath
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func cancelGesture() {
        longPress.enabled = false
        longPress.enabled = true
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer) {
            if isEnabled && didMoveCellFromIndexPathToIndexPathBlock != nil {
                if let indexPath = indexPathFromGesture(gestureRecognizer) {
                    if let canMove = dataSource?.tableView?(self, canMoveRowAtIndexPath: indexPath) {
                        if canMove {
                            return true
                        }
                    } else {
                        return true
                    }
                }
            }
            return false
        }
        return true
    }
    
    func removeCellAt(indexPath: NSIndexPath, duration: NSTimeInterval, completion:(() -> Void)?) {
        let cell = cellForRowAtIndexPath(indexPath)! as! SBGestureTableViewCell;
        removeCell(cell, indexPath: indexPath, duration: duration, completion: completion)
    }
 
    func removeCell(cell: SBGestureTableViewCell, duration: NSTimeInterval, completion:(() -> Void)?) {
        let indexPath = indexPathForCell(cell)!
        removeCell(cell, indexPath: indexPath, duration: duration, completion: completion)
    }

    private func removeCell(cell: SBGestureTableViewCell, indexPath: NSIndexPath, var duration: NSTimeInterval, completion: (()-> Void)?) {
        if (duration == 0) {
            duration = 0.3;
        }
        isEnabled = false
        let animation = cell.frame.origin.x > 0 ? UITableViewRowAnimation.Right : UITableViewRowAnimation.Left
        UIView.animateWithDuration(duration * cell.percentageOffsetFromEnd(), animations: { () -> Void in
            cell.center = CGPointMake(cell.frame.size.width/2 + (cell.frame.origin.x > 0 ? cell.frame.size.width : -cell.frame.size.width),
                cell.center.y)
        }) { (finished) -> Void in
            UIView.animateWithDuration(duration, animations: { () -> Void in
                cell.leftSideView.alpha = 0
                cell.rightSideView.alpha = 0
            })
            self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation, duration:duration, completion: { () -> Void in
                cell.leftSideView.alpha = 1
                cell.rightSideView.alpha = 1
                cell.leftSideView.removeFromSuperview()
                cell.rightSideView.removeFromSuperview()
                self.isEnabled = true
                completion?()
            })
        }
    }
    
    func replaceCell(cell: SBGestureTableViewCell, var duration: NSTimeInterval, var bounce: (CGFloat), completion:(() -> Void)?) {
        if duration == 0 {
            duration = 0.25
        }
        bounce = fabs(bounce)
        
        UIView.animateWithDuration(duration * cell.percentageOffsetFromCenter(), animations: { () -> Void in
            cell.center = CGPointMake(cell.frame.size.width/2 + (cell.frame.origin.x > 0 ? -bounce : bounce), cell.center.y)
            cell.leftSideView.iconImageView.alpha = 0
            cell.rightSideView.iconImageView.alpha = 0
            }, completion: {(done) -> Void in
                UIView.animateWithDuration(duration/2, animations: { () -> Void in
                    cell.center = CGPointMake(cell.frame.size.width/2, cell.center.y)
                    }, completion: {(done) -> Void in
                        cell.leftSideView.removeFromSuperview()
                        cell.rightSideView.removeFromSuperview()
                        completion?()
                })
        })
    }
    
    func fullSwipeCell(cell: SBGestureTableViewCell, duration: NSTimeInterval, completion:(() -> Void)?) {
        UIView.animateWithDuration(duration * cell.percentageOffsetFromCenter(), animations: { () -> Void in
            cell.center = CGPointMake(cell.frame.size.width/2 + (cell.frame.origin.x > 0 ? cell.frame.size.width : -cell.frame.size.width), cell.center.y)
            }, completion: {(done) -> Void in
                completion?()
        })
    }
    
    private func deleteRowsAtIndexPaths(indexPaths: [AnyObject], withRowAnimation animation: UITableViewRowAnimation, duration: NSTimeInterval, completion:() -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        })
        CATransaction.commit()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        showOrHideBackgroundViewAnimatedly(false)
    }

    func showOrHideBackgroundViewAnimatedly(animatedly: Bool) {
        UIView.animateWithDuration(animatedly ? 0.3 : 0, animations: { () -> Void in
            self.backgroundView?.alpha = self.isEmpty() ? 1 : 0
        })
    }
    
    func isEmpty() -> (Bool) {
        if let dataSource = dataSource {
            let numberOfSections = dataSource.numberOfSectionsInTableView!(self)
            for var i = 0; i < numberOfSections; i++ {
                let numberOfRowsInSection = dataSource.tableView(self, numberOfRowsInSection: i)
                if numberOfRowsInSection > 0 {
                    return false
                }
            }
        }
        return true
    }

    override func insertRowsAtIndexPaths(indexPaths: [AnyObject], withRowAnimation animation: UITableViewRowAnimation) {
        super.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        showOrHideBackgroundViewAnimatedly(true)
    }

    override func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        super.insertSections(sections, withRowAnimation: animation)
        showOrHideBackgroundViewAnimatedly(true)
    }

    override func deleteRowsAtIndexPaths(indexPaths: [AnyObject], withRowAnimation animation: UITableViewRowAnimation) {
        super.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        showOrHideBackgroundViewAnimatedly(true)
    }
    
    override func deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        super.deleteSections(sections, withRowAnimation: animation)
        showOrHideBackgroundViewAnimatedly(true)
    }
    
    override func reloadData() {
        super.reloadData()
        showOrHideBackgroundViewAnimatedly(true)
    }
}

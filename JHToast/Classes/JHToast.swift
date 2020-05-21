//
//  JHToast.swift
//  JHToast_Example
//
//  Created by 李见辉 on 2020/5/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public class JHToast: UILabel,CAAnimationDelegate {

    private var forwardAnimationDuration : CFTimeInterval!
    private var backwardAnimationDuration : CFTimeInterval!
    private var textInsets : UIEdgeInsets!
    private var maxWidth : CGFloat!
    
    private let kDefaultForwardAnimationDuration:CFTimeInterval = 0.5
    private let kDefaultBackwardAnimationDuration:CFTimeInterval = 0.5
    private let kDefautlWaitAnimationDuration:CFTimeInterval = 1.0
    private let kDefaultTopMargin:CGFloat = 70
    private let kDefaultTextInset:CGFloat = 12
    
    public enum JHToastShowType {
        case top,
        center,
        bottom
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.forwardAnimationDuration = kDefaultForwardAnimationDuration
        self.backwardAnimationDuration = kDefaultBackwardAnimationDuration
        self.textInsets = UIEdgeInsets(top: kDefaultTextInset, left: kDefaultTextInset, bottom: kDefaultTextInset, right: kDefaultTextInset)
        self.maxWidth = UIScreen.main.bounds.size.width - 40
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 12.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    class public func showToast(text:String, type:JHToastShowType) {
        let toast = JHToast()
        
        toast.text = text
        toast.sizeToFit()
        toast.showType(type: type)
    }
    
    private func showType(type:JHToastShowType) {
        let keyWindow = UIApplication.shared.delegate?.window
        
        self.addAnimationGroup()
        var point = keyWindow??.center
        switch type {
        case .top:
            point?.y = kDefaultTopMargin
            break
        case .center:
            break
        case .bottom:
            point?.y = (keyWindow??.bounds.size.height)! - kDefaultTopMargin
            break
        }
        self.center = point!
        keyWindow??.addSubview(self)
        
    }
    
    /**  Animation  */
    private func addAnimationGroup() {
        let forwardAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        forwardAnimation.duration = self.forwardAnimationDuration
        forwardAnimation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.5, 1.7, 0.6, 0.85)
        forwardAnimation.fromValue = NSNumber.init(value: 0.0)
        forwardAnimation.toValue = NSNumber.init(value: 1.0)
        
        let backwardAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        backwardAnimation.duration = self.backwardAnimationDuration
        backwardAnimation.beginTime = forwardAnimation.duration + kDefautlWaitAnimationDuration
        backwardAnimation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0.4, 0.15, 0.5, -0.7)
        backwardAnimation.fromValue = NSNumber.init(value: 1.0)
        backwardAnimation.toValue = NSNumber.init(value: 0.0)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [forwardAnimation,backwardAnimation]
        animationGroup.duration = forwardAnimation.duration + backwardAnimation.duration + kDefautlWaitAnimationDuration
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        animationGroup.fillMode = kCAFillModeForwards
        self.layer.add(animationGroup, forKey: "customShow")
        
    }
    
    private func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.removeFromSuperview()
            self.layer.removeAnimation(forKey: "customShow")
        }
    }
    
    /**  text  */
    public override func sizeToFit() {
        super.sizeToFit()
        var frame = self.frame
        let width = self.bounds.size.width + self.textInsets.left + self.textInsets.right
        frame.size.width = min(width, self.maxWidth)
        frame.size.height = self.bounds.size.height + self.textInsets.top + self.textInsets.bottom
        self.frame = frame
        
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let size = self.text?.boundingRect(
            with: CGSize.init(width:  CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font:self.font ?? UIFont.systemFont(ofSize: 12)],
            context:nil).size
        let bound = CGRect.init(origin: bounds.origin, size: size!)
        return bound
    }
}

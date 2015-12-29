//
//  FRAlertView.swift
//  FRComponents
//
//  Created by fenggeren on 15/12/24.
//  Copyright © 2015年 fenggeren. All rights reserved.
//

import UIKit


class FGRAlertView: UIView {
    
    struct Inner {
        static var alertView: FGRAlertView! = nil
    }
    
    var container: UIView!
    var backgroundView: UIView!
    
    lazy var label =  UILabel()
    lazy var imageView = UIImageView()
    lazy var indicator = UIActivityIndicatorView()
    lazy var annularView = FGRAnnularProgressView()
    
    var showTimeInterval: NSTimeInterval = 1.5
    var animateTimeInterval: NSTimeInterval = 0.35

    /// 自动隐藏
    var autoHide = true
    
    var hideComplete: (Void -> Void)?
    
    
    // MARK: - Life Cycle
    
    
    convenience init() {
        self.init(frame: CGRectZero)
        config()
    }
    
    func config() {
        backgroundColor = UIColor.clearColor()
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clearColor()
        addSubview(container)
        
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0.7
        container.addSubview(backgroundView)

        setNeedsUpdateConstraints()
    }
    
    func setupLabel(text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.text = text
        container.addSubview(label)
    }
    func setupImageView(image: UIImage) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        container.addSubview(imageView)
    }
    func setupIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.activityIndicatorViewStyle = .WhiteLarge
        container.addSubview(indicator)
    }
    func setupAnnularView() {
        annularView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(annularView)
        annularView.finished = {
            Inner.alertView?.hide()
        }
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: container, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0),
        NSLayoutConstraint(item: container, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -100)])
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 10
    }
}

// MARK: - 主要的使用方法
extension FGRAlertView {
    
    class func show(title: String) {
        if Inner.alertView != nil { return }
        Inner.alertView = FGRAlertView()
        Inner.alertView.label.text = title
        Inner.alertView.show()
    }
    
    class func show(type: FGRAlertViewType, hideComplete: (Void -> Void)? = nil) {
        if Inner.alertView != nil { return }
        Inner.alertView = FGRAlertView()
        Inner.alertView.hideComplete = hideComplete
        switch type {
        case let .TextOnly(title):
            Inner.alertView.setupLabel(title)
        case let .TextImage(title, image):
            Inner.alertView.setupLabel(title)
            Inner.alertView.setupImageView(image)
        case .IndicatorOnly:
            Inner.alertView.setupIndicator()
        case let .TextIndicator(title):
            Inner.alertView.setupLabel(title)
            Inner.alertView.setupIndicator()
        case .AnnularProgress:
            Inner.alertView.setupAnnularView()
            Inner.alertView.annularView.time = Inner.alertView.showTimeInterval
            Inner.alertView.autoHide = false
        case let .TextAnnularProgress(title):
            Inner.alertView.setupLabel(title)
            Inner.alertView.setupAnnularView()
            Inner.alertView.annularView.time = Inner.alertView.showTimeInterval
            Inner.alertView.autoHide = false
        default:break
        }
        
        Inner.alertView.show()
        Inner.alertView.layoutSubviews(type)
    }
    
    class func showSuccess(success: String) {
        let img = UIImage(named: "FGRAlertView.bundle/success.png")!
        show(.TextImage(success, img))
    }
    class func showError(error: String) {
        let img = UIImage(named: "FGRAlertView.bundle/error.png")!
        show(.TextImage(error, img))
    }
    
    func show() {
        let window = UIApplication.sharedApplication().keyWindow!
        window.addSubview(self)
        frame = window.bounds
        label.preferredMaxLayoutWidth = frame.width * 0.65
        
        container.alpha = 0.0
        UIView.animateWithDuration(animateTimeInterval) { () -> Void in
            self.container.alpha = 1.0
            
            if self.autoHide {
                self.performSelector("hide", withObject: nil, afterDelay: self.showTimeInterval)
            }
        }
    }
    
    func hide() {
        if Inner.alertView == nil { return }
        
        UIView.animateWithDuration(animateTimeInterval, animations: { () -> Void in
            self.container.alpha = 0
            }) { (ok) -> Void in
                let closure = self.hideComplete
                self.removeFromSuperview()
                Inner.alertView = nil
                closure?()
        }
    }
    
    class func setProgress(progress: CGFloat) {
        if Inner.alertView == nil { return }
        if Inner.alertView.annularView.superview != nil {
            Inner.alertView.annularView.progress = progress
        }
    }
    
    func layoutSubviews(type: FGRAlertViewType) {
        var formats: [String] = ["H:|[bv]|", "V:|[bv]|"]
        
        switch type {
        case .TextImage(_, _):
            formats += ["H:|-hm-[l]-hm-|", "H:[iv]", "V:|-vm-[iv]-5-[l]-vm-|"]
            NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1.0, constant: 0)])
        case .TextOnly(_):
            formats += ["H:|-hm-[l]-hm-|", "V:|-vm-[l]-vm-|"]
        case .IndicatorOnly:
            formats += ["H:|-hm-[idt]-hm-|", "V:|-vm-[idt]-vm-|"]
        case .TextIndicator(_):
            formats += ["H:|-hm-[l]-hm-|", "H:[idt]", "V:|-vm-[idt]-10-[l]-vm-|"]
            NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1.0, constant: 0)])
        case .AnnularProgress:
            formats += ["H:|-hm-[av(50)]-hm-|", "V:|-vm-[av(50)]-vm-|"]
        case .TextAnnularProgress(_):
            formats += ["H:|-hm-[l]-hm-|", "H:[av(50)]", "V:|-vm-[av(50)]-10-[l]-vm-|"]
            NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: annularView, attribute: .CenterX, relatedBy: .Equal, toItem: label, attribute: .CenterX, multiplier: 1.0, constant: 0)])
        default:break
        }
        
        formats.forEach {
            NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat($0, options: [], metrics: ["hm": 25, "vm": 20],
                views: ["l": label, "iv": imageView, "idt":
                    indicator,"bv": backgroundView,
                "av": annularView]))
        }
    }
}

enum FGRAlertViewType {
    typealias Progress = CGFloat -> Void
    /// 仅有文字
    case TextOnly(String)
    case TextImage(String, UIImage)
    /// 菊花、 + 文字
    case IndicatorOnly
    case TextIndicator(String)
    /// 环形步进 bar行步进
    case AnnularProgress
    case TextAnnularProgress(String)
    case BarProgress
}

class FGRAnnularProgressView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            if progress > 1.2 {
                clock?.invalidate()
                clock = nil
                finished?()
            } else {
                setNeedsDisplay()
            }
        }
    }

    var time: NSTimeInterval = 2
    
    var circleLayer: CAShapeLayer!
    var clock: CADisplayLink?
    
    var finished: (() -> ())?

    convenience init() {
        self.init(frame: CGRectZero)
        opaque = false
        circleLayer = CAShapeLayer()
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        layer.addSublayer(circleLayer)
        
        clock = CADisplayLink(target: self, selector: "call:")
        clock?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    
    func call(time: CADisplayLink) {
        progress += CGFloat(time.duration)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let lw: CGFloat = 5
        let bOriginal = CGPoint(x: rect.origin.x + lw * 0.5, y: rect.origin.y + lw * 0.5)
        let bSize = CGSize(width: rect.width - lw, height: rect.height - lw)
        let bRect = CGRect(origin: bOriginal, size: bSize)
        let bezier = UIBezierPath(roundedRect: bRect, cornerRadius: bSize.width * 0.5)
        UIColor.lightGrayColor().set()
        bezier.lineWidth = lw
        bezier.stroke()
        
        circleLayer.path = bezier.CGPath
        circleLayer.strokeEnd = progress
        circleLayer.lineWidth = lw * 0.5
        
    }
}




















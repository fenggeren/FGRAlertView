//
//  FGRAutoHideShowController.swift
//  FRComponents
//
//  Created by fenggeren on 15/12/30.
//  Copyright © 2015年 fenggeren. All rights reserved.
//

import UIKit

class FGRAutoHideShowController: UIViewController, UIScrollViewDelegate {

    var topView: UIView!
    var bottomView: UIView!
    var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        let height: CGFloat = 50
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentInset = UIEdgeInsets(top: height-20, left: 0, bottom: height, right: 0)
        scrollView.backgroundColor = UIColor.redColor()
        scrollView.contentOffset = CGPoint(x: 0, y: -height+20)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * 5)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: height))
        topView.backgroundColor = UIColor.blueColor()
        view.addSubview(topView)
        
        bottomView = UIView(frame: CGRect(x: 0, y: view.bounds.height - height, width: view.bounds.width, height: height))
        bottomView.backgroundColor = UIColor.blueColor()
        view.addSubview(bottomView)
        
        lastContentOffsetY = scrollView.contentOffset.y
        addBtns()
    }
    
    // MARK: - UIScrollViewDelegate
    var lastContentOffsetY: CGFloat = 0
    var topCanAnimate = true
    var bottomCanAnimate = true
    func scrollViewDidScroll(scrollView: UIScrollView) {
       showHide()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    func addBtns() {
        for i in 0..<10 {
            let btn = UIButton(type: .Custom)
            btn.setTitle("wosojdfio", forState: .Normal)
            scrollView.addSubview(btn)
            btn.frame = CGRect(x: 100, y: CGFloat(i) * view.bounds.height, width: 200, height: 50)
            btn.backgroundColor = UIColor.greenColor()
        }
    }
    
    
    func showHide() {
        if scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            return
        }
        
        if lastContentOffsetY > scrollView.contentOffset.y{
            if self.topView.frame.origin.y >= 0 && self.topCanAnimate == true {
                self.topCanAnimate = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.topView.frame.origin.y = -self.topView.frame.height
                    }) { complete in
                        self.topCanAnimate = true
                }
            }
            if self.bottomView.frame.origin.y >= view.bounds.height && self.bottomCanAnimate == true {
                self.bottomCanAnimate = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.bottomView.frame.origin.y = self.view.bounds.height - self.bottomView.bounds.height
                    }){ complete in
                        self.bottomCanAnimate = true
                }
            }
        }
        
        if lastContentOffsetY < scrollView.contentOffset.y {
            if self.topView.frame.origin.y < 0 && self.topCanAnimate == true{
                self.topCanAnimate = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.topView.frame.origin.y = 0
                    }){ complete in
                        self.topCanAnimate = true
                }
            }
            if self.bottomView.frame.origin.y < view.bounds.height && self.bottomCanAnimate == true{
                self.bottomCanAnimate = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.bottomView.frame.origin.y = self.view.bounds.height
                    }){ complete in
                        self.bottomCanAnimate = true
                }
            }
        }
        lastContentOffsetY = scrollView.contentOffset.y

    }
}















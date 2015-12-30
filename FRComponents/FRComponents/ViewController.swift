//
//  ViewController.swift
//  FRComponents
//
//  Created by fenggeren on 15/12/24.
//  Copyright © 2015年 fenggeren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purpleColor()
    }
    
    
    @IBAction func goHideShow() {
        navigationController?.pushViewController(FGRAutoHideShowController(), animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}




extension ViewController {
    
    func testAlertView() {
        //        FGRAlertView.showError("失败")
        //        FGRAlertView.showSuccess("成功拉")
        //        FGRAlertView.show(FGRAlertViewType.TextAnnularProgress("卧槽尼玛煞笔"))
        //
        FGRAlertView.show(FGRAlertViewType.TextOnly("发财了")) {
            FGRAlertView.show(FGRAlertViewType.TextIndicator("发财啦")) {
                FGRAlertView.show(FGRAlertViewType.TextImage("Complete", UIImage(named: "37x-Checkmark")!))
            }
        }
    }
    
}

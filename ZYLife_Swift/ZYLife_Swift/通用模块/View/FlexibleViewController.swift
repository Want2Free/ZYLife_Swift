//
//  FlexibleViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/12.
//  Copyright © 2017年 Jason. All rights reserved.

//  伸缩控制器（导航栏透明，用于多tab的页面）

import UIKit

class FlexibleViewController: ClearNavController,TabDragProtocal,UIScrollViewDelegate {

    //伸缩的顶部距离
    var topHeight: CGFloat?
    //透明的bar
    @IBOutlet weak var showView: UIView!
    //标题
    @IBOutlet weak var titleLab: UILabel!
    //顶部约束
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - TabDragProtocal
    
    /// 向上滚动
    func scrollToUp() {
        if self.showView.alpha == 1.0 {
            return
        }
        
        topHeightConstraint.constant = 64
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
            self.showView.alpha = 1.0
            self.titleLab.isHidden = false
        }
    }
    
    /// 向下滚动
    func scrollToDown() {
        if self.showView.alpha == 0 {
            return
        }
        
        topHeightConstraint.constant = self.topHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.showView.alpha = 0
            self.titleLab.isHidden = true
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

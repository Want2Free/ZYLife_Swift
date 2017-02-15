//
//  TabContainViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/10.
//  Copyright © 2017年 Jason. All rights reserved.

//  包含tab选项卡的控制器

import UIKit

class TabContainViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Property
    
    /// 标题数组
    var titles: Array<String>!
    /// 子控制器数组
    var vcs: Array<UIViewController>!
    /// 选项卡下部线
    var tabLineView: UIView!
    /// 开始拖动时的Y值
    var startOffY: CGFloat!
    /// 滚动的代理方法
    var tcDelegate: TabDragProtocal?
    /// 选项卡滚动视图
    var tabScrollView: UIScrollView!
    /// 选中的按钮
    var selectedBtn: UIButton?
    /// 大的滚动视图
    var bigScrollView: UIScrollView!
    /// 选项卡的宽度
    var tabWidth: CGFloat!

    // MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func set(titles: Array<String>, vcs: Array<UIViewController>) {
        self.titles = titles
        self.vcs = vcs
        
        //1.根据标题创建tab
        self.createTabView()
        
        //2.添加子控制器
        self.addSubVCs()
    }
    
    func createTabView() {
        let count = self.titles.count
        let width = kWidth/CGFloat(count)
        tabWidth = (width < 60) ? 60 : width
        let baseTabView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 45)) //1高度的线
        self.view.addSubview(baseTabView)
        
        tabScrollView = UIScrollView.init(frame: .init(x: 0, y: 0, width: kWidth, height: 44))
        tabScrollView.delegate = self
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.contentSize = CGSize.init(width: CGFloat(count)*tabWidth, height: 0)
        baseTabView.addSubview(tabScrollView)
        
        //add btn
        for index in 0..<count {
            let btn = UIButton(type: .custom)
            btn.tag = index+10
            btn.frame = CGRect.init(x: CGFloat(index)*tabWidth, y: 0, width: tabWidth, height: 44)
            btn.setTitle(self.titles[index], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(kNineGrayColor, for: .normal)
            btn.setTitleColor(kNavBarColor, for: .selected)
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: UIControlEvents.touchUpInside)
            tabScrollView.addSubview(btn)
        }
        
        //add line
        self.tabLineView = UIView(frame: CGRect.init(x: 0, y: 44, width: tabWidth, height: 1))
        self.tabLineView.backgroundColor = kNavBarColor
        baseTabView.addSubview(self.tabLineView)
    }
    
    func addSubVCs() {
        let count = self.vcs.count
        self.bigScrollView = UIScrollView(frame: CGRect.init(x: 0, y: 45, width: kWidth, height: self.view.frame.size.height-45))
        bigScrollView.contentSize = CGSize.init(width: kWidth*CGFloat(count), height: 0)
        bigScrollView.delegate = self
        bigScrollView.showsVerticalScrollIndicator = false
        bigScrollView.showsHorizontalScrollIndicator = false
        bigScrollView.autoresizingMask = .flexibleHeight
        bigScrollView.isPagingEnabled = true
        self.view.addSubview(bigScrollView)
        
        for index in 0..<count {
            let vc = self.vcs[index]
            self.addChildViewController(vc)
            var frame = vc.view.frame
            frame.origin.x = CGFloat(index) * kWidth
            vc.view.frame = frame
            
            if vc.view.isKind(of: UIScrollView.classForCoder()) {
                ((vc.view) as? UIScrollView)?.delegate = self
            }
            bigScrollView.addSubview(vc.view)
        }
    }
    
    // MARK: - Target
    
    func btnAction(btn: UIButton) {
        if self.selectedBtn == btn {
            return
        }
        
        let index = btn.tag-10
        self.bigScrollView.contentOffset = CGPoint.init(x: CGFloat(index)*kWidth, y: 0)
        
        var lf = self.tabLineView.frame
        lf.origin.x = CGFloat(index)*tabWidth
        UIView.animate(withDuration: 0.3) {
            self.tabLineView.frame = lf
            
            btn.isSelected = true
            self.selectedBtn?.isSelected = false
            self.selectedBtn = btn
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    //开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 选项卡滚动（超过屏幕时）
        if scrollView == tabScrollView {
            
            return
        }
        
        self.startOffY = scrollView.contentOffset.y
    }
    
    //减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 大的滚动视图
        if scrollView == bigScrollView {
            let index = scrollView.contentOffset.x/kWidth+10
            let btn = tabScrollView.viewWithTag(Int(index))
            self.btnAction(btn: btn as! UIButton)
            return
        }
    }
    
    //停止拖动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 选项卡滚动（超过屏幕时）
        if scrollView == tabScrollView {
            
            return
        }
        
        // 大的滚动视图
        if scrollView == bigScrollView {
            return
        }
        
        let endOffY = scrollView.contentOffset.y
        var disY = endOffY-self.startOffY
        disY = CGFloat(fabsf(Float(disY)))
        
        if endOffY > self.startOffY {
            //往上移动50的距离才操作
            if disY > 50 {
                self.tcDelegate?.scrollToUp()
                print("向上移动了...")
            }
        } else {
            //往下移动50的距离才操作
            if disY > 50 {
                self.tcDelegate?.scrollToDown()
                print("向下移动了...")
            }
        }
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


public protocol TabDragProtocal {
    
    /// 向上滚动
    func scrollToUp()
    
    /// 向下滚动
    func scrollToDown()
    
}

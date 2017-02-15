//
//  MsgBannerView.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/12.
//  Copyright © 2017年 Jason. All rights reserved.

//  消息滚动视图

import UIKit

class MsgBannerView: UIView {
    
    var scrollView: UIScrollView!
    var lab1: UILabel!
    var lab2: UILabel!
    var lab3: UILabel!
    var times: CGFloat = 0.0
    var myH: CGFloat!
    
    var timer: Timer!

    var titles: Array<String>! {
        didSet {
            self.loadTitleData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initSubViews(frame: self.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubViews(frame: frame)
    }
    
    func initSubViews(frame: CGRect) {
        myH = frame.size.height
        
        //喇叭
        let laImg = UIImage.init(named: "banner_head_btn_laba")
        let lbImgView = UIImageView(image: laImg)
        lbImgView.frame = CGRect.init(x: 15, y: (frame.size.height-(laImg?.size.height)!)/2, width: (laImg?.size.width)!, height: (laImg?.size.height)!)
        self.addSubview(lbImgView)
        
        //滚动视图
        scrollView = UIScrollView.init(frame: CGRect.init(x: 25+(laImg?.size.width)!, y: 0, width: frame.size.width-(40+(laImg?.size.width)!), height: frame.size.height))
        scrollView.contentSize = CGSize.init(width: 0, height: CGFloat.greatestFiniteMagnitude)
        self.addSubview(scrollView)
        
        //lab
        let h = frame.size.height
        lab1 = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: scrollView.frame.size.width, height: h))
        lab1.textColor = UIColor.white
        lab1.font = UIFont.systemFont(ofSize: 13)
        scrollView.addSubview(lab1)
        lab2 = UILabel.init(frame: CGRect.init(x: 0, y: h, width: scrollView.frame.size.width, height: h))
        lab2.textColor = UIColor.white
        lab2.font = UIFont.systemFont(ofSize: 13)
        scrollView.addSubview(lab2)
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

//        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func loadTitleData() {
        let count = self.titles.count
        if count == 0 {
            return
        }
        
        if count > 1 {
            //说明需要定时滚动
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(MsgBannerView.scrollAction), userInfo: nil, repeats: true)
            let loop = RunLoop.main
            loop.add(timer, forMode: RunLoopMode.commonModes)
            
            lab1.text = self.titles[0]
            lab2.text = self.titles[1]
        } else {
            lab1.text = self.titles[0]
        }
        
    }
    
    func scrollAction() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: (self.times+1)*self.myH), animated: false)
            
        }, completion: { (bool) in
            self.times += 1
            
            let index = (Int(self.times+1)) % self.titles.count
            let str = self.titles[index]
            if (Int(self.times+1) % 2) != 0 {
                var f2 = self.lab2.frame
                f2.origin.y = (self.times+1)*self.myH
                self.lab2.frame = f2
                self.lab2.text = str
                
//                print("index = \(index) -- lab2")
            } else {
                var f1 = self.lab1.frame
                f1.origin.y = (self.times+1)*self.myH
                self.lab1.frame = f1
                self.lab1.text = str
                
//                print("index = \(index) -- lab1")
            }
        })
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

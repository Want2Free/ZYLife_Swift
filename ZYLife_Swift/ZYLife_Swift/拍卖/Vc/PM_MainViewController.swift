//
//  PM_MainViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/11.
//  Copyright © 2017年 Jason. All rights reserved.

//  拍卖首页

import UIKit

class PM_MainViewController: FlexibleViewController {
    
    @IBOutlet weak var bannerView: MsgBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topHeight = 172
        
        var vcs = Array<UIViewController>()
        for _ in 0..<5 {
            let vc = UITableViewController.init()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/CGFloat(255), green: CGFloat(arc4random_uniform(255))/CGFloat(255), blue: CGFloat(arc4random_uniform(255))/CGFloat(255), alpha: 1)
            vcs.append(vc)
        }
        
        let tcVc = self.childViewControllers.first as? TabContainViewController
        tcVc?.tcDelegate = self
        tcVc?.set(titles: ["title1","title2","title3","title4","title5"], vcs: vcs)
        
        self.bannerView.titles = ["那么有一种情况，是自定义指001"]
        //,"那么有一种情况，是自定义指002","那么有一种情况，是自定义指003","那么有一种情况，是自定义指004","那么有一种情况，是自定义指005","那么有一种情况，是自定义指006"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

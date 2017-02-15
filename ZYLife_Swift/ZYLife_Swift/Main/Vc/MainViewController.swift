//
//  MainViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/27.
//  Copyright © 2016年 Jason. All rights reserved.

//  首页

import UIKit

class MainViewController: ClearNavController {

    // MARK: - Property
    //导航栏，自定义
    @IBOutlet weak var myNavBar: UINavigationBar!
    //消息item
    @IBOutlet weak var msgItem: BBBadgeBarButtonItem!
    //金币数量
    @IBOutlet weak var coinBtn: UIButton!
    //红包
    @IBOutlet weak var redBagBtn: UIButton!
    //标题
    @IBOutlet weak var titleItem: UINavigationItem!
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        //导航栏透明
        self.myNavBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        //如果有缓存小区
        if UserDefaults.sharedInstance().communityName != nil {
            self.titleItem.title = UserDefaults.sharedInstance().communityName
        } else {
            //小区列表
            self.getCommunityList()
        }
        
        //加载用户信息
        self.loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        UITextField.appearance().tintColor = UIColor.whiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        UITextField.appearance().tintColor = kNavBarColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    func loadUserInfo() {
        
        Main_Service.sharedInstance.getUserInfo(success: { (userInfo) in
            
        }) { (str) in
            
        }
    }
    
    func getCommunityList() {
        
        Main_Service.sharedInstance.getCommunityList(success: { (ary) in
            
            let communityModel = (ary as! NSArray).firstObject as! CommunityModel
            //关注
            Main_Service.sharedInstance.attentionCommunity(commId: MyLong(communityModel.communityId!), success: { (obj) in
                //缓存
                UserDefaults.sharedInstance().communityId = Int64(communityModel.communityId!)
                UserDefaults.sharedInstance().communityName = communityModel.communityName
                
                self.titleItem.title = communityModel.communityName
                }, fail: { (str) in
                    
            })
        }) { (str) in
                
        }
    }
    
    // MARK: - Target
    //侧边栏
    @IBAction func sideAction() {
        let tabbarVc = self.tabBarController as? ViewController
        tabbarVc?.sideAction()
    }
    
    //消息中心
    @IBAction func toMsgAction() {
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

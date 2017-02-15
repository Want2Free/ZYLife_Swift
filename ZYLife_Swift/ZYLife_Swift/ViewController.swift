//
//  ViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit

class ViewController: UITabBarController,ICSDrawerControllerChild,ICSDrawerControllerPresenting {

    weak var drawer: ICSDrawerController?
    
    //是否打开
    var isOpen = false
    
    // MARK: - Life
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //init
    self.initSubVc()

    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

    // MARK: - ICSDrawerControllerPresenting
    func drawerControllerDidOpen(drawerController: ICSDrawerController!) {
        isOpen = true
    }
    
    func drawerControllerDidClose(drawerController: ICSDrawerController!) {
        isOpen = false
    }

    // MARK: - Private
    func sideAction() {
        if isOpen {
            self.drawer?.close()
            isOpen = false
        } else {
            self.drawer?.open()
            isOpen = true
        }
    }
    
    func initSubVc() {
        
        let mainVc = UIStoryboard.init(name: "ZY_Main", bundle: nil).instantiateInitialViewController()
        let scVc = UIStoryboard.init(name: "SC_Main", bundle: nil).instantiateInitialViewController()
        let sqVc = UIStoryboard.init(name: "SQ_Main", bundle: nil).instantiateInitialViewController()
        
        self.viewControllers = [mainVc!, scVc!, sqVc!]
        
        let mainItem = UITabBarItem.init(title: "首页", image: UIImage(named: "index_btn_home_normal"), selectedImage: UIImage(named: "index_btn_home_hover"))
        mainVc?.tabBarItem = mainItem
        
        let scItem = UITabBarItem.init(title: "社区", image: UIImage(named: "index_btn_sheq_normal"), selectedImage: UIImage(named: "index_btn_sheq_hover"))
        scVc?.tabBarItem = scItem
        
        let sqItem = UITabBarItem.init(title: "生活圈", image: UIImage(named: "index_btn_shengh_normal"), selectedImage: UIImage(named: "index_btn_shengh_hover"))
        sqVc?.tabBarItem = sqItem
        
        self.tabBar.tintColor = kNavBarColor
    }
}


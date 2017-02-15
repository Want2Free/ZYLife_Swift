//
//  AppDelegate.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func configSV() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 100, height: 100))
    }
    
    func configNav() {
        //全局导航栏
        UINavigationBar.appearance().setBackgroundImage(Common.shareCommon.imageWithPureColor(color: kNavBarColor, size: CGSize(width: kWidth, height: 64)), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white]
    }
    
    //跳转到首页
    func toMainPage(fromVc: UIViewController?) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        let side = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideViewController")
        let isc = ICSDrawerController.init(leftViewController: side, center: vc)
        
        if fromVc != nil {
            //加动画
            UIView.transition(from: (fromVc?.view)!, to: (isc?.view)!, duration: 1.0, options: UIViewAnimationOptions.transitionCrossDissolve, completion: { (finished) in
                self.window?.rootViewController = isc
            })
        } else {
            window?.rootViewController = isc
        }
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
            window = UIWindow.init(frame: UIScreen.main.bounds)
        
        //监听网络状态
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        //SV配置
        self.configSV()
        
        //配置导航栏
        self.configNav()
        
        //状态栏样式
        application.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
//        UITextField.appearance().tintColor = kNavBarColor
        
        if UserDefaults.sharedInstance().accessToken != nil {
            //refersh token //已登录
            if Main_Service.sharedInstance.refreshToken() {
                
                self.toMainPage(fromVc: nil)
            } else {
                //fail to login
                window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            }
        } else {
            //未登录
            window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }


  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}


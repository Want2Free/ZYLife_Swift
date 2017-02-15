//
//  Main_Service.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/19.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJExtension

let kGetVerifyCodeURL = "\(kServerURL)/personal/user/validateCode"
let kRegisterURL = "\(kServerURL)/personal/user/add"
let kModifyPwdURL = "\(kServerURL)/personal/user/password/modify"
let kGetUserInfoURL = "\(kServerURL)/personal/me"
let kGetCommunityListURL = "\(kServerURL)/estate/communitys"

class Main_Service: NSObject {

    // MARK: - 单例
    static let sharedInstance = Main_Service()
    private override init() {}
    
    // MARK: - 方法
    
    /// 获取验证码
    ///
    /// - parameter phone:   手机号
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func getVerifyCode(phone: String, success: @escaping AnyBlock, fail: @escaping StringBlock) {
        NetworkHelper.nh_requestNotShow(type: RequestType.GET, URLString: kGetVerifyCodeURL, parameters: ["mobile":phone,"userType":1] as AnyObject?, successBlock: { (dict) in

            if dict["code"]?.integerValue == 1 {
                //成功
                success(dict["msg"] as! String as AnyObject)
            } else {
                fail(dict["msg"] as! String)
            }
            }) { (str) in
                fail("获取失败")
        }
    }
    
    /// 注册
    ///
    /// - parameter phone:   手机号
    /// - parameter password:   密码
    /// - parameter code:    验证码
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func register(phone: String, password: String, code: String, success: @escaping AnyBlock, fail: @escaping StringBlock) {
        NetworkHelper.nh_request(type: RequestType.POST, URLString: kRegisterURL, parameters: ["mobile":phone,"password":password,"validateCode":code] as AnyObject?, successText: "注册成功", failText: "注册失败", successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                //成功
                success(dict["data"]!)
            } else {
                fail(dict["msg"] as! String)
            }
        }) { (str) in
            fail("注册失败")
            
        }
    }
    
    /// 修改密码
    ///
    /// - parameter phone:   手机号
    /// - parameter password:   密码
    /// - parameter code:    验证码
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func modifyPwd(phone: String, password: String, code: String, success: @escaping AnyBlock, fail: @escaping StringBlock) {
        let params = ["mobile":phone,"newPassword":password,"validateCode":code,"userType":NSNumber.init(value: 1)] as [String : Any]
        
        NetworkHelper.nh_request(type: .POST, URLString: kModifyPwdURL, parameters: params as AnyObject?, successText: "修改成功\n请使用新密码重新登录", failText: "修改失败", successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                //成功
                success(dict["data"]!)
            } else {
                fail(dict["msg"] as! String)
            }
        }) { (str) in
            fail("修改失败")
        }
    }
    
    /// 登录
    ///
    /// - parameter phone:   手机号
    /// - parameter password:   密码
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func login(phone: String, password: String, success: AnyBlock, fail: StringBlock) {
        
        SVProgressHUD.show(withStatus: "正在登录...")
        
        let sso = SSOHelper.init(ssoUrl: kSSOServerUrl)
        let result = sso?.login(phone, withPassword: password)
        if (result?.success)! {
            SVProgressHUD.dismiss()
            success(result!.identity as AnyObject)
        } else {
            SVProgressHUD.showError(withStatus: result?.errorMessage)
        }
    }
    
    /// 刷新token
    ///
    /// - returns: 是否成功刷新
    func refreshToken() -> Bool {
        
        let sso = SSOHelper.init(ssoUrl: kSSOServerUrl)
        
        return sso!.refreshAccessToken(nil)
    }
    
    /// 获取用户信息
    ///
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func getUserInfo(success: @escaping AnyBlock, fail: @escaping StringBlock) {
        
        NetworkHelper.nh_requestNotShow(type: .GET, URLString: kGetUserInfoURL, parameters: nil, successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                
                let user = UserInfoModel.mj_object(withKeyValues: dict["data"])
                ShareData.sharedInstance.userInfo = user
                success(user!)
            } else {
                fail((dict["msg"])! as! String)
            }
            }) { (str) in
                fail(str)
        }
    }
    
    /// 获取小区列表
    ///
    /// - parameter success: 成功
    /// - parameter fail:    失败
    func getCommunityList(success: @escaping AnyBlock, fail: @escaping StringBlock) {
        
        NetworkHelper.nh_requestNotShow(type: .GET, URLString: kGetCommunityListURL, parameters: nil, successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                
                let list = dict["data"] as? NSDictionary
                let data = list!["list"] as? NSArray
                
                let ary = CommunityModel.mj_objectArray(withKeyValuesArray: data as! [Any]!)
                success(ary!)
            } else {
                fail((dict["msg"])! as! String)
            }
        }) { (str) in
            fail(str)
        }
    }
    
    func attentionCommunity(commId: MyLong, success: @escaping AnyBlock, fail: @escaping StringBlock) {
        
        NetworkHelper.nh_requestNotShow(type: .PUT, URLString: "\(kServerURL)/estate/community/\(commId)/concern", parameters: nil, successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                print("关注小区成功")
                
                success("" as AnyObject)
            } else {
                print("关注小区失败")
                fail("关注小区失败")
            }
            }) { (str) in
                print("关注小区失败")
                fail("关注小区失败")
        }
    }
}

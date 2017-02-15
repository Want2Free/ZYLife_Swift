//
//  NetworkHelper.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/12.
//  Copyright © 2016年 Jason. All rights reserved.

//  网络请求帮助类

import UIKit
import AFNetworking
import SVProgressHUD

let timeOut : Double = 30

enum RequestType : Int {
    case GET = 1
    case POST
    case PUT
    case PATCH
}

class NetworkHelper: NSObject {
    // MARK: - 单例
    static let sharedInstance = NetworkHelper()
    private override init() {}
    
    // MARK: - 请求方法
    
    /// 检查是否显示成功文本
    ///
    /// - parameter dict:  数据字典
    /// - parameter sText: 成功文本
    /// - parameter fText: 失败文本
    class func showSuccessText(dict: Dictionary<String, AnyObject>, sText: String?, fText: String?) {
        if dict["code"]?.integerValue == 1 {
            //成功
            if let str = sText {
                SVProgressHUD.showSuccess(withStatus: str)
            }
        } else {
            if let str = fText {
                SVProgressHUD.showError(withStatus: str)
            }
        }
    }
    
    /// 网络请求（带loading）
    ///
    /// - parameter type:         请求类型
    /// - parameter URLString:    请求URL
    /// - parameter parameters:   请求参数
    /// - parameter successBlock: 成功回调
    /// - parameter failBlock:    失败回调
    class func nh_request(type: RequestType, URLString: String, parameters:AnyObject?, successBlock: @escaping DictBlock, failBlock: @escaping StringBlock) -> Void {
        
        self.nh_request(type: type, URLString: URLString, parameters: parameters, successText: nil, failText: nil, successBlock: successBlock, failBlock: failBlock)
    }
    
    /// 网络请求（带loading+成功文本或失败文本）
    ///
    /// - parameter type:         请求类型
    /// - parameter URLString:    请求URL
    /// - parameter parameters:   请求参数
    /// - parameter successText:  成功文本
    /// - parameter failText:     失败文本
    /// - parameter successBlock: 成功回调
    /// - parameter failBlock:    失败回调
    class func nh_request(type: RequestType, URLString : String, parameters:AnyObject?, successText: String?, failText: String?, successBlock: @escaping DictBlock, failBlock: @escaping StringBlock) -> Void {
        
        //检测是否有网络
        if !self.checkNetworkIsReached() {
            SVProgressHUD.show(withStatus: "网络不可用，请稍候再试！")
            failBlock("网络不可用")
            return
        }
        
        //show
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "加载中...")
        
        let manager = self.manager()
        switch type {
        case .GET:
            manager.get(URLString, parameters: parameters, progress: { (progress) in
                //进度条
                
                }, success: { (task, responseObject) in
                    
                    let dict = responseObject as! Dictionary<String, AnyObject>
                    if successText != nil {
                        self.showSuccessText(dict: dict, sText: successText, fText: failText)
                        Common.shareCommon.executePlanAfterTimes(time: 2, done: {
                            successBlock(dict)
                        })
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    
                    print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    if let text = failText {
                        SVProgressHUD.showError(withStatus: text)
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .POST:
            manager.post(URLString, parameters: parameters, progress: { (progress) in
                //进度条
                
                }, success: { (task, responseObject) in
                    
                    let dict = responseObject as! Dictionary<String, AnyObject>
                    if successText != nil {
                        self.showSuccessText(dict: dict, sText: successText, fText: failText)
                        Common.shareCommon.executePlanAfterTimes(time: 2, done: {
                            successBlock(dict)
                        })
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    
                    print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    if let text = failText {
                        SVProgressHUD.showError(withStatus: text)
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .PATCH:
            manager.patch(URLString, parameters: parameters, success: { (task, responseObject) in
                
                let dict = responseObject as! Dictionary<String, AnyObject>
                if successText != nil {
                    self.showSuccessText(dict: dict, sText: successText, fText: failText)
                    Common.shareCommon.executePlanAfterTimes(time: 2, done: { 
                        successBlock(dict)
                    })
                } else {
                    SVProgressHUD.dismiss()
                }
                
                print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    if let text = failText {
                        SVProgressHUD.showError(withStatus: text)
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .PUT:
            manager.put(URLString, parameters: parameters, success: { (task, responseObject) in
                
                let dict = responseObject as! Dictionary<String, AnyObject>
                if successText != nil {
                    self.showSuccessText(dict: dict, sText: successText, fText: failText)
                    Common.shareCommon.executePlanAfterTimes(time: 2, done: {
                        successBlock(dict)
                    })
                } else {
                    SVProgressHUD.dismiss()
                }
                
                print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    if let text = failText {
                        SVProgressHUD.showError(withStatus: text)
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        }
    }
    
    
    /// 不带loading的请求
    ///
    /// - parameter type:         请求类型
    /// - parameter URLString:    请求URL
    /// - parameter parameters:   请求参数
    /// - parameter successBlock: 成功
    /// - parameter failBlock:    失败
    class func nh_requestNotShow(type: RequestType, URLString : String, parameters:AnyObject?, successBlock: @escaping DictBlock, failBlock: @escaping StringBlock) -> Void {
        //检测是否有网络
        if !self.checkNetworkIsReached() {
            failBlock("网络不可用")
            return
        }
        
        let manager = self.manager()
        switch type {
        case .GET:
            manager.get(URLString, parameters: parameters, progress: { (progress) in
                //进度条
                
                }, success: { (task, responseObject) in
                    //成功
                    successBlock(responseObject as! Dictionary<String, AnyObject>)
                    
                    print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .POST:
            manager.post(URLString, parameters: parameters, progress: { (progress) in
                //进度条
                
                }, success: { (task, responseObject) in
                    //成功
                    successBlock(responseObject as! Dictionary<String, AnyObject>)
                    
                    print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .PATCH:
            manager.patch(URLString, parameters: parameters, success: { (task, responseObject) in
                //成功
                successBlock(responseObject as! Dictionary<String, AnyObject>)
                
                print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        case .PUT:
            manager.put(URLString, parameters: parameters, success: { (task, responseObject) in
                //成功
                successBlock(responseObject as! Dictionary<String, AnyObject>)
                
                print("responseObject: \(responseObject!)")
                }, failure: { (task, error) in
                    //失败
                    failBlock(error.localizedDescription)
                    
                    print("error: \(error)")
            })
            break
            
        }
    }
    
    /// 上传图片到服务器
    ///
    /// - parameter URLString:    上传URL
    /// - parameter parameters:   请求参数
    /// - parameter data:         上传的图片数据
    /// - parameter fileName:     上传到服务器的图片名
    /// - parameter successBlock: 成功回调
    /// - parameter failBlock:    失败回调
    class func nh_uploadImg(URLString: String, parameters: AnyObject?, data: NSData, fileName: String, successBlock: @escaping AnyBlock, failBlock: @escaping StringBlock) {
        
        self.manager().post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
                formData.appendPart(withFileData: data as Data, name: "file", fileName: fileName, mimeType: "image/png,image/jpeg")
            }, progress: nil, success: { (task, responseObject) in
                successBlock(responseObject as AnyObject)
            }) { (task, error) in
                failBlock(error.localizedDescription)
        }
        
    }
    
    // MARK: - 辅助方法
    
    /// 获取请求Manager
    ///
    /// - returns: 返回配置好的Manager
    class func manager() -> AFHTTPSessionManager {
        
        let m = AFHTTPSessionManager()
        m.responseSerializer.acceptableContentTypes = ["application/json","text/html","text/javascript","text/json","text/plain"]
        let responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments)
        m.responseSerializer = responseSerializer
        
        let Authorization = UserDefaults.sharedInstance().accessToken
        if Authorization != nil {
            m.requestSerializer.setValue("Bearer\(Authorization!)", forHTTPHeaderField: "Authorization")
        }
        
        let cid = UserDefaults.sharedInstance().communityId
        if cid != 0 {
            m.requestSerializer.setValue("\(cid)", forHTTPHeaderField: "communityId")
        }
        
        m.requestSerializer.timeoutInterval = timeOut
        
        return m
    }
    
    
    /// 检测网络是否可用
    ///
    /// - returns: 是否可用
    class func checkNetworkIsReached() -> Bool {
        return AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0
    }
}

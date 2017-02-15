//
//  PM_Service.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJExtension

let kGetTypeListURL = "\(kServerURL)/community/auction/types"
let kGetItemListURL = "\(kServerURL)/community/auctions"

class PM_Service: NSObject {

    // MARK: - 单例
    static let sharedInstance = PM_Service()
    private override init() {}
    
    /// 获取拍卖分类列表
    ///
    /// - Parameters:
    ///   - success: 成功
    ///   - fail: 失败
    func getTypeList(success: @escaping AnyBlock, fail: @escaping StringBlock) {
        
        NetworkHelper.nh_requestNotShow(type: .GET, URLString: kGetTypeListURL, parameters: nil, successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                let types = PM_TypeModel.mj_objectArray(withKeyValuesArray: dict["data"]?["list"]!)
                success(types!)
            } else {
                fail(dict["msg"] as! String)
            }
        }) { (str) in
            fail(str)
        }
    }
    
    func getPMItemList(typeId: NSNumber, lastId: Int64, success: @escaping AnyBlock, fail: @escaping StringBlock) {
        var params = ["typeId" : typeId]
        if lastId > 0 {
            params["lastId"] = lastId as NSNumber?
        }
        
        NetworkHelper.nh_requestNotShow(type: .GET, URLString: kGetItemListURL, parameters: params as AnyObject?, successBlock: { (dict) in
            
            if dict["code"]?.integerValue == 1 {
                let items = PM_ItemModel.mj_objectArray(withKeyValuesArray: dict["data"]?["list"]!)
                success(items!)
            } else {
                fail(dict["msg"] as! String)
            }
        }) { (str) in
            fail(str)
        }
    }
    
}

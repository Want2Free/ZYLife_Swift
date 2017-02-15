//
//  ShareData.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/29.
//  Copyright © 2016年 Jason. All rights reserved.

//  共享数据

import UIKit

class ShareData: NSObject {
    // MARK: - 单例
    static let sharedInstance = ShareData()
    private override init() {}
    
    //用户信息
    var userInfo: UserInfoModel?
    
    //拍卖分类
    var pmTypes: Array<PM_TypeModel>?
    
}

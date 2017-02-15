//
//  PM_ItemModel.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/17.
//  Copyright © 2017年 Jason. All rights reserved.

//  拍卖信息模型

import UIKit

class PM_ItemModel: NSObject {

    /* 主键 */
    var auctionId: NSNumber?
    
    /* 分类ID */
    var typeId: NSNumber?
    
    /* 分类名称 */
    var typeName: String?
    
    /* 卖家ID */
    var sellerId: NSNumber?
    
    /* 卖家名称 */
    var sellerName: String?
    
    /* 卖家电话 */
    var sellerMobile: String?
    
    /* 商品名称 */
    var lotName: String?
    
    /* 商品描述 */
    var lotNote: String?
    
    /* 起拍价 */
    var startPrice: NSNumber?
    
    /* 成交价 */
    var finalPrice: NSNumber?
    
    /* 赞数 */
    var goods: NSNumber?
    
    /* 踩数 */
    var bads: NSNumber?
    
    /* 是否已赞{"0":"否","1":"是"} */
    var isGood: NSNumber?
    
    /* 是否已踩 */
    var isBad: NSNumber?
    
    /* 状态 0-进行中，1-已成交，2-流拍*/
    var status: NSNumber?
    
    /* 成交人ID */
    var bidderId: NSNumber?
    
    /* 成交人名称 */
    var bidderName: String?
    
    /* 成交人电话 */
    var bidderMobile: String?
    
    /* 结束时间 */
    var endTime: NSNumber?
    
    /* 发布时间 */
    var createTime: NSNumber?
    
    /* 修改时间 */
    var updateTime: NSNumber?
    
    /* 图片路径数组<PM_File> */
    var files: Array<PM_File>?
    
    /* 出手记录数组<PM_BidLogs> */
    var bidLogs: Array<PM_BidLogs>?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["files" : "PM_File", "bidLogs" : "PM_BidLogs"]
    }
}

class PM_File: NSObject {
    
    /* 大图路径 */
    var url: String?
    
    /* 缩略图路径 */
    var thumbnailUrl: String?
}

class PM_BidLogs: NSObject {
    
    /* 出手人ID */
    var bidderId: NSNumber?
    
    /* 出手人名称 */
    var bidderName: String?
    
    /* 出手人电话 */
    var bidderMobile: String?
    
    /* 出手价格 */
    var price: NSNumber?
    
    /* 捎的消息 */
    var msg: String?
    
    /* 出手时间 */
    var createTime: NSNumber?
    
    /* 出手次数 */
    var bidIndex: NSNumber?
    
    /* 出手时间-格式化(新增) */
    var createTimeStr: String?
    
    /* 是否头部(新增) */
    var isHead: Bool?
}

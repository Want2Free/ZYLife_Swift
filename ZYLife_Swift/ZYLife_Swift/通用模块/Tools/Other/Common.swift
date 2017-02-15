//
//  Common.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit
import RKDropdownAlert

//公共闭包定义
//如果闭包的没有返回值，那么我们还可以这样写，
typealias VoidBlock = () -> Void
//为接受一个Int类型的参数不返回任何值的闭包类型
typealias IntBlock = (Int) -> ()
//为接受一个Double类型的参数不返回任何值的闭包类型
typealias DoubleBlock = (Double) -> ()
//为接受一个String类型的参数不返回任何值的闭包类型
typealias StringBlock = (String) -> ()
//为接受一个AnyObject类型的参数不返回任何值的闭包类型
typealias AnyBlock = (AnyObject) -> ()
//为接受一个Dictionary类型的参数不返回任何值的闭包类型
typealias DictBlock = (Dictionary<String, AnyObject>) -> ()

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height

//列表数量
let kCount = 10

//色值
let kLineColor = UIColor.hexColor(hexStr: "dbdbdb")
let kNavBarColor = UIColor.hexColor(hexStr: "ffc000")
let kThreeGrayColor = UIColor.hexColor(hexStr: "333333")
let kSixGrayColor = UIColor.hexColor(hexStr: "666666")
let kNineGrayColor = UIColor.hexColor(hexStr: "999999")

//参数
let kServerURL = "http://114.67.22.247:8082"//"http://10.201.76.96:8082"
let kSocketHost = "114.67.22.247"//"10.201.76.101"
let kSocketPort = 8888
let kSSOServerUrl = "\(kServerURL)/sso"
let kUploadImgURL = "\(kServerURL)/file/fileupload/image/upload"

class Common: NSObject {
    // MARK: - 单例
    static let shareCommon = Common()
    private override init() {}
    
    // MARK: - Class Method
    
    /// 16进制字符串转Int
    ///
    /// - parameter numStr: 16进制字符串
    ///
    /// - returns: 转换后的Int值
    class func changeHexStrToInt(numStr:String) -> Int {
        
        let str = numStr.uppercased()
        var sum = 0
        for i in str.utf8 {
            //0-9 从48开始
            sum = sum * 16 + Int(i) - 48
            if i >= 65 {
                //A~Z 从65开始，但初始值为10
                sum -= 7
            }
        }
        return sum
    }
    
    class func showAlert(msg: String) {
        RKDropdownAlert.title("提示", message: msg, time: 2)
    }
    
    // MARK: - Instance Method
    
    /// 多少秒后再执行
    ///
    /// - parameter time: 时间
    /// - parameter done: 回调block
    func executePlanAfterTimes(time:UInt64, done: @escaping VoidBlock) {
        
        let popTime = DispatchTime.init(uptimeNanoseconds: time) //DispatchTime.now(dispatch_time_t(DispatchTime.now()), time)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            done()
        }
        
    }
    
    /// 生成一张指定尺寸的纯色图片
    ///
    /// - parameter pureColor: 图片颜色
    /// - parameter size:      尺寸
    ///
    /// - returns: 生成好的纯色图片
    func imageWithPureColor(color pureColor: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(pureColor.cgColor);
        context!.fill(rect);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img!
    }
    
    
    
}

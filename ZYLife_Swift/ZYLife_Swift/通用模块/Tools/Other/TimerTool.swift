//
//  TimerTool.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/23.
//  Copyright © 2016年 Jason. All rights reserved.

//  倒计时工具

import UIKit

let kDaojishiNotification = "DaojishiNotification"

//Timer状态
enum TimerStatus {
    case Starting
    case Pause
    case Invalid
}

class TimerTool: NSObject {

    // MARK: - 单例
    static let sharedInstance = TimerTool()
    private override init() {}
    
    var status: TimerStatus = TimerStatus.Invalid
    
    var timer: Timer {
        get {
        let myTimer = Timer.init(fireAt: NSDate.distantFuture, interval: 1, target: self, selector: #selector(TimerTool.postNotification), userInfo: nil, repeats: true)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.commonModes)
        
        return myTimer
        }
        
        set {
            //self.timer = newValue
        }
    }
    
    func postNotification() {
        //每隔一秒推送消息
        NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: kDaojishiNotification), object: nil) as Notification)
    }
    
    func startTimer() {
        if status == .Invalid {
            
            self.timer.fireDate = NSDate.distantPast
            timer.fire()
            status = .Starting
        }
        
    }
    
    func pauseTimer() {
        if status == .Starting {
            timer.fireDate = NSDate.distantFuture
            status = .Pause
        }
    }
    
    func invalidTimer() {
        timer.invalidate()
        status = .Invalid
    }
}

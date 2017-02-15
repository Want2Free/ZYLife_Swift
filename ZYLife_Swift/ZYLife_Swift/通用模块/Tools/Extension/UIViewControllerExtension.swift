//
//  UIControllerViewExtension.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/17.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation

extension UIViewController {
    /*
    open override static func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = NSSelectorFromString("viewDidLoad")
            let swizzledSelector = NSSelectorFromString("myViewDidLoad")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    // MARK: - Method Swizzling
    func myViewDidLoad(pan: UIPanGestureRecognizer) {
        //添加返回按钮
        /*
         if (self.navigationController.viewControllers.firstObject != self)
         {
         [[CommonMethod sharedCommonMethod] setCustomBackItemWith:self nav:self.navigationController];
         }
         */
        
        myViewDidLoad(pan: pan)
    }
 */
}

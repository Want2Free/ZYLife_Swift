//
//  StringExtension.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/19.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation

extension String {
    
    
    /// 移除空格
    ///
    /// - returns: 移除空格后的String
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// 移除空格和回车符
    ///
    /// - returns: 移除空格和回车符的String
    func removeWhiteSpaceAndEnter() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
}

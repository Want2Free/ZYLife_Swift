//
//  UIColorExtension.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func hexColor(hexStr: String) -> UIColor {
        
        var cString = hexStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.lengthOfBytes(using: String.Encoding.utf8) < 6 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("0X") || cString.hasPrefix("0x") {
            let start = cString.index(cString.startIndex, offsetBy: 1)
            let range = start..<cString.endIndex
            cString = cString[range]
        }
        if cString.hasPrefix("#") {
            // range
            let range = cString.index(after: cString.startIndex)..<cString.endIndex
            cString = cString[range]
        }
        if cString.lengthOfBytes(using: String.Encoding.utf8) != 6 {
            return UIColor.clear
        }
        
        var range = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        //r
        let rStr = cString[range]
        
        range = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        //g
        let gStr = cString[range]
        
        range = cString.index(cString.startIndex, offsetBy: 4)..<cString.endIndex
        //b
        let bStr = cString[range]
        
//        UIColor(colorLiteralRed: Float(self.changeToInt2(rStr))/255.0, green: Float(22)/255.0, blue: Float(22)/255.0, alpha: 1.0)
        
        return UIColor(colorLiteralRed: Float(Common.changeHexStrToInt(numStr: rStr)) / 255.0, green: Float(Common.changeHexStrToInt(numStr: gStr)) / 255.0, blue: Float(Common.changeHexStrToInt(numStr: bStr)) / 255.0, alpha: 1.0)
    }
    
    
}

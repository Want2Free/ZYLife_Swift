//
//  LineView.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/14.
//  Copyright © 2016年 Jason. All rights reserved.

//  0.5的分隔线

import UIKit

class LineView: UIView {

    override func draw(_ rect: CGRect) {
        self.drawLine(rect: rect)
    }
    
    func drawLine(rect: CGRect) {
        // Drawing code
        //1.获取上下文
        let context = UIGraphicsGetCurrentContext();
        //2.设置当前上下问路径
        //设置起始点
        context?.move(to: CGPoint.init(x: 0, y: 0))
        //增加点
        context?.addLine(to: CGPoint.init(x: rect.size.width, y: 0))
        //关闭路径
        context!.closePath();
        
        context!.setLineWidth(0.5);
    
        //3.设置属性
        kLineColor.setStroke()
        
        //4.绘制路径
        context!.drawPath(using: CGPathDrawingMode.stroke);
    }
 

}

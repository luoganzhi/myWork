//
//  UIUtil.swift
//  loanhigh
//
//  Created by 胡佳 on 15/7/28.
//  Copyright (c) 2015年 hujia. All rights reserved.
//

import Foundation
import UIKit

class UIUtil {
    class func colorFromARGB(_ value: Int32) -> UIColor {
        let alpha = CGFloat(((0xff << 24) & value) >> 24) * 1.0 / 255.0
        let red = CGFloat(((0xff << 16) & value) >> 16) * 1.0 / 255.0
        let green = CGFloat(((0xff << 8) & value) >> 8) * 1.0 / 255.0
        let blue = CGFloat(0xff & value) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func colorFromRGB(_ value: Int32) -> UIColor {
        let red = CGFloat(((0xff << 16) & value) >> 16) * 1.0 / 255.0
        let green = CGFloat(((0xff << 8) & value) >> 8) * 1.0 / 255.0
        let blue = CGFloat(0xff & value) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func colorFromRGB(_ value: Int32, withAlpha alpha: CGFloat) -> UIColor {
        let red = CGFloat(((0xff << 16) & value) >> 16) * 1.0 / 255.0
        let green = CGFloat(((0xff << 8) & value) >> 8) * 1.0 / 255.0
        let blue = CGFloat(0xff & value) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func topViewOf(_ view: UIView) -> UIView {
        var result = view
        while (result.superview != nil) {
            result = result.superview!
        }
        return result
    }
}

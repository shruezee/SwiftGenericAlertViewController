//
//  Utils.swift
//  GenericPopovers
//
//  Created by Shruthi on 15/09/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation

import UIKit

//Generic Popover Utils Begin
/**
 UIColor extensions
 */
extension UIColor {
    
    /**
     A convenience method to create a UIColor from a hex value
     - Parameters:
     - hex: The hexadecimal value prefixed with an 0x
     - alpha: (Optional) The transparency of the color
     - Returns: a UIColor object that can be used in the code
     */
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red     = CGFloat((hex & 0xFF0000)  >> 16) / 255.0
        let green   = CGFloat((hex & 0xFF00)    >> 8)  / 255.0
        let blue    = CGFloat((hex & 0xFF))            / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /**
     Returns a lighter color by the provided percentage
     
     - Parameters:
     - percent: lighting percent percentage
     - Returns: lighter UIColor
     */
    func lighterColor( percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     - parameters:
     - percent: darking percent percentage
     - returns: darker UIColor
     */
    func darkerColor( percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     - parameters:
     - factor: brightness factor
     - returns: modified color
     */
    func colorWithBrightnessFactor( factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}

/**
 Themecolor structure to be used 
 */
struct ThemeColour {
    var primaryColour       = UIColor(hex: 0x2C2C37)
    var secondaryColour     = UIColor(hex: 0x434353)
    var greenColour         = UIColor(hex: 0x82B548)
    var blueColour          = UIColor(hex: 0x546DE9)
    var redColour           = UIColor(hex: 0xA93639)
    var greyColour          = UIColor(hex: 0x525E60)
    var primaryTextColour   = UIColor(hex: 0xFFFFFF)
    var selectedTextColour  = UIColor(hex: 0x000000)
    var secondaryTextColor: UIColor {
        return primaryTextColour.darkerColor(percent: 0.3)
    }
    var lightOfGrey: UIColor {
        return greyColour.darkerColor(percent: 0.3)
    }
}

//MARK:- UILabel extension to apply theme
extension UILabel {
    func applyTheme( params:[String:AnyObject]) {
        if let _backgroundColor = params["backgroundColor"] as? UIColor {
            self.backgroundColor = _backgroundColor
        }
        
        if let _textColor = params["textColor"] as? UIColor {
            self.textColor = _textColor
        }
        
        if let _font = params["font"] as? UIFont {
            self.font = _font
        }
        
        if let _textAlignment = params["textAlignment"] as? Int {
            if let _alignment = NSTextAlignment(rawValue: _textAlignment) {
                self.textAlignment = _alignment
            }
        }
        
        if let _textColor = params["textColor"] as? UIColor {
            self.textColor = _textColor
        }
    }
}

//MARK:- button extension to apply theme
extension UIButton {
    func applyTheme( params:[String:AnyObject]) {
        
        if let _cornerRadius = params[" tCornerRadius"] as? CGFloat {
            self.layer.cornerRadius = _cornerRadius
        }
        
        if let _backgroundColor = params["backgroundColor"] as? UIColor {
            self.backgroundColor = _backgroundColor
        }
        
        if let _textColor = params["textColor"] as? UIColor {
            self.setTitleColor(_textColor, for: UIControl.State())
        }
        
        if let _font = params["font"] as? UIFont {
            self.titleLabel?.font = _font
        }
        
        if let _textForTitle = params["titleText"] as? String {
            self.setTitle(_textForTitle, for: UIControl.State())
        }
        
        if let _bgImage = params["bgImage"] as? UIImage {
            self.setBackgroundImage(_bgImage, for: UIControl.State())
        }
        
    }
}
//Generic Popover Utils End

//MARK:- PopOver Constants
enum UIDimensionConstant {
    static let tDimColor: UIColor = UIColor.black
    static let tCornerRadius: CGFloat = 12.0
}

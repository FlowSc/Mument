//
//  FontExtension.swift
//  Mument
//
//  Created by Seongchan Kang on 05/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func montserratBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    static func montserratRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    static func montserratExtraLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraLight", size: size)!
    }
    
    static func montserratMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }
    
    static func montserratSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    static func montserratLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }

    static func notoSansReg(_ size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: size)!
    }
    
    static func notoSansMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: size)!
    }
    
}

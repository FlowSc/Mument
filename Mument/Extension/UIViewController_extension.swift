//
//  UIViewController_extension.swift
//  WallPeckers
//
//  Created by Seongchan Kang on 30/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

extension UIViewController {
    
    func setStatusbarColor(_ color:UIColor) {
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
        
        
    }
    

    
    
    func allButtonUserIteraction(_ bool:Bool) {
        
        let btns = self.view.subviews.filter({
            
            $0 is UIButton
        }) as? [UIButton]
        
    
       _ = btns?.map({
        
        $0.isUserInteractionEnabled = bool
        
       })
        
        
        
        
    }


}

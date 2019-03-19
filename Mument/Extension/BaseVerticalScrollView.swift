//
//  BaseScrollView.swift
//  iOSboilerplate
//
//  Created by Seongchan Kang on 26/11/2018.
//  Copyright © 2018 KimJimin and Company. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseVerticalScrollView:UIView {
    
    private let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScrollView(vc:UIViewController) {
        
        vc.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()

        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        scrollView.delegate = vc as? UIScrollViewDelegate

    }
    
}

class BaseHorizontalScrollView:UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScrollView(vc:UIViewController) {
        
        vc.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(vc.view.safeArea.bottom)
            make.centerY.leading.trailing.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.centerY.leading.trailing.equalToSuperview()
        }
        scrollView.isPagingEnabled = true
//        scrollView.isUserInteractionEnabled = true
//        scrollView.isScrollEnabled = true
        scrollView.delegate = vc as? UIScrollViewDelegate
        
    }
    
    func setScrollViewMiddle(vc:UIViewController) {
        vc.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            
            
            
            make.height.equalTo(UIWindow().bounds.height > 800 ? 300 : 230)
            make.centerY.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(UIWindow().bounds.height > 800 ? 300 : 230)
            make.centerY.leading.trailing.equalToSuperview()
        }
        scrollView.isPagingEnabled = true
        //        scrollView.isUserInteractionEnabled = true
        //        scrollView.isScrollEnabled = true
        scrollView.delegate = vc as? UIScrollViewDelegate
    }
    
}

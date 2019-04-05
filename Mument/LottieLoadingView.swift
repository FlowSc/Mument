//
//  LottiLoadingView.swift
//  Mument
//
//  Created by Seongchan Kang on 05/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import Lottie


class LottieLoadingView:UIView {
    
    private let baseView = UIView()
    private let loadingView = LOTAnimationView.init(name: "398-snap-loader-white")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    private func setUI() {
        
        self.addSubview(baseView)
        
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        baseView.addSubview(loadingView)
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        loadingView.loopAnimation = true
        
    }
    
    fileprivate func loadingStatus(_ bool:Bool) {
        
        if bool {
            loadingView.play()
        }else{
            loadingView.stop()
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct LoadingIndicator {
    
    private static let loadingView = LottieLoadingView()
    
    static func start(vc:UIViewController, sender:UIButton? = nil) {
        
        vc.view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadingView.loadingStatus(true)
        
        if let _button = sender {
            _button.isUserInteractionEnabled = false
        }
        
    }
    
    static func stop(sender:UIButton? = nil) {
        
        if let _button = sender {
            _button.isUserInteractionEnabled = true
        }
        
        loadingView.loadingStatus(false)
        loadingView.removeFromSuperview()
        
    }
    
}

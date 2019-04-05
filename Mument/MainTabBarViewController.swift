//
//  MainTabBarViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import SnapKit

class MainTabBarViewController: UITabBarController {
    
    let bottomView = UIView()
    let searchBtn = UIButton()
    let mainBtn = UIButton()
    let configBtn = UIButton()
    let mainVc = MainViewController()
    let calendarVc = CalendarViewController()
    let configVc = ConfigViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setViewControllers()
        
    }
    
    private func setViewControllers() {
        
        let ncvc = UINavigationController.init(rootViewController: calendarVc)
        let nmvc = UINavigationController.init(rootViewController: mainVc)
        let nconvc = UINavigationController.init(rootViewController: configVc)
        
        self.viewControllers = [ncvc, nmvc, nconvc]
        self.selectedIndex = 1
        
    }
    
    private func setUI() {
        self.tabBar.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let btns = [searchBtn, mainBtn, configBtn]
        
        bottomView.addSubview(btns)
       
        for i in 0...btns.count - 1 {
            
            let btn = btns[i]
            
            btn.tag = i
            btn.addTarget(self, action: #selector(setAction(sender:)), for: .touchUpInside)
            btn.setImageEdge()
            
        }
        
        mainBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        searchBtn.snp.makeConstraints { (make) in
            
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(mainBtn.snp.leading)
            make.width.equalTo(mainBtn.snp.width)
        }

        configBtn.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(mainBtn.snp.trailing)
            make.width.equalTo(searchBtn.snp.width)
        }
        
        searchBtn.setImage(UIImage.init(named: "calendar")?.imageWithColor(color1: .gray), for: .normal)
        mainBtn.setImage(UIImage.init(named: "bookmark")?.imageWithColor(color1: .gray), for: .normal)
        configBtn.setImage(UIImage.init(named: "menu")?.imageWithColor(color1: .gray), for: .normal)
        
        searchBtn.setImage(UIImage.init(named: "calendar")?.imageWithColor(color1: .black), for: .selected)
        mainBtn.setImage(UIImage.init(named: "bookmark")?.imageWithColor(color1: .black), for: .selected)
        configBtn.setImage(UIImage.init(named: "menu")?.imageWithColor(color1: .black), for: .selected)
    }
    
    @objc func setAction(sender:UIButton) {
        
        _ = [searchBtn, mainBtn, configBtn].map({$0.isSelected = false})
        
        sender.isSelected = !(sender.isSelected)
        self.selectedIndex = sender.tag
    }
}


extension UIButton {
    func setImageEdge() {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 40, bottom: 30, right: 40)
    }
}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

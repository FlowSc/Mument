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
            
        }
        
        
        searchBtn.setImage(UIImage.init(named: "calendar"), for: .normal)
        mainBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        searchBtn.snp.makeConstraints { (make) in
            
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(mainBtn.snp.leading)
            make.width.equalTo(mainBtn.snp.width)
        }
        
        mainBtn.setImage(UIImage.init(named: "bookmark"), for: .normal)
        configBtn.setImage(UIImage.init(named: "menu"), for: .normal)
//        mainBtn.setBackgroundColor(color: .white, forState: .normal)
        
        configBtn.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(mainBtn.snp.trailing)
            make.width.equalTo(searchBtn.snp.width)
        }
    }
    
    @objc func setAction(sender:UIButton) {
        self.selectedIndex = sender.tag
    }
}

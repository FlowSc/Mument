//
//  ConfigViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = .backgroundBrown
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

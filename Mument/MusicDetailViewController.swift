//
//  MusicDetailViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 26/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController {
    
    let tableView = UITableView()
    var songs:[Song]?
    let backButton = UIButton()
    let titleLb = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.view.addSubview([tableView, backButton, titleLb])
        self.view.backgroundColor = .white

        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.leading.equalTo(view.safeArea.leading).offset(10)
            make.width.height.equalTo(50)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        
        titleLb.text = "TITLE"
        titleLb.textAlignment = .center
        
        backButton.backgroundColor = .red
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        backButton.addTarget(self, action: #selector(backBtnTouched(sender:)), for: .touchUpInside)
    }
    
    func setData(_ songs:[Song]) {
        
        self.songs = songs
        self.tableView.reloadData()
    
    }
    
    @objc func backBtnTouched(sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension MusicDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    
    
}

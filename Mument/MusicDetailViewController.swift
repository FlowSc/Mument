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
    var songs:[Song]? {
        didSet {
            print("Song allocated!")
        }
    }
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
            make.width.height.equalTo(30)
        }
        backButton.setImage(UIImage.init(named: "left-arrow-1"), for: .normal)
        
        titleLb.font = UIFont.notoMedium(18)

        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        
        titleLb.textAlignment = .center
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
        backButton.addTarget(self, action: #selector(backBtnTouched(sender:)), for: .touchUpInside)
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell

        if let songs = songs {
            cell.setData(songs[indexPath.row])
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let songs = songs {
            
            let selected = songs[indexPath.row]
            
            print(selected.url)
            
            NotificationCenter.default.post(name: NSNotification.Name.init("setSelectedSong"), object: nil, userInfo: ["selected":selected])
            

            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
}

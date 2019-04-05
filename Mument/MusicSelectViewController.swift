//
//  MusicSelectViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 25/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import StoreKit
import Kingfisher

class MusicSelectViewController: UIViewController {
    
    let dismissBtn = UIButton()
    let searchBar = UISearchBar()
    let titleLb = UILabel()
    var collectionView:UICollectionView!
    var recentedPlaylists:[Playlist]? {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       setUI()
        
        LoadingIndicator.start(vc: self)
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            if let _token = UserDefaults.standard.string(forKey: "MusicToken") {
                API.getRecentPlayed(userToken: _token) { (result) in
                    self.recentedPlaylists = result
                    LoadingIndicator.stop()
                }
            }else{
                LoadingIndicator.stop()
                appleMusicCheck()
            }
            
        }else{
            LoadingIndicator.stop()
            appleMusicCheck()
        }
    }
    

    
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: view.frame.width / 2.2, height: view.frame.width / 2.2)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        
        self.view.addSubview([dismissBtn, searchBar, collectionView, titleLb])
        

        dismissBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.leading.equalTo(10)
            make.width.height.equalTo(50)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissBtn.snp.centerY)
        }
        
        titleLb.text = "최근 재생한 음악들"
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        searchBar.barTintColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        dismissBtn.backgroundColor = .red
        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    @objc func dismissTouched(sender:UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func appleMusicCheck() {
        
        if let _token = UserDefaults.standard.string(forKey: "MusicToken") {
            API.getRecentPlayed(userToken: _token, completion: { (result) in
                self.recentedPlaylists = result
            })
        }
    }
    
}

extension MusicSelectViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentedPlaylists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
        
        
        if let playlist = recentedPlaylists {
            cell.setData(playList: playlist[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let playlist = recentedPlaylists {
            
            LoadingIndicator.start(vc: self)
            
            print(playlist[indexPath.row].type, "TYPE")
            
            API.getMusicsFromPlaylist(userToken: UserDefaults.standard.string(forKey: "MusicToken")!, storefront: "kr", type: playlist[indexPath.row].type, id: playlist[indexPath.row].playId) { (result) in
                
                let mvc = MusicDetailViewController()
                
                
                if let _songs = result {
                    mvc.setData(_songs)
                    LoadingIndicator.stop()
                    self.navigationController?.pushViewController(mvc, animated: true)
                }else{
                    LoadingIndicator.stop()
                    print("No result")
                }
               
            }
        }
        

        
    }
    
}

final class PlaylistCollectionViewCell:UICollectionViewCell {
    
    private let thumnailImv = UIImageView()
    private let titleLb = UILabel()
    private let nameLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([thumnailImv, titleLb, nameLb])
        

        self.nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.thumnailImv.contentMode = .scaleToFill
        
        
        self.titleLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLb.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview()
        }
        
        self.thumnailImv.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.titleLb.snp.top).offset(-10)
        }
        self.setBorder(color: UIColor.black.withAlphaComponent(0.3), width: 0.3, cornerRadius: 5)
//        self.dropShadow(color: UIColor.black, offSet: CGSize.init(width: 0.1, height: 0.1))
        
    }
    
    func setData(playList:Playlist) {
        
        self.thumnailImv.kf.setImage(with: URL.init(string: playList.thumnailUrl)!)
        
        if playList.curatorName == "" {
            self.nameLb.text = playList.artistName

        }else{
            self.nameLb.text = playList.curatorName

        }
        self.titleLb.text = playList.name
//        self.thumnailImv.
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

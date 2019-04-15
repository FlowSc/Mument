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
import MediaPlayer

class MusicSelectViewController: UIViewController {
    
    let dismissBtn = UIButton()
    let searchBar = UISearchBar()
    let titleLb = UILabel()
    var collectionView:UICollectionView!
    var recentedPlaylists:[MPMediaItemCollection] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    let localMedia = MPMediaQuery.playlists()

    override func viewDidLoad() {
        super.viewDidLoad()
       setUI()
        
        LoadingIndicator.start(vc: self)
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            if let _token = UserDefaults.standard.string(forKey: "MusicToken") {

                _ = localMedia.collections?.map({
                    print($0)
                    self.recentedPlaylists.append($0)
                    
                })

                    LoadingIndicator.stop()


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

        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissBtn.snp.centerY)
        }
        
        dismissBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLb)
            make.leading.equalTo(10)
            make.width.height.equalTo(30)
        }
        
        titleLb.font = UIFont.notoMedium(18)
        titleLb.text = "나의 음악들"
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        searchBar.isHidden  = true
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        searchBar.barTintColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        dismissBtn.setImage(UIImage.init(named: "left-arrow-1"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissTouched(sender:)), for: .touchUpInside)

    }
    
    @objc func dismissTouched(sender:UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func appleMusicCheck() {
        
        if let _token = UserDefaults.standard.string(forKey: "MusicToken") {
            
            _ = localMedia.collections?.map({
                self.recentedPlaylists.append($0)
            })
//            API.getRecentPlayed(userToken: _token, offset: 10, completion: { (result) in
//                self.recentedPlaylists = result
//            })
        }
    }
    
}

extension MusicSelectViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentedPlaylists.count
    }
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
        
         let playlist = recentedPlaylists
            
            cell.setData(playList: playlist[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let playlist = recentedPlaylists[indexPath.row]
        
        var songs:[Song] = []
//            LoadingIndicator.start(vc: self)
        
//        print(playlist[indexPath.row].items)
        
        _ = playlist.items.map({
//            print($0.title)
//            print($0.value(forProperty: MPMediaItemPropertyAssetURL))
//            print($0.assetURL) // 이게 nil 값이면 애플뮤직으로 들은 노래고 값이 있으면 다운받아서 가지고 있는 노래임!
//            print($0.isCloudItem)
//            print($0.lastPlayedDate)
//            print($0.playbackStoreID) // 이게 0이 아니면 애플뮤직으로 들었던 노래들이고 assetURL이 존재함!
//            print("~~~~~~~~")
            let song = Song.init(item: $0)
            
            songs.append(song)
            
            
        })
        
        let mvc = MusicDetailViewController()
        
        mvc.setData(songs)
        
        self.navigationController?.pushViewController(mvc, animated: true)
        
        
        

        
//            print(playlist[indexPath.row].type, "TYPE")
            
//            API.getMusicsFromPlaylist(userToken: UserDefaults.standard.string(forKey: "MusicToken")!, storefront: "kr", type: playlist[indexPath.row].type, id: playlist[indexPath.row].playId) { (result) in
//
//
//                mvc.titleLb.text = playlist[indexPath.row].name
//
//                if let _songs = result { // apple Music 으로
//                    mvc.setData(_songs)
//                    LoadingIndicator.stop()
//                    self.navigationController?.pushViewController(mvc, animated: true)
//                }else{ // 얘네는 라이브러리에서 불러오는 애들임
//
//
//
//                    LoadingIndicator.stop()
//                    print("No result")
//                }
//
//            }
        

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
        self.nameLb.font = UIFont.notoMedium(12)
        self.titleLb.font = UIFont.notoMedium(14)
        

        self.nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-10)
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
        
    }
    
    func setData(playList:MPMediaItemCollection) {
        
        self.thumnailImv.image = playList.representativeItem?.artwork?.image(at: CGSize.init(width: 100, height: 100))
//        self.thumnailImv.kf.setImage(with: URL.init(string: playList.thumnailUrl)!)
        
//        if playList.curatorName == "" {
//            self.nameLb.text = playList.value(forProperty: MPMediaPlaylistPropertyName)!
//
//        }else{
//            self.nameLb.text = playList.curatorName
//
//        }
        self.titleLb.text = playList.value(forProperty: MPMediaPlaylistPropertyName) as! String
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

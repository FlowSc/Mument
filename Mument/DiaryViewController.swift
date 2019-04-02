//
//  diaryViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 21/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import MediaPlayer
import RealmSwift
import Realm

let realm = try! Realm()

class DiaryViewController: UIViewController {
    
    
    let appMusicPlayer = MPMusicPlayerController.applicationMusicPlayer
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var selectedSong:Song? {
        didSet {
            if let _selected = selectedSong {
                appleMusicPlayId(_selected.id)
                musicPlayerView.setMusicPlayer(song: _selected)
            }
        }
    }
    var selectedDateText:String = ""
    let verticalScrollView = BaseVerticalScrollView()
    var isEditable:Bool = false
    let dateLb = UILabel()
    let addBtn = UIButton()
    let diaryTv = UITextView()
    let musicPlayerView = MusicPlayerView()
    let backBtn = UIButton()
    let keyboardResigner = UITapGestureRecognizer()
    var dateId:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAction()
        setNotifications()
    }
    

    private func appleMusicPlayId(_ id:String) {
        
        appMusicPlayer.setQueue(with: [id])
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardBegin(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardResign(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedSong(noti:)), name: NSNotification.Name.init("setSelectedSong"), object: nil)
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(verticalScrollView)
        
        self.navigationController?.isNavigationBarHidden = true
        verticalScrollView.setScrollView(vc: self)

        verticalScrollView.contentView.addSubview([dateLb, addBtn, diaryTv, musicPlayerView, backBtn])
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.leading.equalTo(10)
            make.width.height.equalTo(50)
        }
        backBtn.backgroundColor = .red
        dateLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.centerX.equalToSuperview()
        }
        musicPlayerView.addGestureRecognizer(keyboardResigner)
        keyboardResigner.addTarget(self, action: #selector(keyboardResignTouched))
        musicPlayerView.delegate = self
        
        diaryTv.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(40)
            make.height.equalTo(UIWindow().frame.size.height / 2.5)
        }
        
        musicPlayerView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryTv.snp.bottom).offset(20)
            make.leading.equalTo(10)
            make.height.equalTo(200)
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.top.equalTo(50)
            make.width.height.equalTo(50)
        }
        addBtn.backgroundColor = .blue
        
        musicPlayerView.setBorder(color: .black, width: 0.5, cornerRadius: 3)

        diaryTv.setBorder(color: .black, width: 0.5, cornerRadius: 3)
        dateLb.text = dateId
        dateLb.textColor = .black
    }
    
    @objc func keyboardResignTouched() {
        self.diaryTv.resignFirstResponder()
    }
    
    private func setAction() {
        
        backBtn.addTarget(self, action: #selector(tapBackBtn(sender:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(tapAddBtn(sender:)), for: .touchUpInside)
    
    }

    @objc func tapBackBtn(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapAddBtn(sender:UIButton) {
        
        guard let _selectedSong = selectedSong else {return}
        
        let diary = Diary.init()
        diary.contents = diaryTv.text
        diary.song = _selectedSong
        diary.id = "DDGGG"
        
        try!realm.write {
            realm.add(diary)
        }
        
    }
    
    @objc func keyboardResign(noti:Notification) {
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 100
            }
        }
    }
    
    @objc func keyboardBegin(noti:Notification) {
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
    }
    
    @objc func setSelectedSong(noti:Notification) {
        if let selected = noti.userInfo?["selected"] as? Song {
            self.selectedSong = selected
        }
    }

}

extension DiaryViewController:MusicPlayerViewDelegate {
    func play(isSelected: Bool) {
        print(isSelected)
        
        if isSelected {
            appMusicPlayer.play()
        }else{
           appMusicPlayer.pause()
        }
    }
    

    
    func addMusic() {
        print("AddMusic")
        let msvc = MusicSelectViewController()
        
        let selectedVc = UINavigationController.init(rootViewController: msvc)
        
            self.present(selectedVc, animated: true, completion: nil)
    
    }
    

}

class MusicPlayerView:UIView {
    
    private let firstAddBtn = UIButton()
    private let firstAddInfoLb = UILabel()
    
    private let thumnailImv = UIImageView()
    private let playBtn = UIButton()
    private let pauseBtn = UIButton()
    private let repeatModeBtn = UIButton()
    private let titleLb = UILabel()
    private let artistLb = UILabel()
    
    var isFirstAdd:Bool = true
    var delegate:MusicPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
//        if isFirstAdd {
        self.addSubview([firstAddBtn, firstAddInfoLb])
        
        firstAddBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        firstAddBtn.addTarget(self, action: #selector(addMusicTouched(sender:)), for: .touchUpInside)
        firstAddBtn.backgroundColor = .black
        
    }
    
    func setMusicPlayer(song:Song) {
        
        firstAddBtn.removeFromSuperview()
        firstAddInfoLb.removeFromSuperview()
        
        self.addSubview([thumnailImv, playBtn])
        
        thumnailImv.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.height.equalTo(120)
        }
        
        thumnailImv.setBorder(color: .clear, width: 1, cornerRadius: 3)
        
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumnailImv.snp.bottom).offset(10)
            make.width.height.equalTo(50)
        }
        
        playBtn.addTarget(self, action: #selector(playMusic(sender:)), for: .touchUpInside)
        
        playBtn.backgroundColor = .black
        
        thumnailImv.kf.setImage(with: URL.init(string: song.artworkUrl))

        
    }
    
    @objc func addMusicTouched(sender:UIButton) {
        delegate?.addMusic()
    }
    @objc func playMusic(sender:UIButton) {
        sender.isSelected = !(sender.isSelected)
        delegate?.play(isSelected: sender.isSelected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol MusicPlayerViewDelegate {
    
    func addMusic()
    func play(isSelected:Bool)
  
    
}

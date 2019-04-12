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
import Lottie
import AVKit

let realm = try! Realm()

class DiaryViewController: UIViewController {
    
    let musicPicker = MPMediaPickerController.init(mediaTypes: .anyAudio)
    
    let appMusicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var avPlayer:AVPlayer?
    
    var selectedSong:Song? {
        didSet {
            if let _selected = selectedSong {
                
                
                    appleMusicPlayId(_selected.id)
                    musicPlayerView.setMusicPlayer(song: _selected)

            
            
            }
        }
    }
    
    var diary:Diary?
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
        musicPicker.delegate = self
        setAction()
        setNotifications()
    }
    
    func setWrittenInfo(diary:Diary) {
        
        self.diaryTv.text = diary.contents
        self.selectedSong = diary.song
        self.diary = diary
        
    }
    
    
    private func appleMusicPlayId(_ id:String) {
        
        if id != "0" {
            appMusicPlayer.setQueue(with: [id])

        }else{
            
            if let _selected = selectedSong {
                let playItem = AVPlayerItem.init(url: URL.init(string: _selected.url)!)
                
                avPlayer = AVPlayer.init(playerItem: playItem)

            }
        }
    }
    private func localPusicPlay(song:Song) {
//        systemMusicPlayer
//        appMusicPlayer
//        systemMusicPlayer.setQueue(with: song.localItem!)
    
//        appMusicPlayer.setQueue(with: song.localItem.)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(selectedSong)
    }
    
    private func setNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardBegin(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardResign(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedSong(noti:)), name: NSNotification.Name.init("setSelectedSong"), object: nil)
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .backgroundBrown
        self.view.addSubview(verticalScrollView)
        
        self.navigationController?.isNavigationBarHidden = true
        verticalScrollView.setScrollView(vc: self)
        
        verticalScrollView.contentView.addSubview([dateLb, addBtn, diaryTv, musicPlayerView, backBtn])
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.leading.equalTo(10)
            make.width.height.equalTo(30)
        }
        backBtn.setImage(UIImage.init(named: "left-arrow-1"), for: .normal)
        dateLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.centerX.equalToSuperview()
        }
        musicPlayerView.addGestureRecognizer(keyboardResigner)
        keyboardResigner.addTarget(self, action: #selector(keyboardResignTouched))
        musicPlayerView.delegate = self
        
        dateLb.font = UIFont.notoMedium(18)
                
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 7
        spacing.alignment = .left
        diaryTv.typingAttributes = [NSAttributedString.Key.paragraphStyle:spacing, NSAttributedString.Key.font : UIFont.notoMedium(13)]
        
        diaryTv.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(40)
            make.height.equalTo(UIWindow().frame.size.height / 2.5)
        }
        
        musicPlayerView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryTv.snp.bottom).offset(20)
            make.leading.equalTo(10)
            make.height.equalTo(150)
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.top.equalTo(50)
            make.width.height.equalTo(30)
        }
        addBtn.setImage(UIImage.init(named: "edit"), for: .normal)
        diaryTv.backgroundColor = .backgroundBrown
//
        musicPlayerView.shadow()
//
        diaryTv.shadow()

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
        
        guard let _selectedSong = selectedSong else {
            
            let alertVc = UIAlertController.init(title: "잠깐만요!", message: "오늘의 음악을 선택해주세요!", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
            
            alertVc.addAction(cancelAction)
            
            
            self.present(alertVc, animated: true, completion: nil)
            
            return
        }
        LoadingIndicator.start(vc: self, sender: sender)
        
        
        if let _diary = diary {

            try! realm.write {
                _diary.contents = diaryTv.text
                _diary.song = _selectedSong
                _diary.id = dateId
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }else{
            
            let diary = Diary.init()
            
            diary.contents = diaryTv.text
            diary.song = _selectedSong
            diary.id = dateId
            
            try!realm.write {
                realm.add(diary)
                LoadingIndicator.stop(sender: sender)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func keyboardResign(noti:Notification) {
        if let _ = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 100
            }
        }
    }
    
    @objc func keyboardBegin(noti:Notification) {
        if let _ = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer = nil
        appMusicPlayer.stop()
    }
    
}

extension DiaryViewController:MusicPlayerViewDelegate {
    func play(isSelected: Bool) {
        
        if isSelected {
            
        
            if let selected = selectedSong {
                
                if selected.id != "0" {
                    appMusicPlayer.play()
                }else{
                    avPlayer?.play()
                }
            }
            
        }else{
            if let selected = selectedSong {
                
                if selected.id != "0" {
                    appMusicPlayer.stop()
                }else{
                    avPlayer?.pause()
                }
            }
        }
    }
    
    func addMusic() {
        
        self.present(musicPicker, animated: true, completion: nil)

    }
}

extension DiaryViewController:MPMediaPickerControllerDelegate {
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print(mediaItemCollection)
        
        if let media = mediaItemCollection.items.first {
            
            
            print(media.hasProtectedAsset)
            
            if let assetUrl = media.assetURL {
                let song = Song.init(item: mediaItemCollection.items.first!)
                
                print(assetUrl)
                selectedSong = song
                
                mediaPicker.dismiss(animated: true, completion: nil)

            }else{
                
            }
            

        }
        

        

        
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
    private let musicAnimView = LOTAnimationView.init(name: "2671-sound-visualizer")
    
    var isFirstAdd:Bool = true
    var delegate:MusicPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([firstAddBtn, firstAddInfoLb])
        self.backgroundColor = .backgroundBrown
    
        firstAddBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        firstAddBtn.addTarget(self, action: #selector(addMusicTouched(sender:)), for: .touchUpInside)
        firstAddBtn.setImage(UIImage.init(named: "add"), for: .normal)
        self.layoutIfNeeded()
        self.layoutSubviews()
        
    }
    
    func setMusicPlayer(song:Song) {
        
        firstAddBtn.removeFromSuperview()
        firstAddInfoLb.removeFromSuperview()
        
        self.addSubview([thumnailImv, playBtn, titleLb, artistLb, firstAddBtn, musicAnimView])
        
        thumnailImv.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(10)
            make.width.height.equalTo(80)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(thumnailImv.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
//            make.height.equalTo(20)
        }
        
        titleLb.numberOfLines = 0
        artistLb.numberOfLines = 0
        
        artistLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.leading.equalTo(titleLb.snp.leading)
            make.trailing.equalTo(-10)
        }
        
        thumnailImv.setBorder(color: .clear, width: 1, cornerRadius: 3)
        
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumnailImv.snp.bottom).offset(10)
            make.width.height.equalTo(40)
        }
        
        musicAnimView.snp.makeConstraints { (make) in
            make.centerX.equalTo(thumnailImv)
            make.width.height.equalTo(30)
            make.centerY.equalTo(playBtn)
        }
//        musicAnimView.f
        
        
        firstAddBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-20)
            make.width.height.equalTo(40)
        }
        
        
        firstAddBtn.setImage(UIImage.init(named: "add"), for: .normal)
        
        musicAnimView.loopAnimation = true
        
        firstAddBtn.addTarget(self, action: #selector(addMusicTouched(sender:)), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(playMusic(sender:)), for: .touchUpInside)
        playBtn.setImage(UIImage.init(named: "play-button"), for: .normal)
        playBtn.setImage(UIImage.init(named: "pause"), for: .selected)
        
        
        thumnailImv.kf.setImage(with: URL.init(string: song.artworkUrl))
        
        titleLb.font = UIFont.notoMedium(15)
        titleLb.text = song.title
        artistLb.font = UIFont.notoMedium(12)
        artistLb.text = song.artistName
//        titleLb.
//        titleLb.setNotoText(song.title, size: 12, textAlignment: .left)
//        titleLb.text = song.title
//        artistLb.setNotoText(song.artistName, size: 12, textAlignment: .left)
        
        
    }
    
    @objc func addMusicTouched(sender:UIButton) {
        delegate?.addMusic()
    }
    @objc func playMusic(sender:UIButton) {
        sender.isSelected = !(sender.isSelected)
        delegate?.play(isSelected: sender.isSelected)
        
        if sender.isSelected {
            musicAnimView.play()
        }else{
            musicAnimView.pause()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol MusicPlayerViewDelegate {
    
    func addMusic()
    func play(isSelected:Bool)
    
    
}

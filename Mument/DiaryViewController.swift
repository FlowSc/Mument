//
//  diaryViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 21/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
    
    var selectedDateText:String = ""
    let verticalScrollView = BaseVerticalScrollView()
    var isEditable:Bool = false
    let dateLb = UILabel()
    let addBtn = UIButton()
    let diaryTv = UITextView()
    let musicPlayerView = MusicPlayerView()
    let backBtn = UIButton()
    let keyboardResigner = UITapGestureRecognizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAction()
        setNotifications()
    }
    
    func setNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardBegin(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardResign(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        dateLb.text = "HI"
        dateLb.textColor = .black
    }
    
    @objc func keyboardResignTouched() {
//        self.view.resignFirstResponder()
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
        print("ADD")
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

}

extension DiaryViewController:MusicPlayerViewDelegate {
    func addMusic() {
        print("AddMusic")
        let msvc = MusicSelectViewController()
        let selectedVc = UINavigationController.init(rootViewController: msvc)
        
        self.present(selectedVc, animated: true, completion: nil)
    }
    
    func play() {
        print("PlayMusic")
    }
    
    func pause() {
        print("PauseMusic")
    }
    
    func repeatModeSelect() {
        print("ChangeMusicMode")
    }
    

}

class MusicPlayerView:UIView {
    
    let firstAddBtn = UIButton()
    let firstAddInfoLb = UILabel()
    
    let thumnailImv = UIImageView()
    let playBtn = UIButton()
    let pauseBtn = UIButton()
    let repeatModeBtn = UIButton()
    
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
    
    @objc func addMusicTouched(sender:UIButton) {
        delegate?.addMusic()
    }
    @objc func playMusic(sender:UIButton) {
        delegate?.play()
    }
    @objc func pauseMusic(sender:UIButton) {
        delegate?.pause()
    }
    @objc func selectRepeatMode(sender:UIButton) {
        delegate?.repeatModeSelect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol MusicPlayerViewDelegate {
    
    func addMusic()
    func play()
    func pause()
    func repeatModeSelect()
    
}

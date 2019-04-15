//
//  WelcomeViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 04/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import StoreKit
import Lottie

class WelcomeViewController: UIViewController {
    
    private let mainImgView = UIImageView()
    private let signInBtn = UIButton()
    private let sloganLb = UILabel()
    private let alertVc = UIAlertController.init(title: "현재 애플뮤직 접근 설정에 동의하지 않았습니다", message: "설정에서 접근 동의를 해주세요", preferredStyle: UIAlertController.Style.alert)
    private let copyRightLb = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview([signInBtn, mainImgView, sloganLb, copyRightLb])
        
        self.view.backgroundColor = .backgroundBrown
    
        mainImgView.image = UIImage.init(named: "logo_transparent")
        
        mainImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        mainImgView.contentMode = .scaleAspectFit
        
        sloganLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImgView.snp.bottom).offset(-10)
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.top.equalTo(sloganLb.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        sloganLb.textAlignment = .center
        sloganLb.font = UIFont.AmericanTypeWriter(.regular, size: 20)
        
        signInBtn.backgroundColor = .backgroundBrown
//        signInBtn.setBorder(color: .black, width: 0.1, cornerRadius: 3)
        signInBtn.shadow()
        
        sloganLb.text = "slogan".localized
        sloganLb.numberOfLines = 1
        sloganLb.adjustsFontSizeToFitWidth = true
        signInBtn.setTitle("start".localized, for: .normal)
        signInBtn.titleLabel?.font = UIFont.AmericanTypeWriter(.bold, size: 25)
        signInBtn.setTitleColor(.black, for: .normal)
        
        copyRightLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        copyRightLb.adjustsFontSizeToFitWidth = true
        copyRightLb.textAlignment = .center
        
        copyRightLb.text = "Copyright 2019. Seongchan Kang. All right reserved"
                
        signInBtn.addTarget(self, action: #selector(moveToMain(sender:)), for: .touchUpInside)
        copyRightLb.font = UIFont.AmericanTypeWriter(.regular, size: 15)

        let alertAction = UIAlertAction.init(title: "move".localized, style: UIAlertAction.Style.default) { (action) in
                    if UIApplication.shared.canOpenURL(URL.init(string:  UIApplication.openSettingsURLString)!) {
                        UIApplication.shared.openURL(URL.init(string:  UIApplication.openSettingsURLString)!)
                    }
        }
        let cancelAction = UIAlertAction.init(title: "cancel".localized, style: .cancel, handler: nil)
        alertVc.addAction(alertAction)
        alertVc.addAction(cancelAction)
        
    }
    
    @objc func moveToMain(sender:UIButton) {
        
        LoadingIndicator.start(vc: self, sender: sender)

        let vc = MainTabBarViewController()
        
        let serviceCon = SKCloudServiceController()
        
        SKCloudServiceController.requestAuthorization { (auth) in
            
            if auth == .authorized {
                
                serviceCon.requestUserToken(forDeveloperToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkEzUUxZRFhRWTYifQ.eyJpYXQiOjE1NTI5NzM1MTEsImV4cCI6MTU2ODUyNTUxMSwiaXNzIjoiUzM2SlZHRjM3OCJ9.ctz7UBkr7mvrP0TrW9VuHuA10oPvwMIQGlMtjjv_Hs9JYw8yGMxWPNDvyEQSrREj3Vqv33Qx6Ykx-0QOegqCVA") { (token, err) in
                    
                    UserDefaults.standard.set(token, forKey: "MusicToken")
                    
                    if let _ = token {
                        LoadingIndicator.stop(sender: sender)
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        DispatchQueue.main.async {
                            LoadingIndicator.stop(sender: sender)
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    LoadingIndicator.stop(sender: sender)
                    self.present(self.alertVc, animated: true, completion: nil)
                }
            }
        }
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

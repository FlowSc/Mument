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
    let alertVc = UIAlertController.init(title: "현재 애플뮤직 접근 설정에 동의하지 않았습니다", message: "설정에서 접근 동의를 해주세요", preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview([signInBtn])
        
        self.view.backgroundColor = .backgroundBrown
    
        
        signInBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }

        signInBtn.setTitle("시작하기", for: .normal)
        signInBtn.titleLabel?.font = UIFont.notoMedium(20)
        signInBtn.setTitleColor(.black, for: .normal)
                
        signInBtn.addTarget(self, action: #selector(moveToMain(sender:)), for: .touchUpInside)
        
        let alertAction = UIAlertAction.init(title: "이동", style: UIAlertAction.Style.default) { (action) in
                    if UIApplication.shared.canOpenURL(URL.init(string:  UIApplication.openSettingsURLString)!) {
                        UIApplication.shared.openURL(URL.init(string:  UIApplication.openSettingsURLString)!)
                    }
        }
        let cancelAction = UIAlertAction.init(title: "취소", style: .cancel, handler: nil)
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

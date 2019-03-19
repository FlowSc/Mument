//
//  MainViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import SnapKit
import StoreKit
import MediaPlayer




class MainViewController: UIViewController {
    
    let currentDate = Date()
    let dateLb = UILabel()
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: view.frame.width - 100, height: 500)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview([collectionView])
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).offset(-50)
        }
        
        collectionView.backgroundColor = .white
        collectionView.register(ScCollectionViewCell.self, forCellWithReuseIdentifier: "ScCollectionViewCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
        
        collectionView.scrollToItem(at: IndexPath.init(row: calendar.day! - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            API.getSongInfo(userToken: UserDefaults.standard.string(forKey: "MusicToken")!) { (result) in
                print(result)
            }
        }else{
            appleMusicCheck()
        }
        
    }
    
    
    func appleMusicCheck() {
        
        let serviceCon = SKCloudServiceController()
        
  
        SKCloudServiceController.requestAuthorization { (status) in
            print(status)
            
            serviceCon.requestUserToken(forDeveloperToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkEzUUxZRFhRWTYifQ.eyJpYXQiOjE1NTI5NzM1MTEsImV4cCI6MTU2ODUyNTUxMSwiaXNzIjoiUzM2SlZHRjM3OCJ9.ctz7UBkr7mvrP0TrW9VuHuA10oPvwMIQGlMtjjv_Hs9JYw8yGMxWPNDvyEQSrREj3Vqv33Qx6Ykx-0QOegqCVA") { (token, err) in
              
                
                UserDefaults.standard.set(token, forKey: "MusicToken")
                
                API.getSongInfo(userToken: token!, completion: { (result) in
                    print(result)
                })
                
            }
        }
        
        
    }
    

}





extension MainViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScCollectionViewCell", for: indexPath) as! ScCollectionViewCell
        
        let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
        
        cell.setData(isToday: indexPath.row == calendar.day! - 1, date: "\(indexPath.row + 1)", thumnailImg: UIImage())
       
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}



class ScCollectionViewCell:UICollectionViewCell {
    
    let todayIndicatorLb = UILabel()
    let dateLb = UILabel()
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(isToday:Bool, date:String, thumnailImg:UIImage) {
        
        todayIndicatorLb.isHidden = !isToday
        dateLb.text = date
        imageView.image = thumnailImg
        
    }
    
    private func setUI() {
     
        self.setBorder(color: .black, width: 0.5, cornerRadius: 5)
        self.addSubview([todayIndicatorLb, dateLb, imageView])
        
        todayIndicatorLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        todayIndicatorLb.text = "TODAY"
        
        dateLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(todayIndicatorLb.snp.bottom).offset(10)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum WeekDay:Int {
    
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
}

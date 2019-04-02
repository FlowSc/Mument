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
    
    var fromCalendar:Bool = false
    let currentDate = Date()
    let dateLb = UILabel()
    var collectionView:UICollectionView!
    var monthLength:Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedMonth:Int = 0
    var selectedYear:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        if !fromCalendar {
            let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
            
            monthLength = lastDay(ofMonth: calendar.month!, year: calendar.year!)
        }

        
    }
    
    func setMonthLength(month:Int, year:Int) {
        
        monthLength = lastDay(ofMonth: month, year: year)
        
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
    }

}





extension MainViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthLength ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScCollectionViewCell", for: indexPath) as! ScCollectionViewCell
        
        let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
        
        cell.setData(isToday: indexPath.row == calendar.day! - 1, date: "\(indexPath.row + 1)", thumnailImg: UIImage())
       
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DiaryViewController()
        
        if fromCalendar {
            
            vc.dateId = "\(selectedYear)\(selectedMonth)\(indexPath.row + 1)"
            
        }else{
            let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
            
            let id = "\(calendar.year!)\(calendar.month!)\(indexPath.row + 1)"
            
            vc.dateId = id
        }
        


        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
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

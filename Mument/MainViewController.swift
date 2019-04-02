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


let DEVICEWINDOW = UIWindow().frame


class MainViewController: UIViewController {
    
    var fromCalendar:Bool = false
    let currentDate = Date()
    let dateLb = UILabel()
    var collectionView:UICollectionView!
    var monthLength:Int?
    var selectedMonth:Int = 0
    var selectedYear:Int = 0
    let backBtn = UIButton()
    var monthlyDiaries:[Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingData()
    }
    
    func loadingData() {
        if !fromCalendar {
            let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
            
            dateLb.text = "\(calendar.year!)년 \(calendar.month!)월"
            monthLength = lastDay(ofMonth: calendar.month!, year: calendar.year!)
            
            monthlyDiaries.removeAll()
            
            for i in 1...monthLength! {
                
                let dayId = "\(calendar.year!)\(calendar.month!.addZero())\(i.addZero())"
                
                if let diary = realm.objects(Diary.self).filter({$0.id == dayId}).first {
                    monthlyDiaries.append(diary)
                }
            }
            
        }else{
            self.view.addSubview(backBtn)
            backBtn.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.top.equalTo(view.safeArea.top).offset(10)
                make.width.height.equalTo(50)
            }
            dateLb.text = "\(selectedYear)년 \(selectedMonth)월"
            backBtn.addTarget(self, action: #selector(backbuttonTouched(sender:)), for: .touchUpInside)
            backBtn.backgroundColor = .red
            monthlyDiaries.removeAll()
            
            for i in 1...monthLength! {
                let dayId = "\(selectedYear)\(selectedMonth.addZero())\(i.addZero())"
                
                if let diary = realm.objects(Diary.self).filter({$0.id == dayId}).first {
                    monthlyDiaries.append(diary)
                }
            }
            
        }
    }
    
    @objc func backbuttonTouched(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setMonthLength(month:Int, year:Int) {
        
        monthLength = lastDay(ofMonth: month, year: year)
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        
        if DEVICEWINDOW.height < 600 {
            layout.itemSize = CGSize.init(width: view.frame.width - 100, height: 380)
        }else{
            layout.itemSize = CGSize.init(width: view.frame.width - 100, height: 500)

        }
        
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview([collectionView, dateLb])
        
        dateLb.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
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
        
        if !fromCalendar {
                    collectionView.scrollToItem(at: IndexPath.init(row: calendar.day! - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    
    }

}





extension MainViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthLength ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScCollectionViewCell", for: indexPath) as! ScCollectionViewCell
        
        
        let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
        
  
        if fromCalendar {
            if let cellItem = monthlyDiaries.filter({$0.id.contains("\(selectedYear)\(selectedMonth.addZero())\((indexPath.row + 1).addZero())")}).first {
                cell.setData(isToday: false, date: "\(indexPath.row + 1)일", thumnailImg: cellItem.song!.artworkUrl)
            }else{
                cell.setData(isToday: false, date: "\(indexPath.row + 1)일", thumnailImg: "")
            }
        }else{
            if let cellItem = monthlyDiaries.filter({$0.id.contains("\(calendar.year!)\((calendar.month!).addZero())\((indexPath.row + 1).addZero())")}).first {
                cell.setData(isToday: indexPath.row == calendar.day! - 1, date: "\(indexPath.row + 1)일", thumnailImg: cellItem.song!.artworkUrl)
            }else{
                  cell.setData(isToday: indexPath.row == calendar.day! - 1, date: "\(indexPath.row + 1)일", thumnailImg: "")
            }
        }
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedId = ""
        let vc = DiaryViewController()
        
        if fromCalendar {
            
            selectedId = "\(selectedYear)\(selectedMonth.addZero())\((indexPath.row + 1).addZero())"
            
            vc.dateId = selectedId
//            vc.dateLb.text =
            
        }else{
            let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
            
            selectedId = "\(calendar.year!)\(calendar.month!.addZero())\((indexPath.row + 1).addZero())"
            
            vc.dateId = selectedId
        }
        
        vc.dateLb.text = "\(dateLb.text!) \(indexPath.row + 1)일"
        
        if let written = realm.objects(Diary.self).filter({$0.id == selectedId}).first {

            vc.setWrittenInfo(diary: written)
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            self.navigationController?.pushViewController(vc, animated: true)

        }

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
    
    func setData(isToday:Bool, date:String, thumnailImg:String) {
        
        todayIndicatorLb.isHidden = !isToday
        dateLb.text = date
        imageView.kf.setImage(with: URL.init(string: thumnailImg))
        
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
        imageView.contentMode = .scaleToFill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum WeekDay:Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday    
}

extension Int {
    
    func addZero() -> String{
        
        if "\(self)".count == 1 {
            return "0\(self)"
        }else{
            return "\(self)"
        }
    }
}

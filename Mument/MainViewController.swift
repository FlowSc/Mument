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
    private let months:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingData()
    }
    
    
    func loadingData() {
        
        dateLb.font = UIFont.AmericanTypeWriter(.bold, size: 30)
        if !fromCalendar {
            let calendar = Calendar.current.dateComponents([.month, .day, .year, .weekday], from: currentDate)
            
            dateLb.text = "\(months[calendar.month! - 1].localized), \(calendar.year!)"
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
                make.top.equalTo(view.safeArea.top).offset(10)
                make.leading.equalTo(10)
                make.width.height.equalTo(30)
            }
            backBtn.setImage(UIImage.init(named: "left-arrow-1"), for: .normal)
            
            dateLb.text = "\(months[selectedMonth - 1].localized), \(selectedYear)"
            
            monthLength = lastDay(ofMonth: selectedMonth, year: selectedYear)


            
            backBtn.addTarget(self, action: #selector(backbuttonTouched(sender:)), for: .touchUpInside)
            monthlyDiaries.removeAll()
            
            for i in 1...monthLength! {
                let dayId = "\(selectedYear)\(selectedMonth.addZero())\(i.addZero())"
                
                if let diary = realm.objects(Diary.self).filter({$0.id == dayId}).first {
                    monthlyDiaries.append(diary)
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    @objc func backbuttonTouched(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setMonthLength(month:Int, year:Int) {
        
        monthLength = lastDay(ofMonth: month, year: year)
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .backgroundBrown
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        
        if DEVICEWINDOW.height < 600 {
            layout.itemSize = CGSize.init(width: view.frame.width - 100, height: 380)
        }else{
            layout.itemSize = CGSize.init(width: view.frame.width - 100, height: 480)

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
            make.top.equalTo(dateLb.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).offset(-30)
        }
        
        self.collectionView.backgroundColor = .backgroundBrown
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
            collectionView.reloadData()
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
                cell.setData(isToday: false, date: "\((indexPath.row + 1).ordinal)", selectedSong: cellItem.song!)
                
                cell.emptyLb.isHidden = true

            }else{
                cell.setData(isToday: false, date: "\((indexPath.row + 1).ordinal)", selectedSong: nil)
                cell.emptyLb.isHidden = false

            }
        }else{
            if let cellItem = monthlyDiaries.filter({$0.id.contains("\(calendar.year!)\((calendar.month!).addZero())\((indexPath.row + 1).addZero())")}).first {
                cell.setData(isToday: indexPath.row == calendar.day! - 1, date: "\((indexPath.row + 1).ordinal)", selectedSong: cellItem.song!)
                cell.emptyLb.isHidden = true

            }else{
                cell.setData(isToday: indexPath.row == calendar.day! - 1, date:"\((indexPath.row + 1).ordinal)", selectedSong: nil)
                cell.emptyLb.isHidden = false
                
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
        
        vc.dateLb.text = "\((indexPath.row + 1).ordinal) \(dateLb.text!)"
        
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
    
    private let todayIndicatorLb = UILabel()
    private let dateLb = UILabel()
    private let imageView = UIImageView()
    private let titleLb = UILabel()
    private let artistLb = UILabel()
    let emptyLb = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func setData(isToday:Bool, date:String, selectedSong:Song?) {
        
        todayIndicatorLb.isHidden = !isToday
        dateLb.text = date
        dateLb.font = UIFont.AmericanTypeWriter(.regular, size: 20)
        
        
        if let _selected = selectedSong {
            
            artistLb.isHidden = false
            titleLb.isHidden = false
            
            artistLb.text = _selected.artistName
            titleLb.text = _selected.title
            
            artistLb.font = UIFont.notoMedium(15)
            titleLb.font = UIFont.notoMedium(20)
            artistLb.textColor = .gray
            
            if _selected.artworkUrl != "" {
                imageView.kf.setImage(with: URL.init(string: _selected.artworkUrl))
            }else {
                if let imageData = _selected.localImage {
                    imageView.image = UIImage.init(data: imageData)
                }else{
                    imageView.image = UIImage.init(named: "defaultAlbum")
                }
                
            }
        }else{
            artistLb.isHidden = true
            titleLb.isHidden = true
        }
        
//
    }
    
    private func setUI() {
     
        self.setBorder(color: .clear, width: 0.5, cornerRadius: 5)
        self.dropShadow(color: .black, offSet: CGSize.init(width: 5, height: 5))
        self.addSubview([todayIndicatorLb, dateLb, imageView, titleLb, artistLb, emptyLb])
        
        todayIndicatorLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        todayIndicatorLb.text = "TODAY"
        todayIndicatorLb.font = UIFont.AmericanTypeWriter(AmericanTypeWriterFontSize.bold, size: 20)
        self.backgroundColor = .cellBrown
        
        dateLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
            make.height.equalTo(25)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
//            make.bottom.equalTo(-10)
        }
        
        imageView.contentMode = .scaleToFill
        

        
        titleLb.numberOfLines = 1
        titleLb.adjustsFontSizeToFitWidth = true
        artistLb.adjustsFontSizeToFitWidth = true
        titleLb.textAlignment = .center
        artistLb.textAlignment = .center
        artistLb.numberOfLines = 1
        
        titleLb.isHidden = true
        artistLb.isHidden = true

        artistLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
            make.bottom.equalTo(-15)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(artistLb.snp.top).offset(-15)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
        }
        
        imageView.setBorder(color: UIColor.clear, width: 0.5, cornerRadius: 3)
        
        emptyLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
        
        emptyLb.textAlignment = .center
        emptyLb.text = "EmptyLabel".localized
        emptyLb.numberOfLines = 0
        emptyLb.font = UIFont.montserratBold(15)
        

        
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

extension Int {
    
    var ordinal: String {
        var suffix: String
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "\(self)\(suffix)"
    }
    
}

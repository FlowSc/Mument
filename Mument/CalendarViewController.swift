//
//  CalendarViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    let yearBtn = UIButton()
    var monthCollectionView:UICollectionView!
    var pickerView:UIPickerView!
    var selectedYear = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUI()

        monthCollectionView.delegate = self
        monthCollectionView.tag = 0
        monthCollectionView.dataSource = self
        monthCollectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: "MonthCollectionViewCell")
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        monthCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        
        if let currentYear = Calendar.current.dateComponents([.year], from: Date()).year {
            yearBtn.setTitle("\(currentYear) 년", for: .normal)
        }
        
        
        pickerView = UIPickerView()
        
        self.view.addSubview([yearBtn, monthCollectionView, pickerView])
        self.monthCollectionView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        yearBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(view.safeArea.top).offset(25)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        yearBtn.setBorder(color: .black, width: 0.5, cornerRadius: 3)
        
        monthCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(yearBtn.snp.bottom).offset(25)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.leading.equalTo(yearBtn.snp.trailing).offset(10)
            make.top.equalTo(yearBtn.snp.top).offset(-5)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        yearBtn.setTitleColor(.black, for: .normal)
        
        yearBtn.addTarget(self, action: #selector(callPickerView(sender:)), for: .touchUpInside)
    }
    
    @objc func callPickerView(sender:UIButton) {
        
        sender.isSelected = !(sender.isSelected)
        
        pickerView.isHidden = !sender.isSelected
        
    }
}

extension CalendarViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(2019 + row) 년"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = 2019 + row
        yearBtn.setTitle("\(2019 + row) 년", for: .normal)
    }
    
    
}

extension CalendarViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
        
        cell.setMonth(indexPath.row + 1)
  
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if DEVICEWINDOW.height < 600 {
            return CGSize.init(width: 80, height: 80)

        }else{
            return CGSize.init(width: 100, height: 100)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = MainViewController()
        
        
        vc.selectedYear = selectedYear
        vc.selectedMonth = indexPath.row + 1
        vc.setMonthLength(month: indexPath.row + 1, year: 2019)
        vc.fromCalendar = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

class MonthCollectionViewCell:UICollectionViewCell {
    
    private let lbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        lbl.textColor = .black
        lbl.textAlignment = .center
        
        self.setBorder(color: .black, width: 0.5, cornerRadius: 5)
    }
    
    func setMonth(_ month:Int) {
        self.lbl.text = "\(month)월"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

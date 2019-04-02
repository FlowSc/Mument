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
    var yearSelectCollectionView:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUI()

        monthCollectionView.delegate = self
        monthCollectionView.tag = 0
        monthCollectionView.dataSource = self
        monthCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        monthCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)

        self.view.addSubview([yearBtn, monthCollectionView])
        self.monthCollectionView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        yearBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeArea.top).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(80)
        }
        
        yearBtn.setBorder(color: .black, width: 0.5, cornerRadius: 3)
        
        monthCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(yearBtn.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
    }
}

extension CalendarViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blue.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = MainViewController()
        
        
        vc.selectedYear = 2019
        vc.selectedMonth = indexPath.row + 1
        vc.setMonthLength(month: indexPath.row + 1, year: 2019)
        vc.fromCalendar = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

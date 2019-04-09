//
//  MusicTableViewCell.swift
//  Mument
//
//  Created by Seongchan Kang on 01/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {
    
    private let thumnailImv = UIImageView()
    private let titleLb = UILabel()
    private let nameLb = UILabel()
    
//    init


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([thumnailImv, titleLb, nameLb])
        
        thumnailImv.snp.makeConstraints { (make) in
            make.leading.top.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.equalTo(-10)
           
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(thumnailImv.snp.top)
            make.leading.equalTo(thumnailImv.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
        nameLb.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLb.snp.leading)
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
    }
    
    func setData(_ song:Song) {
        
        self.nameLb.font = UIFont.notoMedium(12)
        self.titleLb.font = UIFont.notoMedium(14)
        self.thumnailImv.kf.setImage(with: URL.init(string: song.artworkUrl))
        self.nameLb.text = song.artistName
        self.nameLb.textColor = .black
        self.titleLb.textColor = .black

        self.titleLb.text = song.title
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

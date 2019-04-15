//
//  ConfigViewController.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import UIKit
import MessageUI

class ConfigViewController: UIViewController {
    
    private let tableView = UITableView()
    private let titleLb = UILabel()
    
    typealias ConfigTuple = (image:UIImage, title:String, desc:String)
    
    let menuTuples:[ConfigTuple] = [(image:UIImage.init(named: "envelope")!, title:"askDeveloper".localized, ""), (image:UIImage.init(named: "information")!, title:"versionInfo".localized, "V 1.0")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    private func setUI() {
        
        self.view.addSubview([tableView, titleLb])
        self.view.backgroundColor = .backgroundBrown
        self.navigationController?.isNavigationBarHidden = true
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeArea.top).offset(10)
        }
        
        titleLb.text = "config".localized
        titleLb.font = UIFont.notoMedium(18)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.backgroundColor = .backgroundBrown
        tableView.separatorStyle = .none
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
}

extension ConfigViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        let cellItem = menuTuples[indexPath.row]
        
        cell.setData(img: cellItem.image, title: cellItem.title, infoString: cellItem.desc)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            if !MFMailComposeViewController.canSendMail() {
                print("NO!")
                return
            }
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["zelatool@gmail.com"])
                mail.setMessageBody("", isHTML: false)
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
            
        }
    }
    
    
}

extension ConfigViewController:MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension UITableView {
    func groupSectionHeaderElimination(){
        self.sectionHeaderHeight = 0
        self.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 0, height: CGFloat.leastNormalMagnitude)))
    }
}



class MenuTableViewCell:UITableViewCell {
    
    private let leftImv = UIImageView()
    private let titleLb = UILabel()
    private let infoLb = UILabel()
    private let underLine = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(img:UIImage, title:String, infoString:String?) {
        self.leftImv.image = img
        self.titleLb.attributedText = title.makeAttrString(font: UIFont.notoMedium(15), color: .black)
        
        
        if let _info = infoString {
            infoLb.isHidden = false
            self.infoLb.attributedText = _info.makeAttrString(font: UIFont.notoMedium(13), color: .black)
            
        }else{
            infoLb.isHidden = true
        }
        
        
    }
    
    private func setUI() {
        
        self.selectionStyle = .none
        self.addSubview([leftImv, titleLb, infoLb, underLine])
        self.backgroundColor = .backgroundBrown
        
        leftImv.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(leftImv.snp.right).offset(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        infoLb.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.trailing.equalTo(-20)
        }
        
        underLine.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        underLine.backgroundColor = .black
        
        infoLb.isHidden = true
        infoLb.textAlignment = .right
        
    }
    
}

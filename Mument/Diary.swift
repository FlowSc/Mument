//
//  Diary.swift
//  Mument
//
//  Created by Seongchan Kang on 02/04/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Diary:Object {
    
    @objc dynamic var song:Song? = nil
    @objc dynamic var id:String = ""
    @objc dynamic var contents:String = ""
    
}


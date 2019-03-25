//
//  Playlist.swift
//  Mument
//
//  Created by Seongchan Kang on 25/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import ObjectMapper

class Playlist:Mappable {
    
    
    var thumnailUrl:String = ""
    var shortDescription:String = ""
    var longDescription:String = ""
    var playId:String = ""
    var type:String = ""
    var playUrl:String = ""
    var curatorName:String = ""
    var artistName:String = ""
    
    func mapping(map: Map) {
        self.thumnailUrl <- map["attributes.artwork.url"]
        self.playId <- map["id"]
        
        self.thumnailUrl = convertThumnailUrl(url: thumnailUrl)
    }
    
    func convertThumnailUrl(url:String) -> String {
        
        return url.replacingOccurrences(of: "{w}", with: "640").replacingOccurrences(of: "{h}", with: "640")
//        return url.replace
    }
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
}


enum PlayListType:String {
    
    case playlist, album, single
    
}

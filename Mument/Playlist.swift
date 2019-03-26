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
        self.type <- map["type"]
        self.thumnailUrl = convertThumnailUrl(url: thumnailUrl)
    }
    
    func convertThumnailUrl(url:String) -> String {
        
        return url.replacingOccurrences(of: "{w}", with: "640").replacingOccurrences(of: "{h}", with: "640")
    }
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
}

class Song:Mappable {
    
    var artistName:String = ""
    var title:String = ""
    var url:String = ""
    var type:String = ""
    var artworkUrl:String = ""
    var id:String = ""
    var albumName:String = ""
    
    func mapping(map: Map) {
        
        artistName <- map["artistName"]
        albumName <- map["albumName"]
        title <- map["name"]
        url <- map["url"]
        artworkUrl <- map["artwork.url"]
        self.artworkUrl = convertThumnailUrl(url: artworkUrl)
        id <- map["id"]

    }
    
    func convertThumnailUrl(url:String) -> String {
        
        return url.replacingOccurrences(of: "{w}", with: "640").replacingOccurrences(of: "{h}", with: "640")
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
}

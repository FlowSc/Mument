//
//  Playlist.swift
//  Mument
//
//  Created by Seongchan Kang on 25/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import ObjectMapper
import Realm
import RealmSwift
import MediaPlayer

class Playlist:Object, Mappable {
    
    
    @objc dynamic var thumnailUrl:String = ""
    @objc dynamic var shortDescription:String = ""
    @objc dynamic var longDescription:String = ""
    @objc dynamic var playId:String = ""
    @objc dynamic var type :String = ""
    @objc dynamic var playUrl:String = ""
    @objc dynamic var curatorName:String = ""
    @objc dynamic var artistName:String = ""
    @objc dynamic var name:String = ""
    
    func mapping(map: Map) {
        self.thumnailUrl <- map["attributes.artwork.url"]
        self.name <- map["attributes.name"]
        self.curatorName <- map["attributes.curatorName"]
        self.artistName <- map["attributes.artistName"]
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

class Song:Object, Mappable {
    
    @objc dynamic var artistName:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var url:String = ""
    @objc dynamic var artworkUrl:String = ""
    @objc dynamic var id:String = ""
    @objc dynamic var albumName:String = ""
    @objc dynamic var lastPlayedDate:Date?
    
    var localItem:MPMediaItem?
    @objc dynamic var localImage:UIImage?
    
    func mapping(map: Map) {
        
        artistName <- map["attributes.artistName"]
        albumName <- map["attributes.albumName"]
        title <- map["attributes.name"]
        url <- map["attributes.url"]
        artworkUrl <- map["attributes.artwork.url"]
        self.artworkUrl = convertThumnailUrl(url: artworkUrl)
        id <- map["id"]

    }
    
    
    
    convenience init(item:MPMediaItem) {
        self.init()
        
        self.localItem = item
        self.artistName = item.artist ?? ""
        self.title = item.title ?? ""
        self.url = item.assetURL?.absoluteString ?? ""
        self.id = item.playbackStoreID
        self.localImage = item.artwork?.image(at: CGSize.init(width: 640, height: 640))
        self.lastPlayedDate = item.lastPlayedDate

    }
    
    func convertThumnailUrl(url:String) -> String {
        
        return url.replacingOccurrences(of: "{w}", with: "640").replacingOccurrences(of: "{h}", with: "640")
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
}

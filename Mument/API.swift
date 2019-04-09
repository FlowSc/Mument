//
//  API.swift
//  Mument
//
//  Created by Seongchan Kang on 19/03/2019.
//  Copyright © 2019 seongchan. All rights reserved.
//

import Foundation
import Alamofire
import StoreKit
import Cider
import SwiftyJSON
import ObjectMapper

struct API {
    
    static let appleMusicToken = "Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkEzUUxZRFhRWTYifQ.eyJpYXQiOjE1NTI5NzM1MTEsImV4cCI6MTU2ODUyNTUxMSwiaXNzIjoiUzM2SlZHRjM3OCJ9.ctz7UBkr7mvrP0TrW9VuHuA10oPvwMIQGlMtjjv_Hs9JYw8yGMxWPNDvyEQSrREj3Vqv33Qx6Ykx-0QOegqCVA"
    static var header = ["Content-Type":"application/json", "Authorization":appleMusicToken]

    static func getRecentPlayed(userToken:String, offset:Int, completion:(([Playlist]?)->())?) {
        
        header["Music-User-Token"] = userToken
        
        Alamofire.request("https://api.music.apple.com/v1/me/recent/played?offset=\(offset)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                
                let results = json["data"].arrayValue
                
                print(results)
                
                let mapped = results.map({Mapper<Playlist>().map(JSONString: $0.description)!})
                
                completion!(mapped)
                
                
            case .failure(_):
                completion!(nil)
            }
            
            
        }
        
    }
    
    static func getLocalPlaylist(userToken:String, storefront:String, type:String, id:String, completion:(([Song]?)->())?) {
        
        header["Music-User-Token"] = userToken
        
        Alamofire.request("https://api.music.apple.com/v1/me/library/playlists/p.oOzAaQPH9W33pe", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                
                print(json)
                
                let results = json["data"][0]["relationships"]["tracks"]["data"].arrayValue
                
                //
                
                let mapped = results.map({Mapper<Song>().map(JSONString: $0.description)!})
                
                completion!(mapped)
                
            //
            case .failure(_):
                completion!(nil)
                
            }
        }

    }
    
    
    
    static func getMusicsFromPlaylist(userToken:String, storefront:String, type:String, id:String, completion:(([Song]?)->())?) {
        
        header["Music-User-Token"] = userToken

        
        Alamofire.request("https://api.music.apple.com/v1/catalog/\(storefront)/\(type)/\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            switch response.result {
            
            case .success(let value):
                
                let json = JSON(value)
                
                print(json)
                
                if let results = json["data"][0]["relationships"]["tracks"]["data"].array {
                    let mapped = results.map({Mapper<Song>().map(JSONString: $0.description)!})
                    
                    completion!(mapped)
                }else{
                    completion!(nil)
                }

//

             

//
            case .failure(_):
                completion!(nil)
            
            }
            
        }
        
    }
    
    
    
}

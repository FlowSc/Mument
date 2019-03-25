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

    static func getRecentPlayed(userToken:String, completion:(([Playlist]?)->())?) {
        
        header["Music-User-Token"] = userToken
        
        Alamofire.request("https://api.music.apple.com/v1/me/recent/played", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
    
    static func getMusicsFromPlaylist(userToken:String, playListId:String, completion:((Any)->())?) {
        
        header["Music-User-Token"] = userToken

        
//        Alamofire.request("https://api.music.apple.com/v1/catalog/{storefront}/playlists/\(playListId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
//            <#code#>
//        }
        
    }
    
    
}

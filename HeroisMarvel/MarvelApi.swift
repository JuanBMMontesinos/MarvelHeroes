//
//  MarvelApi.swift
//  HeroisMarvel
//
//  Created by JUAN MONTESINOS on 15/05/2018.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelApi {
    
    static private let basePath = "http://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "3a4bb1b7c8ca621591e7814a45c837f6c1fc950d"
    static private let publicKey = "292732cb7d9726c03a4816933f8a30cb"
    static private let limit = 50
    
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            
            do {
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                print(marvelInfo)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
}

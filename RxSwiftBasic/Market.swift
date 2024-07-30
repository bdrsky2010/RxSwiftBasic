//
//  Market.swift
//  SeSAC5MVVMBasic
//
//  Created by Minjae Kim on 7/10/24.
//

import Foundation

struct Market: Decodable {
    let market: String
    let korean_name: String
    let english_name: String
    
    var title: String {
        return korean_name + " | " + english_name
    }
}

//
//  TwitterReponse.swift
//  TwitterSearch
//
//  Created by Michael on 20/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import ObjectMapper


public struct TwitterResponse {
    public var statuses : [TwitterStatus]?
}

extension TwitterResponse : Mappable {
    
    public init?(map: Map) {
        
    }
    mutating public func mapping(map: Map) {
        statuses <- map["statuses"]
    }
}

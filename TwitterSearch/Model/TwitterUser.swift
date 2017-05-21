//
//  TwitterUser.swift
//  TwitterSearch
//
//  Created by Michael on 20/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import ObjectMapper

public struct TwitterUser {
    public var username: String?
    public var userIconURL: URL?
}

extension TwitterUser : Mappable {
    public init?(map: Map) {
    }
    
    mutating public func mapping(map: Map) {
        username <-  map["name"]
        userIconURL <- (map["profile_image_url_https"],URLTransform())
    }
}

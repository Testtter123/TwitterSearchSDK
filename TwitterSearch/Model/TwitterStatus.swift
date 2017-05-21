//
//  TwitterStatus.swift
//  TwitterSearch
//
//  Created by Michael on 20/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import ObjectMapper

public struct TwitterStatus {
    public var id: String?
    public var text: String?
    public var createdAt: Date?
    public var user: TwitterUser?
}


extension TwitterStatus: Mappable {
    
    public init?(map: Map) {
        
    }
    mutating public func mapping(map: Map) {
        id <- map["id_str"]
        text <-  map["text"]
        createdAt <- (map["created_at"],TwitterDateTransform())
        user <- map["user"]
    }
}


open class TwitterDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    
    func twitterFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        return dateFormatter
    }
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeStr = value as? String {
            let dateFormatter = twitterFormatter()
            return dateFormatter.date(from: timeStr)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            let dateFormatter = twitterFormatter()
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

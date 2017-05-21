//
//  TwitterSearch.swift
//  TwitterSearch
//
//  Created by Michael on 20/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import UIKit
import OhhAuth
import Alamofire
import AlamofireObjectMapper

public struct TwitterAuth {
    let consumerKey: String
    let consumerSecret: String
    let userAccessToken: String
    let userAccessTokenSecret: String
    
    public init(_ consumerKey: String,_ consumerSecret: String,_ userAccessToken : String,_ userAccessTokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.userAccessToken = userAccessToken
        self.userAccessTokenSecret = userAccessTokenSecret
    }
}

enum TwitterError: Error {
    case MisingTokens
    case URLParsingError
    case ParsingError
}

public final class TwitterSearch {
    
    public static let `shared` = TwitterSearch()
    var twitterAuthTokens: TwitterAuth?
    
    private init() {
    }
    
    public func setTwitterTokens(consumerKey: String, consumerSecret: String, userAccessToken : String, userAccessTokenSecret: String) {
        twitterAuthTokens = TwitterAuth(consumerKey,consumerSecret,userAccessToken,userAccessTokenSecret)
    }

    
    private struct Constants {
        static let searchURL =  "https://api.twitter.com/1.1/search/tweets.json?q="
        static let method = "GET"
        static let authorizationHeader = "Authorization"
        static let hashTag = "%23"
    }

    func authorization(twitterAuth auth:TwitterAuth, url: URL) -> String {
        let consumerCred = OhhAuth.Credentials(auth.consumerKey,auth.consumerSecret)
        let accessCred = OhhAuth.Credentials(auth.userAccessToken,auth.userAccessTokenSecret)
        
        return OhhAuth.calculateSignature(url: url, method: Constants.method, parameter: [:], consumerCredentials: consumerCred, userCredentials: accessCred)
    }
    
    func headers(authorization: String) -> HTTPHeaders {
        return [Constants.authorizationHeader : authorization]
    }
    func urlBuilder(searchTerm term: String, prefix: String = Constants.hashTag) -> URL? {
        return URL(string: Constants.searchURL + prefix + term)
    }
    
    public func search(hashTag: String,
                completion:  @escaping (Result<TwitterResponse>) -> Void) {
        guard let auth = twitterAuthTokens else {
            completion(Result.failure(TwitterError.MisingTokens))
            return
        }
        guard let url = urlBuilder(searchTerm: hashTag) else {
            completion(Result.failure(TwitterError.URLParsingError))
            return
        }
        let signed = authorization(twitterAuth: auth, url: url)
        let authHeaders = headers(authorization: signed)
        Alamofire.request(url, headers: authHeaders).validate().responseObject {
            (response: DataResponse<TwitterResponse>) in
            
            if let error = response.result.error {
                completion(Result.failure(error))
            } else  if let twitterResponse = response.result.value {
                completion(Result.success(twitterResponse))
            }
            else {
                completion(Result.failure(TwitterError.ParsingError))
            }
        }

    }
    
    
}

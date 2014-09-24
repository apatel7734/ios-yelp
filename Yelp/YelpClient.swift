//
//  YelpClient.swift
//  Yelp
//
//  Created by Ashish Patel on 9/20/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import Foundation

class YelpClient: BDBOAuth1RequestOperationManager{
/*
    let YELP_CONSUMER_KEY="38ms0UZ6soEdBZuDpM2JCA"
    let YELP_CONSUMER_SECRET="-1bqbexkCPt9X3VNLXTarBGor8"
    let YELP_TOKEN = "eWnMPdw_aR6e78JwtW22lZHwJbendqbw"
    let YELP_TOKEN_SECRET = "Op_0wniU1YU5dvF8CP5sqVfx14s"
*/
    
    let YELP_CONSUMER_KEY="38ms0UZ6soEdBZuDpM2JCA"
    let YELP_CONSUMER_SECRET="T-1bqbexkCPt9X3VNLXTarBGor8"
    let YELP_TOKEN = "eWnMPdw_aR6e78JwtW22lZHwJbendqbw"
    let YELP_TOKEN_SECRET = "Op_0wniU1YU5dvF8CP5sqVfx14s"
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: YELP_CONSUMER_KEY, consumerSecret: YELP_CONSUMER_SECRET);
        
        var token = BDBOAuthToken(token: YELP_TOKEN, secret: YELP_TOKEN_SECRET, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String,parameters: [[String:String]]?, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        if (parameters?.count > 0 ){
            println("Parameters > 0")
        }
        var parameters = ["term": term, "location": "SanFrancisco"]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
}
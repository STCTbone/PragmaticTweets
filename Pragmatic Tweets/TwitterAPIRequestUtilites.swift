//
//  TwitterAPIRequestUtilites.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/4/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import Foundation
import Social
import Accounts

func sendTwitterRequest (requestURL: NSURL, params: [ String: String ],
  completion: SLRequestHandler) {
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
      (granted: Bool, error: NSError!) -> Void in
      guard granted else {
        NSLog("account access not granted")
        return
      }
      let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
      guard twitterAccounts.count > 0 else {
        NSLog("no twitter accounts configured")
        return
      }
      let request = SLRequest(forServiceType: SLServiceTypeTwitter,
        requestMethod: .GET, URL: requestURL, parameters: params)
      request.account = twitterAccounts.first as! ACAccount
      request.performRequestWithHandler(completion)
    })
}
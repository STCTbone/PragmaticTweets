//
//  ViewController.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/2/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/" + "default_profile_6_200x200.png")

class ViewController: UITableViewController{
  
  var parsedTweets : [ParsedTweet] = [
    ParsedTweet(tweetText : "iOS 9 SDK Development now in print. " +
      "Swift programming FTW!",
      userName: "@pragprog",
      createdAt: "2015-09-09 14:44:30 EDT",
      userAvatarURL: defaultAvatarURL),
    
    ParsedTweet(tweetText: "But was that really such a good idea?",
      userName: "@redqueencoder",
      createdAt: "2014-12-04 22:15:55 CST",
      userAvatarURL: defaultAvatarURL),
    
    ParsedTweet(tweetText: "Struct all the things!",
      userName:  "@invalidname",
      createdAt: "2015-07-31 05:39:39 EDT",
      userAvatarURL: defaultAvatarURL)
  ]

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func handleRefresh (sender : AnyObject?) {
    parsedTweets.append(
      ParsedTweet(tweetText: "New row", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL)
    )
    reloadTweets()
    refreshControl?.endRefreshing()
  }

  @IBAction func handleTweetButtonTapped(sender: UIButton) {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      tweetVC.setInitialText("I just finished the first project in iOS 9 SDK Development. #pragsios9")
      self.presentViewController(tweetVC, animated: true, completion: nil)
    } else {
      NSLog("Can't send tweet")
    }
  }
  
  func reloadTweets() {
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType,
      options: nil,
      completion: {
        (granted: Bool, error: NSError!) -> Void in guard granted else {
          NSLog("account access not granted")
          return
        }
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        guard twitterAccounts.count > 0 else {
          NSLog("no twitter accounts configured")
          return
        }
        let twitterParams = [
          "count" : "100"
        ]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: twitterAPIURL, parameters: twitterParams)
        request.account = twitterAccounts.first as! ACAccount
        request.performRequestWithHandler({
          (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
          self.handleTwitterData(data, urlResponse: urlResponse, error: error)
        })
    })
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parsedTweets.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
    let parsedTweet = parsedTweets[indexPath.row]
    cell.userNameLabel.text = parsedTweet.userName
    cell.tweetTextLabel.text = parsedTweet.tweetText
    cell.createdAtLabel.text = parsedTweet.createdAt
    if let url = parsedTweet.userAvatarURL, imageData = NSData(contentsOfURL: url) {
      cell.avatarImageVIew.image = UIImage(data: imageData)
    }
    return cell
  }
  
  private func handleTwitterData (data: NSData!,
    urlResponse: NSHTTPURLResponse!,
    error: NSError!) {
      guard let data = data else {
        NSLog("handleTwitterData() received no data")
        return
      }
      NSLog("handleTwitterData(), \(data.length) bytes")
      do {
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
        NSLog("JSON is:\n\(jsonObject)")
      } catch let error as NSError {
        NSLog("JSON error: \(error)")
      }
  }
}


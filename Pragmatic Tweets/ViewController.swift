//
//  ViewController.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/2/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import UIKit
import Social

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
    tableView.reloadData()
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
}


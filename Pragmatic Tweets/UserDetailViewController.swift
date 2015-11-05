//
//  UserDetailViewController.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/5/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userRealNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userLocationLabel: UILabel!
  @IBOutlet weak var userDescriptionLabel: UILabel!
  
  var screenName : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    guard let screenName = screenName else {
      return
    }
    let twitterParams = ["screen_name" : screenName]
    if let twitterAPIURL = NSURL(string:
      "https://api.twitter.com/1.1/users/show.json") {
        sendTwitterRequest(twitterAPIURL,
          params: twitterParams,
          completion: { (data, urlResponse, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
              self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
        })
    }
  }
  
  func handleTwitterData (data: NSData!,
    urlResponse: NSHTTPURLResponse!,
    error: NSError!) {
      guard let data = data else {
        NSLog("handleTwitterData() received no data")
        return
      }
      NSLog("handleTwitterData(), \(data.length) bytes")
      do {
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
          options: NSJSONReadingOptions([]))
        guard let tweetDict = jsonObject as? [String : AnyObject] else {
          NSLog("handleTwitterData() didn't get an array")
          return
        }
        userRealNameLabel.text = (tweetDict["name"] as! String)
        userScreenNameLabel.text = (tweetDict["screen_name"] as! String)
        userLocationLabel.text = (tweetDict["location"] as! String)
        userDescriptionLabel.text = (tweetDict["description"] as! String)
        if let userImageURL = NSURL(string:
        (tweetDict["profile_image_url"] as! String)),
          userImageData = NSData(contentsOfURL: userImageURL) {
            self.userImageView.image = UIImage(data: userImageData)
        }
      } catch let error as NSError {
        NSLog("JSON error: \(error)")
      }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

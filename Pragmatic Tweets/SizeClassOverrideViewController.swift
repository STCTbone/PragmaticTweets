//
//  SizeClassOverrideViewController.swift
//  Pragmatic Tweets
//
//  Created by Matthew Rieger on 11/5/15.
//  Copyright © 2015 Pragmatic Programmers LLC. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {
  
  var embeddedSplitVC : UISplitViewController!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSplitViewSegue" {
      embeddedSplitVC = segue.destinationViewController as! UISplitViewController
    }
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    if size.width > 480.0 {
      let overrideTraits = UITraitCollection(horizontalSizeClass: .Regular)
      setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
    } else {
      setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

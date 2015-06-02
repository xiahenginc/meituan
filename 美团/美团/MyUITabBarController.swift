//
//  MyUITabBarController.swift
//  nfclockios
//
//  Created by wxqdev on 15-4-23.
//  Copyright (c) 2015年 nfclock.iteasysoft.com. All rights reserved.
//

import UIKit

class MyUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor  = UIColor.colorWithHex("#213F7F")

        var vc0 = self.storyboard?.instantiateViewControllerWithIdentifier("nav") as! RootNavigationViewController
        var vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("nav") as! RootNavigationViewController
        var vc2 = self.storyboard?.instantiateViewControllerWithIdentifier("nav") as! RootNavigationViewController
        
        vc0.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"ic_nav_home_normal"), selectedImage:UIImage(named:"ic_nav_home_active"))
        vc1.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"ic_nav_opinion_normal"), selectedImage:UIImage(named:"ic_nav_opinion_active"))
        vc2.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:"ic_nav_me_normal"), selectedImage:UIImage(named:"ic_nav_me_active"))
        
        var vcs:Array<RootNavigationViewController> = [vc0,vc1,vc2]
        let arraytilte = ["首页按钮","第二个按钮","第三个按钮"]
        for var i = 0 ;i < vcs.count ; i++ {
            vcs[i].tabindex = i
            vcs[i].title = arraytilte[i]
        }

        self.viewControllers = vcs
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

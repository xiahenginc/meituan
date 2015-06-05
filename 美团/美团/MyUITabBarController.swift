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

        var vcs = Array<RootNavigationViewController>()
        
        var vc0 = self.storyboard?.instantiateViewControllerWithIdentifier("indextuangou") as! TabIndexTuangouViewController
        var vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("indexshangjia") as! TabIndexShangjiaViewController
        var vc2 = self.storyboard?.instantiateViewControllerWithIdentifier("indexwode") as! TabIndexWodeViewController
        var vc3 = self.storyboard?.instantiateViewControllerWithIdentifier("indexgengduo") as! TabIndexGengduoViewController
        
        var vcViews = [vc0,vc1,vc2,vc3]
        var imgs = ["ic_nav_home_normal","ic_nav_opinion_normal","ic_nav_me_normal","ic_nav_me_normal"]
        var imgssel = ["ic_nav_home_normal","ic_nav_opinion_normal","ic_nav_me_normal","ic_nav_me_normal"]
        let arraytilte = ["团购","商家","我的","更多"]
      
        var i = 0
        for vc in vcViews{
            var vcnav = RootNavigationViewController(rootViewController: vc)
            
            vcnav.tabBarItem = UITabBarItem(title:nil,image:UIImage(named:imgs[i]), selectedImage:UIImage(named:imgssel[i]))
            vcnav.title = arraytilte[i]
            i++
            vcs.append(vcnav)

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

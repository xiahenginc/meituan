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

        self.tabBar.barTintColor  = UIColor.colorWithHex("#efefef")
        self.tabBar.tintColor = UIColor.colorWithHex("#f96429")
        var vcs = Array<RootNavigationViewController>()
        
        var vc0 = self.storyboard?.instantiateViewControllerWithIdentifier("indextuangou") as! TabIndexTuangouViewController
        var vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("indexshangjia") as! TabIndexShangjiaViewController
        var vc2 = self.storyboard?.instantiateViewControllerWithIdentifier("indexgengduo") as! TabIndexGengduoViewController
        var vc3 = self.storyboard?.instantiateViewControllerWithIdentifier("indexwode") as! TabIndexWodeViewController
        
        var vcViews = [vc0,vc1,vc2,vc3]
        var imgs = ["menu1_1","menu2_1","menu3_1","menu4_1"]
        var imgssel = ["menu1_1","menu2_1","menu3_1","menu4_1"]
        let arraytilte = ["首页","分类","购物车","我的"]
      
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

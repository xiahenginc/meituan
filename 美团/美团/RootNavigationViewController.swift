//
//  RootNavigationViewController.swift
//  WorkTest
//
//  Created by wxqdev on 14-10-15.
//  Copyright (c) 2014年 wxqdev. All rights reserved.
//

import UIKit

var globals_attributes = [
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    //NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!
    NSFontAttributeName: UIFont.boldSystemFontOfSize(20)
]

class RootNavigationViewController: UINavigationController ,UINavigationControllerDelegate{

//    let arraytilte = ["首页标题","第二个标题","第三个标题"]
//    let arrayurl = ["http://i.meituan.com/","http://i.meituan.com/jiudian/touch/poi_prepose?stid=_b1&cevent=imt%2Fhomepage%2Fcategory1%2F20","http://i.meituan.com/nanjing?cid=10&stid=_b1&cateType=poi"]
    
    var tabindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationBar.barTintColor = UIColor.colorWithHex("#1984c8")
        
        self.navigationBar.titleTextAttributes = globals_attributes
//        if(self.viewControllers[0] is WebPageViewController){
//            let vc = self.viewControllers[0] as! WebPageViewController
//            vc.url = arrayurl[tabindex]
//            vc.title = arraytilte[tabindex]
//        }
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController,
        willShowViewController viewController: UIViewController,
        animated: Bool){
            if(viewController is TabIndexTuangouViewController
            || viewController is TabIndexShangjiaViewController
            || viewController is TabIndexWodeViewController
            || viewController is TabIndexGengduoViewController
                ){
                    self.navigationBarHidden = true
//                    viewController.navigationItem.leftBarButtonItem = nil
//                    viewController.navigationItem.hidesBackButton = true
//                    viewController.navigationItem.rightBarButtonItem = nil
            }
            if(viewController is WebPageViewController){
                let vc = viewController as! WebPageViewController
                if(self.navigationBarHidden){
                    //显示导航条
                    self.navigationBarHidden = false
                 
                }
                
                if(vc.level == 0){
                    viewController.navigationItem.leftBarButtonItem = nil
                    viewController.navigationItem.hidesBackButton = true
                    viewController.navigationItem.rightBarButtonItem = nil
                }
                else{
                    var btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                    btnBack.frame = CGRectMake(0, 0, 32, 32);
                    btnBack.setBackgroundImage(UIImage(named: "back_arrow_normal"), forState: UIControlState.Normal)
                    btnBack.addTarget(self, action: "onClickBack:", forControlEvents: UIControlEvents.TouchUpInside)
                    var leftBarButtonItem = UIBarButtonItem(customView:btnBack)
                    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
                }
        
            }
            
    }
    func onClickBack(sender: UIViewController) {
        self.popViewControllerAnimated(true)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

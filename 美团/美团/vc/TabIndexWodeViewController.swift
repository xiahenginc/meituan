//
//  TabIndexWodeViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/5.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class TabIndexWodeViewController: WebBaseViewController {

    override func viewDidLoad() {
        url = "http://app.nanmen.com18.cn/wap_ios/"
        
        myWebView = self.webView
        super.viewDidLoad()
        
        self.navigationItem.title = "我的"

        var btnTest = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnTest.frame = CGRectMake(0, 0, 64, 32);
        btnTest.setTitle("测试", forState: UIControlState.Normal)
        //btnSearch.setBackgroundImage(UIImage(named: "fh"), forState: UIControlState.Normal)
        btnTest.addTarget(self, action: "onClickTest:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnTest)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func onClickTest(sender: UIViewController) {
//        dispatch_async(dispatch_get_main_queue(), {
//            NSNotificationCenter.defaultCenter().postNotificationName("onLoginRefresh", object: nil)
//        })
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("localtest") as! LocalTestWebViewController
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    //我的
    var level = 0
    @IBOutlet weak var webView: UIWebView!
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

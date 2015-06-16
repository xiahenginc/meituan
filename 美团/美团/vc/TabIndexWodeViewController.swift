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
        myWebView = self.webView
        super.viewDidLoad()
        self.navigationItem.title = "我的"

        loadurl(url)
        
        var btnTest = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnTest.frame = CGRectMake(0, 0, 64, 32);
        btnTest.setTitle("测试", forState: UIControlState.Normal)
        //btnSearch.setBackgroundImage(UIImage(named: "fh"), forState: UIControlState.Normal)
        btnTest.addTarget(self, action: "onClickTest:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem = UIBarButtonItem(customView:btnTest)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func onClickTest(sender: UIViewController) {
        let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("localtest") as! LocalTestWebViewController

        self.navigationController?.pushViewController(dvc, animated: true)
    }
    //我的
    var url = "http://www.test.com18.cn/grwsj/login.htm"
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

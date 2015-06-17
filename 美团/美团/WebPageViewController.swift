//
//  WebPageViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/2.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class WebPageViewController: WebBaseViewController {

    override func viewDidLoad() {
        myWebView = self.webView
        super.viewDidLoad()
    }
    var level = 1
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

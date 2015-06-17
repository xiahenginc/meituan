//
//  TabIndexShangjiaViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/5.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit

class TabIndexShangjiaViewController: WebBaseViewController {

    override func viewDidLoad() {
        url = "http://www.grwtest.com18.cn/wap/ftype.jsp"

        myWebView = self.webView
        
        super.viewDidLoad()
        self.navigationItem.title = "分类"
     
    }
    //分类
    
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

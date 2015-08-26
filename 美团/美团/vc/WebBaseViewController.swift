//
//  WebBaseViewController.swift
//  美团
//
//  Created by wxqdev on 15/6/16.
//  Copyright (c) 2015年 meituan.iteasysoft.com. All rights reserved.
//

import UIKit



class WebBaseViewController: UIViewController {
    var webjs: WebJsHelper?
    var url = ""
    var myWebView:UIWebView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        webjs = WebJsHelper();
        webjs?.createBridge(self.myWebView, vc: self);
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoginRefresh:", name: "onLoginRefresh", object: nil)
        self.navigationController?.navigationBarHidden = true
        
        loadurl()

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onLoginRefresh(notification: NSNotification){
        refreshPage()
    }
    
       
    func refreshPage(){
       // loadurl()
        println("refresh page:\(self.myWebView?.request!.URL!.absoluteString)")
        myWebView?.reload()
    }
    
    func onClickTest(sender: UIViewController) {
//        var txt:String! = "这是个测试"
//        let jsonRes = JSON(["type":"req","param1":"success","param2":txt])
//        bridge.callHandler("calljs",data:jsonRes.object,responseCallback:{
//            data  in
//            let json = JSON(data)
//
//            if let p2 = json["param2"].string{
//                println("recv json===>\(p2)")
//            }
//            
//            
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loadurl(){
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        myWebView?.loadRequest(request)
        myWebView?.opaque = false
        myWebView?.backgroundColor = UIColor.clearColor()
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
